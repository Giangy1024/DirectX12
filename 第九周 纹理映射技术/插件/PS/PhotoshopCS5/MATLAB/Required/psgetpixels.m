function p = psgetpixels(c, t, l, b, r)
%PSGETPIXELS    Get pixel data from current layer in Photoshop.
%   P = PSGETPIXELS() is a H-by-W-by-C pixel matrix containing all the 
%   active channels (C), the height (H), and width (W) of the document. For
%   an RGB document this would be a H-by-W-by-3 matrix.
%
%   P = PSGETPIXELS(1) is a H-by-W matrix containing the 'Red' channel data.
%   P = PSGETPIXELS('Red') is the same as above.
%
%   P = PSGETPIXELS(16) is the H-by-W transparency channel for the given
%   layer. The layer cannot be the background layer. It must be a standard
%   layer.
%
%   P = PSGETPIXELS(19) is the H-by-W selection channel for the given
%   selection.
%
%   C is the channel ID, either a string for the name of the channel or a
%   scalar with the following definitions: 
%             Red=1, Green=2, Blue=3,
%             Cyan=4, Magenta=5, Yellow=6, Black=7,
%             L=8, A=9, B=10,
%             Duotone=11, Index=12, Bitmap=13,
%             ColorSelected=14, ColorProtected=15,
%             Transparency=16, LayerMask=17,
%             InvertedLayerMask=18, SelectionMask=19, SpotColor=20
%
%   P = PSGETPIXELS('undefined', 0, 0, 10, 10) is a 10-by-10-C pixel matrix
%   containing the top left 10-by-10-C square pixel. C is the number of
%   active channels.
%
%   P = PSGETPIXELS('Red', 0, 0, 10, 10) is a 10-by-10 pixel matrix
%   containing the top left 10-by-10 of the Red channel.
%
%   Top, left, bottom, right must all be defined if one is defined. This,
%   for example, is illegal: p = psgetpixels('Red', 22 23);
%
%   The class of the matrix is 'uint8' for 8 bit depth documents, 'uint16'
%   for 16 bit depth documents, and 'double' for 32 bit depth documents.
%   'uint16' bit documents have the range of 0 <-> 32768 and 'double' bit
%   documents have the range of 0 <-> max double value.
%
%   This function only works on normal layers. Rasterize, flatten, or
%   ungroup layers as necessary to perform this function.
%
%   Example:
%   p = psgetpixels
%   p = psgetpixels(1)
%   p = psgetpixels('Red', 0, 0, 10, 10)
%
%   See also PSSETPIXELS, PSCONFIG, PSCHANNELNAMES, PSSETACTIVECHANNELS,
%   PSNUMCHANNELS

%   Thomas Ruark, 01/24/2007
%   Copyright 2007 Adobe Systems Incorporated

psmatfile = fullfile(tempdir, 'pspixels.bin');
psmatfile = strrep(psmatfile, '\', '\\');

if exist(psmatfile, 'file')
    delete(psmatfile);
end

pstext = 'var result = "";';
pstext = [pstext 'try {'];
pstext = [pstext 'var wos = $.os.search(/windows/i) != -1;'];
pstext = [pstext 'if ( LayerKind.NORMAL == activeDocument.activeLayer.kind ) {'];
pstext = [pstext 'var desc = new ActionDescriptor();'];
pstext = [pstext 'desc.putString( app.charIDToTypeID( "File" ), "' psmatfile '");'];
pstext = [pstext 'desc.putEnumerated( app.charIDToTypeID( "Cmd " ), app.charIDToTypeID( "TCmd" ), app.charIDToTypeID( "PMat" ) );'];

if exist('c', 'var')
    if isnumeric(c)
        pstext = [pstext '     desc.putInteger( charIDToTypeID( "Type" ), "' num2str(c) '" );'];
    elseif ischar(c)
        if ~strcmp(c, 'undefined')
            pstext = [pstext '     desc.putString( charIDToTypeID( "ChnN" ), "' c '" );'];
        end
    end
end

if exist('t', 'var') && exist('l', 'var') && exist('b', 'var') && exist('r', 'var')
    pstext = [pstext 'var rectDesc = new ActionDescriptor();'];
    pstext = [pstext  sprintf('rectDesc.putInteger( app.charIDToTypeID( "Top " ), %d);', t)];
    pstext = [pstext  sprintf('rectDesc.putInteger( app.charIDToTypeID( "Left" ), %d);', l)];
    pstext = [pstext  sprintf('rectDesc.putInteger( app.charIDToTypeID( "Btom" ), %d);', b)];
    pstext = [pstext  sprintf('rectDesc.putInteger( app.charIDToTypeID( "Rght" ), %d);', r)];
    pstext = [pstext 'desc.putObject( app.charIDToTypeID( "T   " ),  app.charIDToTypeID( "Type" ), rectDesc );'];
end

pstext = [pstext 'var result = app.executeAction( stringIDToTypeID( "733B7310-9259-48fd-8A07-24CF7521590D" ), desc, DialogModes.NO );'];
pstext = [pstext 'var rslt = app.charIDToTypeID( "Rslt" );'];
pstext = [pstext 'if ( result.hasKey( rslt ) ) {'];
pstext = [pstext '    var needOK = result.getEnumerationValue( rslt );'];
pstext = [pstext '    if ( needOK == app.charIDToTypeID( "OK  " ) )'];
pstext = [pstext '         result = "OK";'];
pstext = [pstext '    else if ( needOK == app.charIDToTypeID( "NoCd" ) )'];
pstext = [pstext '         result = wos ? localize( "$$$/JavaScripts/MATLAB/NoCommand=No command found" ) : localize( "$$$/private/JavaScripts/MATLAB/NoCommand/mac=No command found" );'];
pstext = [pstext '    else if ( needOK == app.charIDToTypeID( "NoPt" ) )'];
pstext = [pstext '         result = wos ? localize( "$$$/JavaScripts/MATLAB/NoPointer=No pointer found" ) : localize( "$$$/private/JavaScripts/MATLAB/NoPointer/mac=No pointer found" );'];
pstext = [pstext '    else if ( needOK == app.charIDToTypeID( "NoTo" ) )'];
pstext = [pstext '         result = wos ? localize( "$$$/JavaScripts/MATLAB/NoTo=No target found" ) : localize( "$$$/private/JavaScripts/MATLAB/NoTo/mac=No target found" );'];
pstext = [pstext '    else if ( needOK == app.charIDToTypeID( "NoTC" ) )'];
pstext = [pstext '         result = wos ? localize( "$$$/JavaScripts/MATLAB/NoTargetChannel=No target channel" ) : localize( "$$$/private/JavaScripts/MATLAB/NoTargetChannel/mac=No target channel" );'];
pstext = [pstext '    else if ( needOK == app.charIDToTypeID( "Unsp" ) )'];
pstext = [pstext '         result = wos ? localize( "$$$/JavaScripts/MATLAB/Unsupported=Unsupported configuration" ) : localize( "$$$/private/JavaScripts/MATLAB/Unsupported/mac=Unsupported configuration" );'];
pstext = [pstext '    else if ( needOK == app.charIDToTypeID( "memF" ) )'];
pstext = [pstext '         result = wos ? localize( "$$$/JavaScripts/MATLAB/MemoryFull=Memory full" ) : localize( "$$$/private/JavaScripts/MATLAB/MemoryFull/mac=Memory full" );'];
pstext = [pstext '    else if ( needOK == app.charIDToTypeID( "Dmsm" ) )'];
pstext = [pstext '         result = wos ? localize( "$$$/JavaScripts/MATLAB/DataMismatch=Data mismatch" ) : localize( "$$$/private/JavaScripts/MATLAB/DataMismatch/mac=Data mismatch" );'];
pstext = [pstext '    else if ( needOK == app.charIDToTypeID( "Dpms" ) )'];
pstext = [pstext '         result = wos ? localize( "$$$/JavaScripts/MATLAB/DepthMismatch=Depth mismatch" ) : localize( "$$$/private/JavaScripts/MATLAB/DepthMismatch/mac=Depth mismatch" );'];
pstext = [pstext '    else if ( needOK == app.charIDToTypeID( "Pmsm" ) )'];
pstext = [pstext '         result = wos ? localize( "$$$/JavaScripts/MATLAB/PlanesMismatch=Planes Mismatch" ) : localize( "$$$/private/JavaScripts/MATLAB/PlanesMismatch/mac=Planes Mismatch" );'];
pstext = [pstext '    else if ( needOK == app.charIDToTypeID( "Bmsm" ) )'];
pstext = [pstext '         result = wos ? localize( "$$$/JavaScripts/MATLAB/BoundsMismatch=Bounds Mismatch" ) : localize( "$$$/private/JavaScripts/MATLAB/BoundsMismatch/mac=Bounds Mismatch" );'];
pstext = [pstext '    else if ( needOK == app.charIDToTypeID( "NoMt" ) )'];
pstext = [pstext '         result = wos ? localize( "$$$/JavaScripts/MATLAB/NoMatFile=No Mat File" ) : localize( "$$$/private/JavaScripts/MATLAB/NoMatFile/mac=No Mat File" );'];
pstext = [pstext '    else if ( needOK == app.charIDToTypeID( "PSEr" ) )'];
pstext = [pstext '         result = wos ? localize( "$$$/JavaScripts/MATLAB/PhotoshopError=Photoshop Error" ) : localize( "$$$/private/JavaScripts/MATLAB/PhotoshopError/mac=Photoshop Error" );'];
pstext = [pstext '    else if ( needOK == app.charIDToTypeID( "NoCd" ) )'];
pstext = [pstext '         result = wos ? localize( "$$$/JavaScripts/MATLAB/NoCommand=No command found" ) : localize( "$$$/private/JavaScripts/MATLAB/NoCommand/mac=No command found" );'];
pstext = [pstext '    else if ( needOK == app.charIDToTypeID( "FtNo" ) )'];
pstext = [pstext '         result = wos ? localize( "$$$/JavaScripts/MATLAB/FeatureDisabled=MATLAB feature is not enabled" ) : localize( "$$$/private/JavaScripts/MATLAB/FeatureDisabled/mac=MATLAB feature is not enabled" );'];
pstext = [pstext '    else'];
pstext = [pstext '         result = wos ? localize( "$$$/JavaScripts/MATLAB/Unknown=Unknown error occured" ) : localize( "$$$/private/JavaScripts/MATLAB/Unknown/mac=Unknown error occured" );'];
pstext = [pstext '}'];
pstext = [pstext '} else {']; % this is the if LayerKind.NORMAL
pstext = [pstext '  result = wos ? localize( "$$$/JavaScripts/MATLAB/LayerNeedsNormal=Layer needs to be a NORMAL layer: " ) : localize( "$$$/private/JavaScripts/MATLAB/LayerNeedsNormal/mac=Layer needs to be a NORMAL layer: " );'];
pstext = [pstext '  result = result + activeDocument.activeLayer.kind;'];
pstext = [pstext '}']; % end of if LayerKind.NORMAL
pstext = [pstext '}']; % this is the try/catch ender
pstext = [pstext 'catch(e) {'];
pstext = [pstext '    result = e.toString();'];
pstext = [pstext '}'];
pstext = [pstext 'result;'];

psresult = psjavascriptu(pstext);

if strcmp(psresult, 'OK')
    f = fopen(psmatfile);
    if f
        v = fread(f, 1, 'int32');
        if v ~= 1
            return;
        end
        w = fread(f, 1, 'int32');
        h = fread(f, 1, 'int32');
        pd = fread(f, 1, 'int32');
        bpp = fread(f, 1, 'int32');

        if bpp == 1
            bppstr = 'uint8';
        elseif bpp == 2
            bppstr = 'uint16';
        else
            bppstr = 'single';
        end

        p = fread(f, h * w * pd, bppstr);

        fclose(f);

        p = reshape(p, h, w, pd);

        if bpp == 1
            p = uint8(p);
        elseif bpp == 2
            p = uint16(p);
        else
            p = double(p);
        end

        delete(psmatfile);
    end
else
    if exist(psmatfile, 'file')
        delete(psmatfile);
    end
    error(psresult);
end
