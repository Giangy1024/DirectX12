function [e] = test9(cleanup, level)
%TEST9 psdocinfo, pssetpixels, psgetpixels

%   Thomas Ruark, 5/10/2006
%   Copyright 2006 Adobe Systems, Inc.


[oru, otu, oh, odd] = psconfig('pixels', 'pixels', 5, 'no');
psnewdoc(255,255,72,'hello down');
[w,h,r,n,m,b,a]=psdocinfo();
if ~isa(w, 'double')
    error('test9:type1', 'wrong type for width');
end
if w ~= 255
    error('test9:value1', 'wrong value for width');
end
if ~isa(h, 'double')
    error('test9:type2', 'wrong type for height');
end
if h ~= 255
    error('test9:value2', 'wrong value for height');
end
if ~isa(r, 'double')
    error('test9:type3', 'wrong type for resolution');
end
if r ~= 72
    error('test9:value3', 'wrong value for resolution');
end
if ~isa(n, 'char')
    error('test9:type4', 'wrong type for name');
end
if ~strcmp(n, 'hello down')
    error('test9:value4', 'wrong value for name');
end
if ~isa(m, 'char')
    error('test9:type5', 'wrong type for mode');
end
if ~strcmp(m, 'rgb')
    error('test9:value5', 'wrong value for mode');
end
if ~isa(b, 'double')
    error('test9:type6', 'wrong type for depth');
end
if b ~= 8
    error('test9:value6', 'wrong value for depth');
end
if ~isa(a, 'double')
    error('test9:type7', 'wrong type for aspect ratio');
end
if a ~= 1
    error('test9:value7', 'wrong value for aspect ratio');
end
r=psgetpixels();
nc=psnumchannels();
if ~isa(nc,'double')
    error('test9:type8', 'wrong type for number of channels');
end
for a = 1 : w
    for b = 1 : nc
        r(:,a,b)=1:255;
    end
end
pssetpixels(r);

psnewdoc(255,255,72,'hello across');
[w,h,r,n]=psdocinfo();
if w ~= 255
    error('test9:value9', 'wrong value for width');
end
if h ~= 255
    error('test9:value10', 'wrong value for height');
end
if r ~= 72
    error('test9:value11', 'wrong value for resolution');
end
if ~strcmp(n, 'hello across')
    error('test9:value12', 'wrong value for name');
end
if ~isa(w, 'double')
    error('test9:type12', 'wrong type for width');
end
if ~isa(h, 'double')
    error('test9:type13', 'wrong type for height');
end
if ~isa(r, 'double')
    error('test9:type14', 'wrong type for resolution');
end
if ~isa(n, 'char')
    error('test9:type15', 'wrong type for name');
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
    error('test9:value16', 'wrong value for width');
end
if h ~= 255
    error('test9:value17', 'wrong value for height');
end
if r ~= 72
    error('test9:value18', 'wrong value for resolution');
end
if ~strcmp(n, 'hello wowsy')
    error('test9:value19', 'wrong value for name');
end
r=psgetpixels();
for a = 1 : w
    r(a,:,1)=1:255;
    r(:,a,2)=1:255;
end
r(:,:,3)=uint8(zeros(255,255));
pssetpixels(r);

psconfig(oru, otu, oh, odd);

if exist('cleanup', 'var') && cleanup
    while psnumdocs()
        psclosedoc(1);
    end
end

e = 'PASS';
