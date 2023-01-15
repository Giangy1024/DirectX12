function [] = psradialblur(a, m, q)
%PSRADIALBLUR    Run the Radial Blur filter.
%   PSRADIALBLUR runs the filter with the default parameters.
%
%   PSRADIALBLUR(A,M,Q) A for amount in the range of 1 -> 100, default is
%   10. M for method of bluring either 'spin' or 'zoom', default is 'spin'.
%   Q for quality of blurring either 'best', 'draft', or 'good', default is
%   'draft'.
%
%   Example:
%   psradialblur
%   psradialblur(12, 'zoom', 'good')
%
%   See also PSADDNOISE, PSAVERAGE, PSBLUR, PSBLURMORE, PSBOXBLUR,
%   PSCUSTOM, PSDUSTANDSCRATCHES, PSGAUSSIANBLUR, PSHIGHPASS, PSLENSBLUR,
%   PSMAXIMUM, PSMEDIAN, PSMINIMUM, PSMOTIONBLUR, PSOFFSET, PSSHAPEBLUR,
%   PSSHARPEN, PSSHARPENEDGES, PSSHARPENMORE, PSSMARTBLUR, PSSURFACEBLUR,
%   PSUNSHARPMASK

%   Thomas Ruark, 2/3/2006
%   Copyright 2006 Adobe Systems Incorporated

if nargin < 1
    a = 10;
end
if nargin < 2
    m = 'SPIN';
else
    if strcmp(m, 'zoom')
        m = 'ZOOM';
    else
        m = 'SPIN';
    end
end
if nargin < 3
    q = 'DRAFT';
else
    if strcmp(q, 'good')
        q = 'GOOD';
    elseif strcmp(q, 'best')
        q = 'BEST';
    else
        q = 'DRAFT';
    end
end

% Build up the JavaScript
pstext = ['var b = "";' ...
    'try { ' ...
    '    app.activeDocument.activeLayer.applyRadialBlur(' num2str(a) ',RadialBlurMethod.' m ',RadialBlurQuality.' q ');' ...
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
