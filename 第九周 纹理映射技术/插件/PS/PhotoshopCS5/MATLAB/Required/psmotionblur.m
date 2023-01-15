function [] = psmotionblur(a, r)
%PSMOTIONBLUR    Run the Motion Blur filter.
%   PSMOTIONBLUR runs the filter with the default arguments.
%
%   PSMOTIONBLUR(A) A for angle is in degrees from -260 -> 360, default is
%   0. 
%
%   PSMOTIONBLUR(A,R) R for radius is in pixels from 1 -> 999, default is
%   10. 
%
%   Example:
%   psmotionblur
%   psmotionblur(2)
%   psmotionblur(2, 12)
%
%   See also PSADDNOISE, PSAVERAGE, PSBLUR, PSBLURMORE, PSBOXBLUR,
%   PSCUSTOM, PSDUSTANDSCRATCHES, PSGAUSSIANBLUR, PSHIGHPASS, PSLENSBLUR,
%   PSMAXIMUM, PSMEDIAN, PSMINIMUM, PSOFFSET, PSRADIALBLUR, PSSHAPEBLUR,
%   PSSHARPEN, PSSHARPENEDGES, PSSHARPENMORE, PSSMARTBLUR, PSSURFACEBLUR,
%   PSUNSHARPMASK

%   Thomas Ruark, 2/3/2006
%   Copyright 2006 Adobe Systems Incorporated

if nargin < 1
    a = 0;
end
if nargin < 2
    r = 10;
end

% Build up the JavaScript
pstext = ['var b = "";' ...
    'try { ' ...
    '    app.activeDocument.activeLayer.applyMotionBlur(' num2str(a) ',' num2str(r) ');' ...
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
