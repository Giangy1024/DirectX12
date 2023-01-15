function [] = psmaximum(r)
%PSMAXIMUM    Run the Maximum filter.
%   PSMAXIMUM Runs the filter with the default parameters.
%
%   PSMAXIMUM(R) R for radius in pixels in the range of 0.1 to 250.0,
%   default is 1.0.
%
%   Example:
%   psmaximum
%   psmaximum(r)
%
%   See also PSADDNOISE, PSAVERAGE, PSBLUR, PSBLURMORE, PSBOXBLUR,
%   PSCUSTOM, PSDUSTANDSCRATCHES, PSGAUSSIANBLUR, PSHIGHPASS, PSLENSBLUR,
%   PSMEDIAN, PSMINIMUM, PSMOTIONBLUR, PSOFFSET, PSRADIALBLUR, PSSHAPEBLUR,
%   PSSHARPEN, PSSHARPENEDGES, PSSHARPENMORE, PSSMARTBLUR, PSSURFACEBLUR,
%   PSUNSHARPMASK

%   Thomas Ruark, 2/3/2006
%   Copyright 2006 Adobe Systems Incorporated

% Use the default
if nargin < 1
    r = 1.0;
end

% Build up the JavaScript
pstext = ['var b = "";' ...
    'try { ' ...
    '    app.activeDocument.activeLayer.applyMaximum(' num2str(r) ');' ...
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
