function [e] = test5(cleanup, level)
%TEST5 Histogram tests

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

hold off
h = pshistogram(1);
subplot(121); plot(h);
hold on
h = pshistogram();
plot(h, 'black');
x = pschannelnames;
legend([x 'Luminosity']);
subplot(122); imagesc(psgetpixels());
psconfig(a,b,c,d);

if exist('cleanup', 'var') && cleanup
    psclosedoc(1);
end

e = 'PASS';