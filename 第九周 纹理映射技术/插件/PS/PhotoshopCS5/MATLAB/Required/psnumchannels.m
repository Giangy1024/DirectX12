function n = psnumchannels(a)
%PSNUMCHANNELS    Return the number of channels in the current document.
%   N = PSNUMCHANNELS returns the number of active channels.
%   N = PSNUMCHANNELS(0) is the same as above.
%
%   N = PSNUMCHANNELS(1) is the count of all the channels in the document.
%
%   Example:
%   n = psnumchannels
%   n = psnumchannels(1)
%
%   See also PSGETPIXELS, PSSETPIXELS, PSCONFIG, PSCHANNELNAMES,
%   PSSETACTIVECHANNELS

%   Thomas Ruark, 2/14/2006
%   Copyright 2006 Adobe Systems Incorporated

if exist('a', 'var')
    if a
        channelstr = 'channels';
    else
        channelstr = 'activeChannels';
    end
else
    channelstr = 'activeChannels';
end

n = psjavascriptu(['if (app.documents.length) app.activeDocument.' channelstr '.length; else "0";']);

n = str2double(n);
