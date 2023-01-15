function [] = psavitophotoshop( infile )
%PSAVITOPHOTOSHOP    Load an avi file into Photoshop as layers.
%   PSAVITOPHOTOSHOP Allows loading of avi files into Photoshop as layers.
%   It then makes an animation out of the layers. This demo shows some of
%   the features of the Photoshop Toolbox.
%
%   Example:
%   psavitophotoshop( 'psintrowalk.avi' )
%

%   Scott Cohen, 10/23/2006
%   Copyright 2006 Adobe Systems Incorporated


psjavascriptu('app.bringToFront()');
oldp = psconfig('pixels');
IS = readavimovieframesintomemory(infile); % limit the number of frames with something like this ,1:3:60);
psnewdoc(size(IS,2),size(IS,1),72,infile,'rgb');
for f=size(IS,4):-1:1
    psnewlayermatrix(IS(:,:,:,f));
    layername = sprintf('frame %d', f);
    psjavascriptu(['app.activeDocument.activeLayer.name = "' layername '";']);
    % add in wait for redraw to watch the frames load one by one
end

% get rid of the background layer
psjavascriptu('app.activeDocument.artLayers[app.activeDocument.artLayers.length - 1].remove()');

% make animation from layers
psjavascriptu('var id11 = stringIDToTypeID( "animationFramesFromLayers" ); var desc4 = new ActionDescriptor();executeAction( id11, desc4, DialogModes.NO );');

psconfig(oldp);



% helper routine for configuring the frames
function I = readavimovieframesintomemory(filename, frames)

fileinfo = aviinfo(filename)
if (nargin < 2)
    frames = 1:(fileinfo.NumFrames);
end

IS = aviread(filename,frames);

I = repmat(uint8(0),[size(IS(1).cdata,1) size(IS(1).cdata,2) size(IS(1).cdata,3) length(IS)]);
for t=1:length(IS)
    I(:,:,:,t) = IS(t).cdata;
end


