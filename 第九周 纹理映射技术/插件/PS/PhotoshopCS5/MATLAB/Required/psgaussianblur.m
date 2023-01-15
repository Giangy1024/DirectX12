function [] = psgaussianblur(r)
%PSGAUSSIANBLUR    Run the Gaussian Blur filter.
%   PSGAUSSIANBLUR() Run the filter with the deafult parameters.
%
%   PSGAUSSIANBLUR(R) R for radius is in pixels in the range of 0.1 to 
%   250.0, default is 5.0
%
%   Example:
%   psgaussianblur
%   psgaussianblur(12.2)
%
%   See also PSADDNOISE, PSAVERAGE, PSBLUR, PSBLURMORE, PSBOXBLUR,
%   PSCUSTOM, PSDUSTANDSCRATCHES, PSHIGHPASS, PSLENSBLUR, PSMAXIMUM,
%   PSMEDIAN, PSMINIMUM, PSMOTIONBLUR, PSOFFSET, PSRADIALBLUR, PSSHAPEBLUR,
%   PSSHARPEN, PSSHARPENEDGES, PSSHARPENMORE, PSSMARTBLUR, PSSURFACEBLUR,
%   PSUNSHARPMASK

%   Thomas Ruark, 2/3/2006
%   Copyright 2006 Adobe Systems Incorporated

% Use the default
if nargin < 1
    r = 5.0;
end

% Build up the JavaScript
pstext = ['var b = "";' ...
    'try { ' ...
    '    app.activeDocument.activeLayer.applyGaussianBlur(' num2str(r) ');' ...
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
