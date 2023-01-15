function [] = psunsharpmask(a, r, t)
%PSUNSHARPMASK    Run the Unsharp Mask filter.
%   PSUNSHARPMASK() runs the Unsharp Mask filter with the default
%   parameters.
%
%   PSUNSHARPMASK(A) A for amount is a percent in the range of 1 -> 500,
%   default is 50.
%
%   PSUNSHARPMASK(A,R) R for radius is in pixels in the range 0.1 -> 250.0,
%   default is 1.0
%
%   PSUNSHARPMASK(A,R,T) T for threshold is the levels in the range of 0 ->
%   255, default is 0.
%
%   Example:
%   psunsharpmask()
%   psunsharpmask(65)
%   psunsharpmask(65, 2.2)
%   psunsharpmask(65, 2.2, 34)
%
%   See also PSADDNOISE, PSAVERAGE, PSBLUR, PSBLURMORE, PSBOXBLUR,
%   PSCUSTOM, PSDUSTANDSCRATCHES, PSGAUSSIANBLUR, PSHIGHPASS, PSLENSBLUR,
%   PSMAXIMUM, PSMEDIAN, PSMINIMUM, PSMOTIONBLUR, PSOFFSET, PSRADIALBLUR,
%   PSSHAPEBLUR, PSSHARPEN, PSSHARPENEDGES, PSSHARPENMORE, PSSMARTBLUR,
%   PSSURFACEBLUR

%   Thomas Ruark, 2/3/2006
%   Copyright 2006 Adobe Systems Incorporated

if nargin < 1
    a = 50;
end
if nargin < 2
    r = 1.0;
end
if nargin < 3
    t = 0;
end

% Build up the JavaScript
pstext = ['var b = "";' ...
    'try { ' ...
    '    app.activeDocument.activeLayer.applyUnSharpMask(' num2str(a) ',' num2str(r) ',' num2str(t) ');' ...
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
