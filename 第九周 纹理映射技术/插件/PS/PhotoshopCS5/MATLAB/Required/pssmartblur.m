function [] = pssmartblur(r, t, q, m)
%PSSMARTBLUR    Run the Smart Blur filter.
%   PSSMARTBLUR runs the Smart Blur filter with the default parameters.
%
%   PSSMARTBLUR(R,T,Q,M) R for radius in pixels from 0.1 -> 100.0, default
%   is 3. T for threshold from 0.1 -> 100.0, default is 25. Q for quality
%   is 'high', 'low', 'medium', default is 'low'. M for mode is 'edge',
%   'normal', or 'overlay', default is 'normal'. 
%
%   Example:
%   pssmartblur
%   pssmartblur(5, 30, 'low', 'overlay')
%
%   See also PSADDNOISE, PSAVERAGE, PSBLUR, PSBLURMORE, PSBOXBLUR,
%   PSCUSTOM, PSDUSTANDSCRATCHES, PSGAUSSIANBLUR, PSHIGHPASS, PSLENSBLUR,
%   PSMAXIMUM, PSMEDIAN, PSMINIMUM, PSMOTIONBLUR, PSOFFSET, PSRADIALBLUR,
%   PSSHAPEBLUR, PSSHARPEN, PSSHARPENEDGES, PSSHARPENMORE, PSSURFACEBLUR,
%   PSUNSHARPMASK

%   Thomas Ruark, 2/3/2006
%   Copyright 2006 Adobe Systems Incorporated

if nargin < 1
    r = 3;
end
if nargin < 2
    t = 25;
end
if nargin < 3
    q = 'LOW';
else
    if strcmp(q, 'high')
        q = 'HIGH';
    elseif strcmp(q, 'medium')
        q = 'MEDIUM';
    else
        q = 'LOW';
    end
end
if nargin < 4
    m = 'NORMAL';
else
    if strcmp(m, 'edge')
        m = 'EDGEONLY';
    elseif strcmp(m, 'overlay')
        m = 'OVERLAYEDGE';
    else
        m = 'NORMAL';
    end
end

% Build up the JavaScript
pstext = ['var b = "";' ...
    'try { ' ...
    '    app.activeDocument.activeLayer.applySmartBlur(' num2str(r) ',' num2str(t) ',SmartBlurQuality.' q ',SmartBlurMode.' m ');' ...
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
