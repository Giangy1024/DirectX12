function [] = psdustandscratches(a, t)
%PSDUSTANDSCRATCHES    Run the Dust and Scratches filter.
%   PSDUSTANDSCRATCHES() Runs the filter with the default parameters.
%
%   PSDUSTANDSCRATCHES(A) A for amount is in pixels ranging from 1 -> 100,
%   default is 1.
%
%   PSDUSTANDSCRATCHES(A,T) T for threshold is levels ranging from 0 ->
%   255, default is 0.
%
%   Example:
%   psdustandscratches
%   psdustandscratches(10)
%   psdustandscratches(10, 2)
%
%   See also PSADDNOISE, PSAVERAGE, PSBLUR, PSBLURMORE, PSBOXBLUR,
%   PSCUSTOM, PSGAUSSIANBLUR, PSHIGHPASS, PSLENSBLUR, PSMAXIMUM, PSMEDIAN,
%   PSMINIMUM, PSMOTIONBLUR, PSOFFSET, PSRADIALBLUR, PSSHAPEBLUR,
%   PSSHARPEN, PSSHARPENEDGES, PSSHARPENMORE, PSSMARTBLUR, PSSURFACEBLUR,
%   PSUNSHARPMASK

%   Thomas Ruark, 2/3/2006
%   Copyright 2006 Adobe Systems Incorporated

if nargin < 1
    a = 1;
end
if nargin < 2
    t = 0;
end

% Build up the JavaScript
pstext = ['var b = "";' ...
    'try { ' ...
    '    app.activeDocument.activeLayer.applyDustAndScratches(' num2str(a) ',' num2str(t) ');' ...
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
