function [] = psaddnoise(a, d, m)
%PSADDNOISE    Run the Add Noise filter.
%   PSADDNOISE() Run the Add Noise filter using the defaults for amount,
%   distribution and monochromatic.
%
%   PSADDNOISE(A) A for amount is in percent in the range of 0.1 -> 400,
%   default is 12.5.
%
%   PSADDNOISE(A,D) D for distribution is a string of either 'uniform' or 
%   'gaussian', default is 'uniform'.
%
%   PSADDNOISE(A,D,M) M for monochromatic is either true or false, default 
%   is false.
%
%   Example:
%   psaddnoise()
%   psaddnoise(15)
%   psaddnoise(15, 'gaussian')
%   psaddnoise(15,'gaussian', true)
%
%   See also PSAVERAGE, PSBLUR, PSBLURMORE, PSBOXBLUR, PSCUSTOM,
%   PSDUSTANDSCRATCHES, PSGAUSSIANBLUR, PSHIGHPASS, PSLENSBLUR, PSMAXIMUM,
%   PSMEDIAN, PSMINIMUM, PSMOTIONBLUR, PSOFFSET, PSRADIALBLUR, PSSHAPEBLUR,
%   PSSHARPEN, PSSHARPENEDGES, PSSHARPENMORE, PSSMARTBLUR, PSSURFACEBLUR,
%   PSUNSHARPMASK

%   Thomas Ruark, 2/3/2006
%   Copyright 2006 Adobe Systems Incorporated

if nargin < 1
    a = 12.5;
end
if nargin < 2
    d = 'UNIFORM';
else
    if strcmp(d, 'gaussian')
        d = 'GAUSSIAN';
    else
        d = 'UNIFORM';
    end
end
if nargin < 3
    m = 'false';
else
    if m
        m = 'true';
    else
        m = 'false';
    end
end

% Build up the JavaScript
pstext = ['var b = "";' ...
    'try { ' ...
    '    app.activeDocument.activeLayer.applyAddNoise(' num2str(a) ',NoiseDistribution.' d ',' m ');' ...
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
