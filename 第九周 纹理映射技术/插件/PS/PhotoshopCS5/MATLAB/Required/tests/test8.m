function [e] = test8(cleanup, level)
%TEST8 pssetpixels, psgetpixels, psnewdocmatrix

%   Thomas Ruark, 01/28/2007
%   Copyright 2007 Adobe Systems, Inc.


[oru, otu, oh, odd] = psconfig('pixels', 'pixels', 5, 'no');
psnewdoc(255,255,72,'hello down');
[w,h,r,n]=psdocinfo();
r=psgetpixels();
nc=psnumchannels();
if ~isa(nc,'double')
    error('test8:type1', 'wrong type for number of channels');
end
for a = 1 : w
    for b = 1 : nc
        r(:,a,b)=1:255;
    end
end
pssetpixels(r);

psnewdoc(255,255,72,'hello across');
[w,h,r,n]=psdocinfo();
if ~isa(w,'double')
    error('test8:type2', 'wrong type for width');
end
if ~isa(h,'double')
    error('test8:type3', 'wrong type for height');
end
if ~isa(r,'double')
    error('test8:type4', 'wrong type for resolution');
end
if ~ischar(n)
    error('test8:type5', 'wrong type for name');
end
r=psgetpixels();
nc=psnumchannels();
for a = 1 : w
    for b = 1 : nc
        r(a,:,b)=1:255;
    end
end
pssetpixels(r);

psnewdoc(255,255,72,'hello wowsy');
[w,h,r,n]=psdocinfo();
if w ~= 255
    error('test8:value1', 'wrong value for width');
end
if h ~= 255
    error('test8:value2', 'wrong value for height');
end
if r ~= 72
    error('test8:value3', 'wrong value for resolution');
end
if ~strcmp(n, 'hello wowsy')
    error('test8:value4', 'wrong name of document');
end
r=psgetpixels();
for a = 1 : w
    r(a,:,1)=1:255;
    r(:,a,2)=1:255;
end
r(:,:,3)=uint8(zeros(255,255));
pssetpixels(r);

psnewdocmatrix(r);

rr = psgetpixels();

if length(rr(:)) ~= length(r(:))
    error('test8:value4', 'wrong pixel count');
end

rrr = rr == r;
rrrr = size(rr);
rrrr = rrrr(1) * rrrr(2) * rrrr(3);
if rrrr ~= length(rrr(:))
    error('test8:value5', 'wrong pixel count');
end

% W#1264459, cant create a cmyk document
% W#1470942, set units to inches and make a doc from a matrix, psdocmatrix
% needs to convert back to pixels, make the doc and then set back to units
m = { 'uint8' 'uint16' 'double' };
d = [ 1 3 4 ];
u = { 'cm', 'inches', 'pixels' }; % not all of them, 'mm', 'picas', 'points' };
for x = 1 : length(m)
    for xx = 1 : length(d)
        for xxx = 1 : length(u)
            psconfig(u{xxx});
            % you cannot do 32 bit cmyk documents
            if (xx ~= 3 || x ~= 3)
                p = zeros(10, 10, d(xx), m{x});
                psnewdocmatrix(p);
                xxu = psconfig();
                if ~strcmp(xxu, u{xxx})
                    error('test8:config', 'units are not what i set');
                end
                pp = psgetpixels();
                if ~isa(pp, m{x})
                    error('test8:value6', 'wrong pixel value type');
                end
            end
        end
    end
end

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

psnewlayer;
t = uint8(ones(256,256)*255);
pssetpixels(t, 16, 100, 100, 356, 356);
pssetpixels(x, 'undefined', 100, 100, 356, 356);

docLocation = '~/MATLABTest.psd';
psjavascriptu(['app.activeDocument.saveAs(File("' docLocation '"));']);

psclosedoc(1);
i1 = psimread(docLocation, false, true);
i2 = psimread(docLocation, true, true);
if length(i1) == length(i2)
    if sum(i1(:) == i2(:)) == length(i1(:))
        error('test8:length', 'the pixel arrays should be different in length');
    end
end

% W#1470942, set units to inches and make a doc from a matrix, psdocmatrix
% needs to convert back to pixels, make the doc and then set back to units
psconfig('inches');
x = uint8(rand(5,5,3) * 255);
psnewdocmatrix(x);

psconfig(oru, otu, oh, odd);

if exist('cleanup', 'var') && cleanup
    while psnumdocs()
        psclosedoc(1);
    end
end

e = 'PASS';
