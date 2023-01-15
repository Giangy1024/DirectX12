function [] = psoffset(h, v, o)
%PSOFFSET    Run the Offset filter.
%   PSOFFSET run the filter with the default parameters.
%
%   PSOFFSET(H,V,O) H and V can be two times the width and height of the
%   document. Default is 0 for each. O for how to replicate undefined areas
%   either 'repeat', 'background', or 'wrap', default is 'repeat'.
%
%   Example:
%   psoffset
%   psoffset(25, 25, 'repeat')
%
%   See also PSADDNOISE, PSAVERAGE, PSBLUR, PSBLURMORE, PSBOXBLUR,
%   PSCUSTOM, PSDUSTANDSCRATCHES, PSGAUSSIANBLUR, PSHIGHPASS, PSLENSBLUR,
%   PSMAXIMUM, PSMEDIAN, PSMINIMUM, PSMOTIONBLUR, PSRADIALBLUR,
%   PSSHAPEBLUR, PSSHARPEN, PSSHARPENEDGES, PSSHARPENMORE, PSSMARTBLUR,
%   PSSURFACEBLUR, PSUNSHARPMASK

%   Thomas Ruark, 2/3/2006
%   Copyright 2006 Adobe Systems Incorporated

if nargin < 1
    h = 0;
end
if nargin < 2
    v = 0;
end
if nargin < 3
    o = 'REPEATEDGEPIXELS';
else
    if strcmp(o, 'repeat')
        o = 'REPEATEDGEPIXELS';
    elseif strcmp(o, 'background')
        o = 'SETTOBACKGROUND';
    elseif strcmp(o, 'wrap')
        o = 'WRAPAROUND';
    else
        o = 'REPEATEDGEPIXELS';
    end
end

% Build up the JavaScript
pstext = ['var b = "";' ...
    'try { ' ...
    '    app.activeDocument.activeLayer.applyOffset(' num2str(h) ',' num2str(v) ', OffsetUndefinedAreas.' o ');' ...
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
