function [e] = test12(cleanup, level)
%TEST12 Path tests

%   Thomas Ruark, 5/10/2006
%   Copyright 2006 Adobe Systems, Inc.


[a,b,c,d] = psconfig('pixels', 'pixels', 100, 'no');

psnewdoc;

e = struct;
e(1).closed = 1;
e(1).operation = 'xor';

f = struct;
f(1).kind = 'corner';
f(1).points = [90 177 90 177 90 177];

f(2).kind = 'corner';
f(2).points = [130 267 130 267 130 267];

f(3).kind = 'corner';
f(3).points = [216 212 216 212 216 212];

e(1).pathpoints = f;

psnewpath('Test 1', e);

g = psgetpath('Test 1');

% not exactly the same
if ~strcmp(g.kind, 'normal')
    error('test12:pathkind', 'path kind is not normal');
end

if length(g.subpathitems) ~= 1
    error('test12:subpathitems', 'wrong count for sub path items');
end

if g.subpathitems(1).closed ~= e(1).closed
    error('test12:closed', 'wrong closed for sub path items');
end

if ~strcmp(g.subpathitems(1).operation, e(1).operation)
    error('test12:operation', 'wrong operation for sub path items');
end

if length(g.subpathitems(1).pathpoints) ~= length(f)
    error('test12:pathpoints', 'wrong pathpoints for sub path items');
end

for h=1:length(f)
    k = g.subpathitems(1).pathpoints(h);

    if ~strcmp(k.kind, f(h).kind)
        error('test12:kind', 'wrong kind for sub path items');
    end

    for l=1:length(k.points)
        if k.points(l) ~= f(h).points(l)
            error('test12:points', 'wrong points');
        end
    end
end

psnewpath('Test 2', e);

x = psnumpaths();
y = pspathnames();
if x ~= length(y)
    error('test12:names1', 'wrong lnegth of names for number');
end

if x ~= 2
    error('test12:names2', 'wrong lnegth of names for number');
end

if ~strcmp(y{1}, 'Test 1')
    error('test12:names3', 'wrong names for paths');
end
if ~strcmp(y{2}, 'Test 2')
    error('test12:names4', 'wrong names for paths');
end


psconfig(a, b, c, d);

if exist('cleanup', 'var') && cleanup
    while psnumdocs()
        psclosedoc(1);
    end
end


e = 'PASS';
