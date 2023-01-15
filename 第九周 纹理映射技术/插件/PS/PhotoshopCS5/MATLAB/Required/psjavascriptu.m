function ou = psjavascriptu(txt)
%PSJAVASCRIPTU  Convert the text to Unicode and process returning the value
%  in Unicode. The class will still be of type 'char'.
%   O = PSJAVASCRIPTU(I) I is the JavaScript text. O is the result as text.
%
%   Example:
%   better_be_4 = psjavascriptu('2+2')
%
%   See also PSLAUNCH, PSQUIT, PSCONFIG, PSJAVASCRIPT

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

% Convert the MATLAB char to uint16 pass it in and convert it back
utxt16 = uint16(txt);
utxt16 = [utxt16 0]; % null terminate
putxt16 = libpointer('uint16Ptr', utxt16);

% this returns the size of the resulting string
try
    s = calllib('psmatlab', 'psjavascriptu', putxt16);
catch
    error('Photoshop appears to be unable to take commands.');
    s = 0;
end

if s == 4294967295
    error('MATLAB is not enabled');
end

if s > 0
    % make a buffer to hold
    uret16 = uint16(zeros(1,s));
    pret16 = libpointer('uint16Ptr', uret16);

    % retrieve the result
    try
        calllib('psmatlab', 'psjavascriptgetresult', pret16);
    catch
        error('Photoshop appears to be unable to take commands.');
    end

    % convert to MATLAB char
    ou = char(pret16.Value);
else
    ou = ''; % not sure what to return here
end
