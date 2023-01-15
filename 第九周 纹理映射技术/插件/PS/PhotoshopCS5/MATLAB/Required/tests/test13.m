function [e] = test13(cleanup, level)
%TEST13 Layer tests,

%   Thomas Ruark, 5/10/2006
%   Copyright 2006 Adobe Systems, Inc.


[v1, v2, v3, v4] = psconfig('pixels', 'pixels', 100, 'no');

psnewdoc();

psnewlayer();
psnewlayer('hi');

a = psnumlayers();
b = pslayernames();
if a ~= length(b)
    error('test13:length', 'length of names does not macth count');
end
if ~strcmp(b{1}, 'hi')
    error('test13:name', 'name of the top layer is wrong');
end

pssetactivelayer(b{2});

[w, h] = psdocinfo();

if w < 255 || h < 255
    error('test13:wandh', 'width and/or height are incorrect');
end

cc = psnumchannels();

r = uint8(ones(h, w, cc) * 255);
for ww = 1 : w
    r(1:255, ww, 2) = 1:255;
end
for hh = 1 : h
    r(hh, 1:255, 1) = 1:255;
end

% W#1264493
t = r(:, :, 1);
psnewlayermatrix(r);

psnewlayermatrix(r, t);

% W#1470942, set units to inches and make a doc from a matrix, psdocmatrix
% needs to convert back to pixels, make the doc and then set back to units
% same problem for psnewlayermatrix

psconfig('inches');
psnewdocmatrix(uint8(rand(10,10,3)));
psnewlayermatrix(uint8(rand(10,10,3)));

psconfig(v1, v2, v3, v4);

if exist('cleanup', 'var') && cleanup
    while psnumdocs()
        psclosedoc(1);
    end
end

e = 'PASS';
