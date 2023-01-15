function [] = pslaunch()
%PSLAUNCH    Launch Photoshop or attach to an already running Photoshop.
%   If Photoshop is already running, it will attach, otherwise it will 
%   launch Photoshop. This routine does not need to be called, as the 
%   library will do the above logic when you use any of the other Photoshop
%   routines.
%
%   Example:
%   pslaunch()
%
%   See also PSQUIT, PSJAVASCRIPT, PSCONFIG

%   Thomas Ruark, 06/09/2008
%   Copyright 2005 Adobe Systems Incorporated

% load our worker library
if libisloaded('psmatlab')
    unloadlibrary('psmatlab')
end
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
	calllib('psmatlab', 'pslaunch');
catch
    error('Photoshop appears to be unable to take commands.');
end


