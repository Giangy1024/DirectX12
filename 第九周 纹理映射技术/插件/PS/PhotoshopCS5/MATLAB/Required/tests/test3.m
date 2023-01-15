function [e] = test3(cleanup, level)
%TEST3 Document and color profile tests.

%   Thomas Ruark, 2/21/2007
%   Copyright 2007 Adobe Systems, Inc.


[v1,v2,v3,v4]=psconfig('pixels', 'pixels', 5, 'no');
doccount = psnumdocs();
psnewdoc(100,100,72,'hi');
if ( doccount + 1 ) ~= psnumdocs()
    error('test3:numdocstest', 'number of docs did not increase');
end
psnewdoc(300,300,72,'bye');
if ( doccount + 2 ) ~= psnumdocs()
    error('test3:numdocstest2', 'number of docs did not increase');
end
a = pssetactivedoc('hi');
if ~strcmp(a, 'bye')
    error('test3:oldactivedoc', 'last document name was not bye');
end
a = pssetactivedoc('bye');
if ~strcmp(a, 'hi')
    error('test3:oldactivedoc2', 'last document name was not hi');
end
doccount = psnumdocs();
docnames = psdocnames();
if length(docnames) ~= doccount
    error('test3:numdocstest3', 'length of the names does not match number of documents');
end
b = 0;
for a = 1 : length(docnames)
    if strcmp(docnames{a}, 'hi')
        b = b + 1;
    end
    if strcmp(docnames{a}, 'bye')
        b = b + 1;
    end
end
if 2 ~= b
    error('test3:numdocstest4', 'could not find the two documents I created in the names');
end
c = pscolorsettings;
pscolorsettings('Monitor Color');
d = pscolorsettings;
if ~strcmp(d, 'Monitor Color')
    error('test3:pscolorsettings', 'could not change color settings');
end
pscolorsettings('North America General Purpose 2');
d = pscolorsettings;
if ~strcmp(d, 'North America General Purpose 2')
    error('test3:pscolorsettings2', 'could not change color settings');
end
if ~strcmp(c, 'Custom')
    pscolorsettings(c);
end
e = pscolorprofile;
pscolorprofile('Adobe RGB (1998)');
f = pscolorprofile;
if ~strcmp(f, 'Adobe RGB (1998)')
    error('test3:pscolorprofile', 'could not change color profile');
end
pscolorprofile('Apple RGB');
f = pscolorprofile;
if ~strcmp(f, 'Apple RGB')
    error('test3:pscolorprofile2', 'could not change color profile');
end
pscolorprofile(e);
psconvertprofile('Adobe RGB (1998)');
f = pscolorprofile;
if ~strcmp(f, 'Adobe RGB (1998)')
    error('test3:pscolorprofile3', 'could not change color profile');
end
psconvertprofile('Apple RGB');
f = pscolorprofile;
if ~strcmp(f, 'Apple RGB')
    error('test3:pscolorprofile4', 'could not change color profile');
end
psnewdoc(100, 50, 72, 'test8', 'rgb', 'white', 1.0, 8, 'Adobe RGB (1998)');
[w,h,r,n,m,b] = psdocinfo;
if b ~= 8
    error('test3:psdocinfo', ' depth is not 8');
end
p = pscolorprofile;
if ~strcmp(p, 'Adobe RGB (1998)')
    error('test3:pscolorprofile5', 'color profile is not Adobe RGB');
end
psnewdoc(100, 50, 72, 'test16', 'rgb', 'white', 1.0, 16, 'Adobe RGB (1998)');
[w,h,r,n,m,b] = psdocinfo;
if b ~= 16
    error('test3:psdocinfo2', ' depth is not 16');
end
p = pscolorprofile;
if ~strcmp(p, 'Adobe RGB (1998)')
    error('test3:pscolorprofile6', 'color profile is not Adobe RGB');
end
psnewdoc(100, 50, 72, 'test32', 'rgb', 'white', 1.0, 32, 'Adobe RGB (1998)');
[w,h,r,n,m,b] = psdocinfo;
if b ~= 32
    error('test3:psdocinfo3', ' depth is not 32');
end
p = pscolorprofile;
ploc = psjavascriptu('localize("$$$/ProfileName/LinearRGBProfile=Linear RGB Profile");');
ploc = ['Adobe RGB (1998) (' ploc ')'];
if ~strcmp(p, ploc)
    error('test3:pscolorprofile7', [p ' is not ' ploc ]);
end

% negative tests
try
    pscolorprofile('xxx');
    error('test3:pscolorprofile8', 'above line should fail setting profile to xxx');
catch
    ; % failure is good in this negative test
end

psconfig(v1, v2, v3, v4);
if exist('cleanup', 'var') && cleanup
    while psnumdocs()
        psclosedoc(1);
    end
end

e = 'PASS';
