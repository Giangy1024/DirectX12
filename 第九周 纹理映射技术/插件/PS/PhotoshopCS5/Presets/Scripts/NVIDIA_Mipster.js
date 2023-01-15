// $Id: //sw/devrel/SDK/TOOLS/src/Photoshop/scripts/NVIDIA_Mipster.jsx#1 $
//
#target photoshop

// in case we double clicked the file
app.bringToFront();

//
// Copyright NVIDIA Corporation 2005
// TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, THIS SOFTWARE IS PROVIDED
// *AS IS* AND NVIDIA AND ITS SUPPLIERS DISCLAIM ALL WARRANTIES, EITHER EXPRESS
// OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF MERCHANTABILITY
// AND FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT SHALL NVIDIA OR ITS SUPPLIERS
// BE LIABLE FOR ANY SPECIAL, INCIDENTAL, INDIRECT, OR CONSEQUENTIAL DAMAGES
// WHATSOEVER (INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF BUSINESS PROFITS,
// BUSINESS INTERRUPTION, LOSS OF BUSINESS INFORMATION, OR ANY OTHER PECUNIARY LOSS)
// ARISING OUT OF THE USE OF OR INABILITY TO USE THIS SOFTWARE, EVEN IF NVIDIA HAS
// BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.
//
// Description:
//	This script works with Adobe Photoshop CS2 or better.
//	The script runs on both Windows or Mac-OS versions of Photoshop.
//	The script should work with all color spaces and pixel depths
//	To use, have an image open and run the script from Photoshop's "File->Automate" menu.
//
// Installation:
//	Place this script in your Photoshop Presets\Scripts directory and re-start Photoshop.
//	The script will then appear in your "File->Automate->Scripts..." menu items.
//	For more info on Photoshop scripting, see
//		http://partners.Adobe.com/public/developer/photoshop/devcenter.html
//

//
// TO-DO: assign normal maps - note the map must have 3 or 4 channels for that to work!
// unify UI dialogs
// Slice existing flattened MIPs
// re-mip from middle of chain (for user repaint in middle)
// map MS-format to our format
//

// global values /////////

var gDepthScale = 8.0;
var gFilterMethod = ResampleMethod.BICUBIC;
var gUWrap = true;
var gVWrap = true;
var gDepthFade = 1.0;
var gColorFade = false;
var gColorFadeAmount = 0.15;
var gDPI = 72.0;
var gDoNormal = false;
var gSplitAlpha = false;

// functions /////////

function version_string()
{
	var p4Version = '$Revision: #1 $'; // following perforce's version of RCS
	var m = /\d+/.exec(p4Version);
	if (m != "") {
		return m;
	}
	return p4Version;
}

///////

function boundArray(Left,Right,Bottom,Top)
{
	var b = new Array(new Array(Left,Bottom),new Array(Right,Bottom),new Array(Right,Top), new Array(Left,Top));
	return (b);
}

///////

function apply_nv_normal_filter(Amount)
{
	var id7 = stringIDToTypeID( "d9543b0c-3c91-11d4-97bc-00b0d0204936" );
	var desc3 = new ActionDescriptor();
	var id8 = charIDToTypeID( "Amnt" );
	var id9 = charIDToTypeID( "#Prc" );
	desc3.putUnitDouble( id8, id9, Amount );
	var id10 = charIDToTypeID( "filT" );
	var id11 = charIDToTypeID( "typT" );
	var id12 = charIDToTypeID( "fil4" );
	desc3.putEnumerated( id10, id11, id12 );
	var id13 = charIDToTypeID( "conV" );
	var id14 = charIDToTypeID( "typC" );
	var id15 = charIDToTypeID( "cnv1" );
	desc3.putEnumerated( id13, id14, id15 );
	var id16 = charIDToTypeID( "alph" );
	var id17 = charIDToTypeID( "typA" );
	var id18 = charIDToTypeID( "alp1" );
	desc3.putEnumerated( id16, id17, id18 );
	var id19 = charIDToTypeID( "wrap" );
	desc3.putBoolean( id19, false );
	executeAction( id7, desc3, DialogModes.NO );
}

///////////////////////

function user_dialog()
{
	var vers = version_string();
	var title = "NVIDIA Mipster V" + vers;
	var dLeft = 100;
	var dTop = 100;
	var dWidth = 420;
	var dHeight = 395;
	var oy = 15;
	if (app.activeDocument.channels.length > 3) {
		dHeight += 40
	}
	//
	var dlg = new Window('dialog', title, [dLeft,dTop,dWidth,dHeight]);
	dlg.ipnl = dlg.add('panel', [15,oy,305,oy+45], 'Interpolator');
	dlg.ipnl.helpTip = "Choose the Resize Method for Building MIP Levels";
	dlg.ipnl.smoothRb = dlg.ipnl.add('radiobutton',[15,15,95,35],'Smooth');
	dlg.ipnl.smoothRb.helpTip = "Bicubic Smooth";
	dlg.ipnl.normalRb = dlg.ipnl.add('radiobutton',[105,15,185,35],'Normal');
	dlg.ipnl.normalRb.helpTip = "Bicubic";
	dlg.ipnl.sharpRb = dlg.ipnl.add('radiobutton',[195,15,275,35],'Sharp');
	dlg.ipnl.sharpRb.helpTip = "Bicubic Sharp";
	dlg.ipnl.smoothRb.value = false;
	dlg.ipnl.normalRb.value = true;
	dlg.ipnl.sharpRb.value = false;
	oy += 55;
	//
	dlg.wpnl = dlg.add('panel', [15,oy,305,oy+45], 'Wrap Directions');
	dlg.wpnl.helpTip = "Define texture wrap modes for best-quality filtering";
	dlg.wpnl.wrapUBtn = dlg.wpnl.add('checkbox',[55,15,135,35],'U');
	dlg.wpnl.wrapUBtn.helpTip = "Check to create horizontal texture wrap";
	dlg.wpnl.wrapVBtn = dlg.wpnl.add('checkbox',[145,15,225,35],'V');
	dlg.wpnl.wrapVBtn.helpTip = "Check to create vertical texture wrap";
	dlg.wpnl.wrapUBtn.value = gUWrap;
	dlg.wpnl.wrapVBtn.value = gVWrap;
	oy += 55;
	//
	dlg.npnl = dlg.add('panel', [15,oy,305,oy+45], 'Normal Mapping');
	dlg.npnl.helpTip = "For Use with the NVIDIA Normal-Map Filter";
	dlg.npnl.normBtn = dlg.npnl.add('checkbox',[15,15,55,35],'On');
	dlg.npnl.normBtn.helpTip = "Interpret the current image as a height pap, and generate normals?";
	dlg.npnl.normBtn.value = gDoNormal;
	dlg.npnl.scTxt = dlg.npnl.add('statictext',[100,15,135,35],"Scale");
	dlg.npnl.scTxt.helpTip = "Scale for height data with generating normals";
	dlg.npnl.deepTxt = dlg.npnl.add('edittext',[65,15,95,35],gDepthScale);
	dlg.npnl.deepTxt.helpTip = "Scale for height data with generating normals";
	dlg.npnl.fader = dlg.npnl.add('slider',[140,15,240,35],gDepthFade,0.0,1.0);
	dlg.npnl.fader.helpTip = "Fade-down height for smaller MIPs";
	dlg.npnl.fdTxt = dlg.npnl.add('statictext',[250,15,275,35],"Fade");
	dlg.npnl.fdTxt.helpTip = "Fade-down height for smaller MIPs";
	oy += 55;
	//
	dlg.cpnl = dlg.add('panel', [15,oy,305,oy+45], 'Fade to Fg Color');
	dlg.cpnl.helpTip = "Add overlays to fade smaller MIP levels toward the current FG Color";
	dlg.cpnl.fadeCBtn = dlg.cpnl.add('checkbox',[25,15,65,35],'On');
	dlg.cpnl.fadeCBtn.helpTip = "Check to add transparent color overlays";
	dlg.cpnl.fadeCBtn.value = gColorFade;
	dlg.cpnl.fadeC = dlg.cpnl.add('slider',[100,15,200,35],gColorFadeAmount,0.0,1.0);
	dlg.cpnl.fadeC.helpTip = "Fade color in a bit more for each smaller MIP level";
	dlg.cpnl.fcTxt = dlg.cpnl.add('statictext',[210,15,275,35],"Amt/MIP");
	dlg.cpnl.fcTxt.helpTip = "Fade color in a bit more for each smaller MIP level";
	oy += 55;
	//
	if (app.activeDocument.channels.length > 3) {
		dlg.apnl = dlg.add('panel', [15,oy,305,oy+45], 'Alpha Handling');
		dlg.apnl.helpTip = "How to handle Alpha data for this image?";
		dlg.apnl.perBtn = dlg.apnl.add('checkbox',[55,15,135,35],'Per-MIP');
		dlg.apnl.perBtn.helpTip = "Check to get an extra separable channel for each MIP alpha";
		dlg.apnl.perBtn.value = gSplitAlpha;
		oy += 55;
	}
	//
	dlg.okayBtn = dlg.add('button', [185,oy,245,oy+40],'Okay', {name:'ok'});
	dlg.cancelBtn = dlg.add('button', [70,oy,130,oy+40],'Cancel', {name:'cancel'});
	with (dlg) {
		okayBtn.onClick = function () {this.parent.close(1); }
		cancelBtn.onClick = function () {this.parent.close(2); }
	}
	var result = dlg.show();
	if (result == 2) { return (-1); }
	gUWrap = dlg.wpnl.wrapUBtn.value;
	gVWrap = dlg.wpnl.wrapVBtn.value;
	gDoNormal = dlg.npnl.normBtn.value;
	gColorFade = dlg.cpnl.fadeCBtn.value;
	if (app.activeDocument.channels.length > 3) {
		gSplitAlpha = dlg.apnl.perBtn.value;
	}
	if (dlg.ipnl.smoothRb.value == true) {
		gFilterMethod = ResampleMethod.BICUBICSMOOTHER; }
	if (dlg.ipnl.sharpRb.value == true) {
		gFilterMethod = ResampleMethod.BICUBICSHARPER; }
	gDepthScale = dlg.npnl.deepTxt.text;
	if (gDepthScale < 1.0) {
		gDepthScale = 1.0;
		if (gDoNormal) {
			alert("Caution: Setting normal-map depth scale to min value 1.0");
		}
	}
	if (gDepthScale > 24.0) {
		gDepthScale = 24.0;
		if (gDoNormal) {
			alert("Setting normal-map depth scale to max value 24.0");
		}
	}
	gDepthFade = dlg.npnl.fader.value;
	gColorFadeAmount = dlg.cpnl.fadeC.value;
	return 1;
}

// Extend channel selection /////////////////////////////////////

function select_all_channels(theDoc) {
	app.activeDocument = theDoc;
	var addChannelIndex = 0;
	var channelSelection = new Array();
	for(var channelIndex = 0; channelIndex < app.activeDocument.channels.length; channelIndex++) {
		channelSelection[addChannelIndex++] = app.activeDocument.channels[channelIndex]
	}
	app.activeDocument.activeChannels = channelSelection;
}

///////

function select_rgb_channels(theDoc) {
	app.activeDocument = theDoc;
	var addChannelIndex = 0;
	var channelSelection = new Array();
	for(var channelIndex = 0; channelIndex < 3; channelIndex++) {
		channelSelection[addChannelIndex++] = app.activeDocument.channels[channelIndex]
	}
	app.activeDocument.activeChannels = channelSelection;
}

///////

function select_alpha_channel(theDoc) {
	app.activeDocument = theDoc;
	if (theDoc.channels.length <= 3) {
		return false; // fail - no alpha
	}
	var channelSelection = new Array();
	channelSelection[0] = app.activeDocument.channels[3];
	app.activeDocument.activeChannels = channelSelection;
	return true; // success
}

///////////////////////

// Generate data for WrapDoc and return a bound for the central area.
// side effect: "WrapDoc" may end up getting resized.
//   This is generally okay as it is a temporary doc that will be soon
//	thrown-away.
function build_wrap_doc(WrapDoc)
{
	var wasDoc = app.activeDocument;
	app.activeDocument = WrapDoc;
	if (gUWrap || gVWrap) {
		var w = WrapDoc.width;
		var h = WrapDoc.height;
		var wBound = boundArray(0,w,0,h);
		var nw = w * (gUWrap ? 3 : 1);
		var nh = h * (gVWrap ? 3 : 1);
		WrapDoc.resizeCanvas(nw,nh,AnchorPosition.MIDDLECENTER);
		var cw = (gUWrap ? w : 0);
		var ch = (gVWrap ? h : 0);
		var ctrBound = boundArray(cw,cw+w,ch,ch+h);
		select_rgb_channels(WrapDoc);
		WrapDoc.selection.select(ctrBound);
		WrapDoc.selection.copy();
		var x = 0
			for (var n=(gUWrap?-1:0); n<=(gUWrap?1:0); n++) {
				var y = 0
					for (var m=(gVWrap?-1:0); m<=(gVWrap?1:0); m++) {
						var pasteBound = boundArray(x,x+w,y,y+h);
						WrapDoc.selection.select(pasteBound);
						var nLayer = WrapDoc.paste();
						y += h
					}
				x += w
			}
		if (select_alpha_channel(WrapDoc)) {
			var x = 0
				for (var n=(gUWrap?-1:0); n<=(gUWrap?1:0); n++) {
					var y = 0
						for (var m=(gVWrap?-1:0); m<=(gVWrap?1:0); m++) {
							var pasteBound = boundArray(x,x+w,y,y+h);
							WrapDoc.selection.select(ctrBound);
							WrapDoc.selection.copy();
							WrapDoc.selection.select(pasteBound);
							var nLayer = WrapDoc.paste();
							y += h
						}
					x += w
				}
		}
		select_rgb_channels(WrapDoc);
		WrapDoc.selection.deselect();
	}
	WrapDoc.flatten();
	app.activeDocument = wasDoc;
}

////////////

var duplicateDocument = function(doc, name, merged) {
	function _ftn() {
		var desc = new ActionDescriptor();
		var ref = new ActionReference();
		ref.putEnumerated(charIDToTypeID("Dcmn"), charIDToTypeID("Ordn"), charIDToTypeID("Frst"));
		desc.putReference(charIDToTypeID("null"), ref );
		if (name) {
			desc.putString(charIDToTypeID("Nm  "), name);
		}
		if (merged == true) {
			desc.putBoolean(charIDToTypeID("Mrgd"), true);
		}
		executeAction(charIDToTypeID("Dplc"), desc, DialogModes.NO );
		return app.activeDocument;
	}
	return _ftn();
};

////////////

// put data for new MIP level in NEW DOCUMENT and return that doc
function generate_and_copy_mip_data(MipSrcDoc,DestDoc,DestBound,MipW,MipH,DScale,DoNormal,LayerName)
{
	app.activeDocument = MipSrcDoc;
	var tempName = "Lev"+MipW.value;
	var tempDoc = duplicateDocument(MipSrcDoc,tempName,true); // last arg superfluous?
	// tempDoc.flatten(); // redundant
	var nw = MipW * (gUWrap ? 3 : 1);
	var nh = MipH * (gVWrap ? 3 : 1);
	var cw = MipW * (gUWrap ? 1 : 0);
	var ch = MipH * (gVWrap ? 1 : 0);
	tempDoc.resizeImage(nw,nh,gDPI,gFilterMethod);
	// get normal mapping here....
	tempDoc.selection.selectAll();
	if (DoNormal) {
		apply_nv_normal_filter(gDepthScale/DScale);	// assign weight?
	}
	select_rgb_channels(tempDoc);
	var srcBound = boundArray(cw,cw+MipW,ch,ch+MipH);
	// tempDoc.crop(srcBound);
	tempDoc.selection.select(srcBound);
	tempDoc.selection.copy();
	app.activeDocument = DestDoc;
	DestDoc.selection.select(DestBound);
	select_rgb_channels(DestDoc);
	var newLayer = DestDoc.paste(true);
	newLayer.name = LayerName
		if (DoNormal) {
			newLayer.visible = false;
		}
	if (MipSrcDoc.channels.length > 3) {
		app.activeDocument = tempDoc;
		select_alpha_channel(tempDoc);
		tempDoc.selection.select(srcBound);
		tempDoc.selection.copy();
		app.activeDocument = DestDoc;
		var channelSelection = new Array();
		if (gSplitAlpha) {
			var newAlpha = DestDoc.channels.add();
			newAlpha.name = "AMip "+MipW.value;
			channelSelection[0] = newAlpha;
			app.activeDocument.activeChannels = channelSelection;
			DestDoc.selection.select(DestBound);
			DestDoc.paste(true);
		}
		channelSelection[0] = app.activeDocument.channels[3]; // mipster doc merged alpha
		app.activeDocument.activeChannels = channelSelection;
		DestDoc.selection.select(DestBound);
		DestDoc.paste(true);
		select_rgb_channels(DestDoc);
	}
	// now get rid of tempDoc
	app.activeDocument = tempDoc;
	tempDoc.close(SaveOptions.DONOTSAVECHANGES);
}

//////////// this could be prettier but it does the job //

function mip_width(W,H) {
	var limit = Math.log(Math.max(W,H)) / Math.log(2.0);
	var total = W;
	var newMipW = W/2.0;
	newMipW = Math.floor(newMipW);
	for (var powOf2=1; powOf2<=limit; powOf2++) {
		total += newMipW;
		newMipW /= 2.0;
		newMipW = Math.floor(newMipW);
		if (newMipW < 1.0) newMipW = 1.0;
	}
	// alert("Width will be "+total+" based on ["+W+","+H+"]");
	return(total);
}

function is_power_of_two(a) {
	var p = Math.floor(Math.log(a) / Math.log(2.0));
	var n = Math.pow(2.0,p);
	return (n==a);
}

////////////

function main_body()
{
	if (!app.documents.length > 0) {    // stop if no document is opened.
		alert("Sorry, No Current Document");
		return;
	}
	var origDoc = app.activeDocument;
	//    if (origDoc.width != origDoc.height) {
	//	alert("Sorry, I prefer square pics right now");
	//	return;
	//    }
	var strtRulerUnits = app.preferences.rulerUnits;
	if (strtRulerUnits != Units.PIXELS) {
		app.preferences.rulerUnits = Units.PIXELS; // selections are always in pixels
	}
	var w = origDoc.width;
	var h = origDoc.height;
	if (!is_power_of_two(w.value)) {
		alert("Caution: Width "+w.value+" pixels is not a power of two");
	}
	if (!is_power_of_two(h.value)) {
		alert("Caution: Height "+h.value+" pixels is not a power of two");
	}
	//
	var e = user_dialog();
	if (e == -1) return;
	var origBG = app.backGroundColor;
	var black = new SolidColor();
	black.rgb.red =  0.0;
	black.rgb.green =  0.0;
	black.rgb.blue =  0.0;
	app.backGroundColor = black;
	var mipsterName = "Mipster-" + origDoc.name;
	var mipsterDoc = duplicateDocument(origDoc,mipsterName,true); // last arg superfluous?
	mipsterDoc.info.source = "Made from '" + origDoc.name + "' by Mipster V" + version_string();
	mipsterDoc.info.category = "TextureMap";
	mipsterDoc.flatten();
	mipsterDoc.resizeImage(w,h,gDPI);
	if ((mipsterDoc.mode == DocumentMode.BITMAP)||
			(mipsterDoc.mode == DocumentMode.CMYK)||
			(mipsterDoc.mode == DocumentMode.DUOTONE)||
			(mipsterDoc.mode == DocumentMode.GRAYSCALE)||
			(mipsterDoc.mode == DocumentMode.INDEXEDCOLOR)) {
		mipsterDoc.changeMode(DocumentMode.RGB);
	}
	var origBound = boundArray(0,w,0,h);
	// build wrap doc
	var mipName = "MipSrc";
	var mipSrcDoc = duplicateDocument(mipsterDoc,mipName,true); // last arg superfluous?
	build_wrap_doc(mipSrcDoc);

	app.activeDocument = mipsterDoc;
	var sizeLabel = Math.max(w.value,h.value);
	if (select_alpha_channel(mipsterDoc)) {
		if (gSplitAlpha) {
			mipsterDoc.selection.select(origBound);
			mipsterDoc.selection.copy();
			var newAlpha = mipsterDoc.channels.add();
			newAlpha.name = "AMip "+sizeLabel;
			mipsterDoc.paste(true);
		}
	}
	select_all_channels(mipsterDoc);
	mipsterDoc.selection.select(origBound);
	mipsterDoc.selection.copy();
	app.backGroundColor = black;
	mipsterDoc.resizeCanvas(mip_width(w,h),h,AnchorPosition.MIDDLELEFT);
	mipsterDoc.flatten(); // all layers rebuilt...
	var baseLayer = mipsterDoc.activeLayer;
	baseLayer.name = "Base"+sizeLabel;
	mipsterDoc.selection.select(origBound);
	mipsterDoc.selection.invert();
	mipsterDoc.selection.fill(black);
	var prevWidth = w;
	var newMipW = w/2.0;
	if (newMipW < 1.0) newMipW = 1.0;
	var newMipH = h/2.0;
	if (newMipH < 1.0) newMipH = 1.0;
	var limit = Math.log(Math.max(w,h)) / Math.log(2.0);
	var colorFade = gColorFadeAmount; // unused if no colorFade
	for (var powOf2=1; powOf2<=limit; powOf2++) {
		var depthScale = Math.pow(Math.pow(2.0,gDepthFade),powOf2);
		var newTotalW = prevWidth + newMipW;
		var newBound = boundArray(prevWidth,newTotalW,0,newMipH);
		sizeLabel = Math.max(newMipW.value,newMipH.value);
		generate_and_copy_mip_data(mipSrcDoc,mipsterDoc,newBound,newMipW,newMipH,depthScale,false,("MIP"+sizeLabel));
		if (gDoNormal) {
			generate_and_copy_mip_data(mipSrcDoc,mipsterDoc,newBound,newMipW,newMipH,depthScale,true,("Norm"+sizeLabel));
		}
		app.activeDocument = mipsterDoc;
		if (gColorFade) {
			var fLayer = mipsterDoc.artLayers.add();
			fLayer.name = ("Fade"+sizeLabel);
			mipsterDoc.selection.select(newBound);
			mipsterDoc.selection.fill(foregroundColor);
			fLayer.fillOpacity = (colorFade * 100.0);
		}
		newMipW = newMipW / 2.0;
		if (newMipW < 1.0) newMipW = 1.0;
		newMipH = newMipH / 2.0;
		if (newMipH < 1.0) newMipH = 1.0;
		colorFade = 1.0 - (1.0-gColorFadeAmount)*(1.0-colorFade);
		prevWidth = newTotalW;
	}
	app.activeDocument = mipsterDoc;
	mipsterDoc.activeLayer = baseLayer;
	mipsterDoc.selection.select(origBound);
	mipsterDoc.selection.invert();
	mipsterDoc.selection.fill(black);
	app.activeDocument = mipSrcDoc;
	mipSrcDoc.close(SaveOptions.DONOTSAVECHANGES);
	app.activeDocument = mipsterDoc;
	mipsterDoc.selection.deselect();
	select_rgb_channels(mipsterDoc);
	if (strtRulerUnits != Units.PIXELS) {
		app.preferences.rulerUnits = strtRulerUnits;
	}
	app.backGroundColor = origBG;
}

main_body();

// eof

