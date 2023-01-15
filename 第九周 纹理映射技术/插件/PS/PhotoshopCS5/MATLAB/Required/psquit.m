function [] = psquit()
%PSQUIT    Quit the Photoshop application.
%
%   Example:
%   psquit()
%
%   See also PSLAUNCH, PSJAVASCRIPT, PSCONFIG

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

if isunix
    psjavascript('executeAction( charIDToTypeID( "quit" ), undefined, DialogModes.NO );');
else
	try
		calllib('psmatlab', 'psquit');
    catch
	    error('Photoshop appears to be unable to take commands.');
	end
end

unloadlibrary('psmatlab');

