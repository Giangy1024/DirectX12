function [e, f, a] = test1(cleanup, level)
%TEST1   Check installation and report any missing or extra files that are
%installed. If you edit the .m files in MATLAB then you may get extra .asv
%temporary files.
%
% extra values returned here
% f is the extra files
% a is the missing files

%   Thomas Ruark, 03/09/2010
%   Copyright 2007 Adobe Systems, Inc.

a = { 'pschannelnames.m' 'psclosedoc.m' 'psconfig.m' 'psdocinfo.m' 'psdocnames.m' };
a = [a {'psgaussianblur.m' 'psgetpixels.m' 'pshistogram.m' 'psjavascript.m'}];
a = [a {'pslaunch.m' 'pslayernames.m' 'psproto.m' 'psnewdoc.m' 'psnumchannels.m'}];
a = [a {'psnumdocs.m' 'psnumlayers.m' 'psopendoc.m' 'psquit.m' 'pssetactivechannels.m'}];
a = [a {'pssetactivedoc.m' 'pssetactivelayer.m' 'pssetpixels.m' 'pscustom.m'}];
a = [a {'pshighpass.m' 'psmaximum.m' 'psminimum.m' 'psoffset.m' 'pssharpen.m'}];
a = [a {'pssharpenedges.m' 'pssharpenmore.m' 'psunsharpmask.m' 'psaddnoise.m'}];
a = [a {'psdustandscratches.m' 'psmedian.m' 'psblur.m' 'psblurmore.m' 'psaverage.m'}];
a = [a {'psboxblur.m' 'pslensblur.m' 'psmotionblur.m' 'pscolorprofile.m' 'psconvertprofile.m'}];
a = [a {'psradialblur.m' 'psshapeblur.m' 'pssmartblur.m' 'pssurfaceblur.m'}];
a = [a {'psgetpath.m' 'psnewpath.m' 'psnumpaths.m' 'pspathnames.m' 'psnewdocmatrix.m'}];
a = [a {'psnewlayermatrix.m' 'psnewlayer.m' 'psimread.m' 'pscolorsettings.m' 'psjavascriptu.m'}];
a = [a {'Contents.m', 'psmatlab.h'}];

if strcmp(computer, 'MAC') || strcmp(computer, 'MACI') || strcmp(computer, 'MAC64') || strcmp(computer, 'MACI64')
    a = [a {'psmatlab.dylib'}];
else
    a = [a {'psmatlab.dll'}];
end

% this sees if they are known by MATLAB
for b = 1 : length(a)
    if exist(a{b}, 'file') == 0
        error( 'test1:filecheck', ['File does not exist ' a{b}]); 
    end
end

% this checks the actual location on disk
c = which(a{1});
d = strrep(c, a{1}, '');
e = dir(d);
f = {};
for g = 1 : length(e)
    if ~e(g).isdir && ~strcmp(e(g).name, '.DS_Store')
        f = [f {e(g).name}];
    end
end

f = sort(f);
a = sort(a);

foundMatch = true;

while foundMatch && length(f) && length(a)
    foundMatch = false;
    y = 1;
    while y <= length(f)
        z = 1;
        while z <= length(a)
            if strcmp(f{y}, a{z})
                f(y) = [];
                a(z) = [];
                foundMatch = true;
                z = length(a);
                y = length(f);
            end
            z = z + 1;
        end
        y = y + 1;
    end
end
if length(f)
    pslogit('Extra files: ', true, true, [strrep(which('testall'), 'testall.m', '') 'pstestlog.log']);
    pslogit(f, true, true, [strrep(which('testall'), 'testall.m', '') 'pstestlog.log']);
end
if length(a)
    pslogit('Missing files: ', true, true, [strrep(which('testall'), 'testall.m', '') 'pstestlog.log']);
    pslogit(a, true, true, [strrep(which('testall'), 'testall.m', '') 'pstestlog.log']);
end

e = 'PASS';
