function [e] = test11(cleanup, level)
%TEST11 Filter tests

%   Thomas Ruark, 5/10/2006
%   Copyright 2006 Adobe Systems, Inc.


[a,b,c,d] = psconfig('pixels', 'pixels', 100, 'no');

psnewdoc(512, 512);

% top left is gray
x = uint8(ones(256,256,3)) * 127;
pssetpixels(x, 'undefined', 0, 0, 256, 256);

% top right is random
x = uint8(rand(256,256,3) * 255);
pssetpixels(x, 'undefined', 0, 256, 256, 512);

% bottom left is clouds, I don't know how to do clouds, and I like
% clouds with colors
psjavascript('app.activeDocument.selection.select([[0,256],[256,256],[256,512],[0,512],[0,256]]);');
cn = pschannelnames();
pssetactivechannels([cn(1)]);
psjavascript('app.activeDocument.activeLayer.applyClouds();');
pssetactivechannels([cn(2)]);
psjavascript('app.activeDocument.activeLayer.applyClouds();');
pssetactivechannels([cn(3)]);
psjavascript('app.activeDocument.activeLayer.applyClouds();');
pssetactivechannels(cn);
psjavascript('app.activeDocument.selection.deselect();');

% bottom right is gradient
x = uint8(zeros(256,256,3));
for i1 = 1:256
    x(i1,1:end,1) = [0:255];
end
for i1 = 1:256
    x(1:end,i1,2) = [0:255];
end
bb = uint16(x(:,:,1)) + uint16(x(:,:,2));
bb(find(bb > 255)) = bb(find(bb > 255)) - 256;
x(:,:,3) = uint8(bb);
pssetpixels(x, 'undefined', 256, 256, 512, 512);

psblur();
psjavascript('app.activeDocument.activeHistoryState = app.activeDocument.historyStates[app.activeDocument.historyStates.length - 2];');
psblurmore();
psjavascript('app.activeDocument.activeHistoryState = app.activeDocument.historyStates[app.activeDocument.historyStates.length - 2];');
psgaussianblur();
psjavascript('app.activeDocument.activeHistoryState = app.activeDocument.historyStates[app.activeDocument.historyStates.length - 2];');
psgaussianblur(12);
psjavascript('app.activeDocument.activeHistoryState = app.activeDocument.historyStates[app.activeDocument.historyStates.length - 2];');
pssharpen();
psjavascript('app.activeDocument.activeHistoryState = app.activeDocument.historyStates[app.activeDocument.historyStates.length - 2];');
pssharpenmore();
psjavascript('app.activeDocument.activeHistoryState = app.activeDocument.historyStates[app.activeDocument.historyStates.length - 2];');
pssharpenedges();
psjavascript('app.activeDocument.activeHistoryState = app.activeDocument.historyStates[app.activeDocument.historyStates.length - 2];');
psaverage();
psjavascript('app.activeDocument.activeHistoryState = app.activeDocument.historyStates[app.activeDocument.historyStates.length - 2];');
k=ones(25,1);
pscustom(k, 25);
psjavascript('app.activeDocument.activeHistoryState = app.activeDocument.historyStates[app.activeDocument.historyStates.length - 2];');
pshighpass();
psjavascript('app.activeDocument.activeHistoryState = app.activeDocument.historyStates[app.activeDocument.historyStates.length - 2];');
pshighpass(12);
psjavascript('app.activeDocument.activeHistoryState = app.activeDocument.historyStates[app.activeDocument.historyStates.length - 2];');
psmaximum();
psjavascript('app.activeDocument.activeHistoryState = app.activeDocument.historyStates[app.activeDocument.historyStates.length - 2];');
psmaximum(10);
psjavascript('app.activeDocument.activeHistoryState = app.activeDocument.historyStates[app.activeDocument.historyStates.length - 2];');
psminimum();
psjavascript('app.activeDocument.activeHistoryState = app.activeDocument.historyStates[app.activeDocument.historyStates.length - 2];');
psminimum(10);
psjavascript('app.activeDocument.activeHistoryState = app.activeDocument.historyStates[app.activeDocument.historyStates.length - 2];');
psoffset();
psjavascript('app.activeDocument.activeHistoryState = app.activeDocument.historyStates[app.activeDocument.historyStates.length - 2];');
psoffset(25, 25, 'wrap');
psjavascript('app.activeDocument.activeHistoryState = app.activeDocument.historyStates[app.activeDocument.historyStates.length - 2];');
psunsharpmask();
psjavascript('app.activeDocument.activeHistoryState = app.activeDocument.historyStates[app.activeDocument.historyStates.length - 2];');
psunsharpmask(60, 12, 12);
psjavascript('app.activeDocument.activeHistoryState = app.activeDocument.historyStates[app.activeDocument.historyStates.length - 2];');
psaddnoise();
psjavascript('app.activeDocument.activeHistoryState = app.activeDocument.historyStates[app.activeDocument.historyStates.length - 2];');
psaddnoise(50, 'gaussian', true);
psjavascript('app.activeDocument.activeHistoryState = app.activeDocument.historyStates[app.activeDocument.historyStates.length - 2];');
psdustandscratches();
psjavascript('app.activeDocument.activeHistoryState = app.activeDocument.historyStates[app.activeDocument.historyStates.length - 2];');
psdustandscratches(10, 2);
psjavascript('app.activeDocument.activeHistoryState = app.activeDocument.historyStates[app.activeDocument.historyStates.length - 2];');
psmedian(0);
psjavascript('app.activeDocument.activeHistoryState = app.activeDocument.historyStates[app.activeDocument.historyStates.length - 2];');
psmedian(2);
psjavascript('app.activeDocument.activeHistoryState = app.activeDocument.historyStates[app.activeDocument.historyStates.length - 2];');
pslensblur();
psjavascript('app.activeDocument.activeHistoryState = app.activeDocument.historyStates[app.activeDocument.historyStates.length - 2];');
pslensblur('none', 0, false, 'hexagon', 15, 0, 0, 0, 0, 0, 'uniform', false);
psjavascript('app.activeDocument.activeHistoryState = app.activeDocument.historyStates[app.activeDocument.historyStates.length - 2];');
psmotionblur();
psjavascript('app.activeDocument.activeHistoryState = app.activeDocument.historyStates[app.activeDocument.historyStates.length - 2];');
psmotionblur(2, 12);
psjavascript('app.activeDocument.activeHistoryState = app.activeDocument.historyStates[app.activeDocument.historyStates.length - 2];');
psradialblur();
psjavascript('app.activeDocument.activeHistoryState = app.activeDocument.historyStates[app.activeDocument.historyStates.length - 2];');
psradialblur(12, 'zoom', 'good');
psjavascript('app.activeDocument.activeHistoryState = app.activeDocument.historyStates[app.activeDocument.historyStates.length - 2];');
psshapeblur();
psjavascript('app.activeDocument.activeHistoryState = app.activeDocument.historyStates[app.activeDocument.historyStates.length - 2];');
psshapeblur(12, 'Banner 3');
psjavascript('app.activeDocument.activeHistoryState = app.activeDocument.historyStates[app.activeDocument.historyStates.length - 2];');
pssurfaceblur();
psjavascript('app.activeDocument.activeHistoryState = app.activeDocument.historyStates[app.activeDocument.historyStates.length - 2];');
pssurfaceblur(7, 20);
psjavascript('app.activeDocument.activeHistoryState = app.activeDocument.historyStates[app.activeDocument.historyStates.length - 2];');
pssmartblur();
psjavascript('app.activeDocument.activeHistoryState = app.activeDocument.historyStates[app.activeDocument.historyStates.length - 2];');
pssmartblur(5, 30, 'low', 'overlay');
psjavascript('app.activeDocument.activeHistoryState = app.activeDocument.historyStates[app.activeDocument.historyStates.length - 2];');
psboxblur();
psjavascript('app.activeDocument.activeHistoryState = app.activeDocument.historyStates[app.activeDocument.historyStates.length - 2];');
psboxblur(100);

psconfig(a, b, c, d);

if exist('cleanup', 'var') && cleanup
    while psnumdocs()
        psclosedoc(1);
    end
end

e = 'PASS';
