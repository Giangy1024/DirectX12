function [] = psmedian(r)
%PSMEDIAN    Run the Median filter.
%   PSMEDIAN runs the filter with the default arguments.
%
%   PSMEDIAN(R) R for radius is in pixels ranging from 1 -> 100, default is
%   1. 
%
%   Example:
%   psmedian
%   psmedian(2)
%
%   See also PSADDNOISE, PSAVERAGE, PSBLUR, PSBLURMORE, PSBOXBLUR,
%   PSCUSTOM, PSDUSTANDSCRATCHES, PSGAUSSIANBLUR, PSHIGHPASS, PSLENSBLUR,
%   PSMAXIMUM, PSMINIMUM, PSMOTIONBLUR, PSOFFSET, PSRADIALBLUR,
%   PSSHAPEBLUR, PSSHARPEN, PSSHARPENEDGES, PSSHARPENMORE, PSSMARTBLUR,
%   PSSURFACEBLUR, PSUNSHARPMASK

%   Thomas Ruark, 2/3/2006
%   Copyright 2006 Adobe Systems Incorporated

if nargin < 1
    r = 1;
end

% Build up the JavaScript
pstext = ['var b = "";' ...
    'try { ' ...
    '    app.activeDocument.activeLayer.applyMedianNoise(' num2str(r) ');' ...
    '    b = "OK";' ...
    '}' ...
    'catch(e) { ' ...
    '    b = e.toString();' ...
    '}' ...
    'b;'];

psresult = psjavascriptu(pstext);

if ~strcmp(psresult, 'OK')
    error(psresult);
end
