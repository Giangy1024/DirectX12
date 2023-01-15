function o = psjavascript(txt)
%PSJAVASCRIPT  Execute the given text as JavaScript and return the result.
%   O = PSJAVASCRIPT(I) I is the JavaScript text. O is the result as text.
%
%   This routine uses the standard string interface and will do local code
%   page conversion of your strings. It is recommended that you use the
%   Unicode version PSJAVASCRIPTU interface.
%
%   Example:
%   better_be_4 = psjavascript('2+2')
%
%   See also PSLAUNCH, PSQUIT, PSCONFIG, PSJAVASCRIPTU

%   Thomas Ruark, 06/09/2008
%   Copyright 2006 Adobe Systems Incorporated

% load our worker library
if ~libisloaded('psmatlab')
    if isunix
        libExt = '.dylib';
    else
        libExt = '.dll';
    end
    libPath = strrep(which(['psmatlab' libExt]), ['psmatlab' libExt], '');
    loadlibrary([libPath ['psmatlab' libExt]], [libPath 'psmatlab.h']);
end

try
	o = calllib('psmatlab', 'psjavascript', txt);
catch
    error('Photoshop appears to be unable to take commands.');
end

if strcmp(o, 'MATLABNOTENABLED')
    error('MATLAB is not enabled');
end
