function [] = psminimum(r)
%PSMINIMUM    Run the Minimum filter.
%   PSMINIMUM runs the filter with the default arguments.
%
%   PSMINIMUM(R) R for radius in pixels with a range of 0.1 to 250.0,
%   default is 1.0.
%
%   Example:
%   psminimum
%   psminimum(r)
%
%   See also PSADDNOISE, PSAVERAGE, PSBLUR, PSBLURMORE, PSBOXBLUR,
%   PSCUSTOM, PSDUSTANDSCRATCHES, PSGAUSSIANBLUR, PSHIGHPASS, PSLENSBLUR,
%   PSMAXIMUM, PSMEDIAN, PSMOTIONBLUR, PSOFFSET, PSRADIALBLUR, PSSHAPEBLUR,
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
    '    app.activeDocument.activeLayer.applyMinimum(' num2str(r) ');' ...
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
