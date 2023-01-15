function [] = pssurfaceblur(r, t)
%PSSURFACEBLUR    Run the Surface Blur filter.
%   PSSURFACEBLUR() runs the Surface Blur filter with the default
%   parameters.
%
%   PSSURFACEBLUR(R) R for radius in pixels ranging from 1 -> 100, default
%   is 5.
%
%   PSSURFACEBLUR(R,T) T for threshold levels ranging from 2 -> 255,
%   default is 15.
%
%   Example:
%   pssurfaceblur()
%   pssurfaceblur(7)
%   pssurfaceblur(7, 20)
%
%   See also PSADDNOISE, PSAVERAGE, PSBLUR, PSBLURMORE, PSBOXBLUR,
%   PSCUSTOM, PSDUSTANDSCRATCHES, PSGAUSSIANBLUR, PSHIGHPASS, PSLENSBLUR,
%   PSMAXIMUM, PSMEDIAN, PSMINIMUM, PSMOTIONBLUR, PSOFFSET, PSRADIALBLUR,
%   PSSHAPEBLUR, PSSHARPEN, PSSHARPENEDGES, PSSHARPENMORE, PSSMARTBLUR,
%   PSUNSHARPMASK

%   Thomas Ruark, 2/3/2006
%   Copyright 2006 Adobe Systems Incorporated

if nargin < 1
    r = 5;
end
if nargin < 2
    t = 15;
end

% Build up the JavaScript
pstext = ['var b = "";' ...
    'try { ' ...
    '    var id18 = stringIDToTypeID( "surfaceBlur" );' ...
    '    var desc3 = new ActionDescriptor();' ...
    '    var id19 = charIDToTypeID( "Rds " );' ...
    '    var id20 = charIDToTypeID( "#Pxl" );' ...
    '    desc3.putUnitDouble( id19, id20, ' num2str(r) ');' ...
    '    var id21 = charIDToTypeID( "Thsh" );' ...
    '    desc3.putInteger( id21, ' num2str(t) ');' ...
    '    executeAction( id18, desc3, DialogModes.NO );' ...
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
