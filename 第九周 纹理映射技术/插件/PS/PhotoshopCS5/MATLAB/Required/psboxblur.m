function [] = psboxblur(r)
%PSBOXBLUR   Run the Box Blur filter.
%   PSBOXBLUR() Run the Box Blur filter with the default for radius.
%
%   PSBOXBLUR(R) R for radius in pixels ranging from 1 -> 999, default is
%   10.
%
%   Example:
%   psboxblur
%   psboxblur(25)
%
%   See also PSADDNOISE, PSAVERAGE, PSBLUR, PSBLURMORE, PSCUSTOM,
%   PSDUSTANDSCRATCHES, PSGAUSSIANBLUR, PSHIGHPASS, PSLENSBLUR, PSMAXIMUM,
%   PSMEDIAN, PSMINIMUM, PSMOTIONBLUR, PSOFFSET, PSRADIALBLUR, PSSHAPEBLUR,
%   PSSHARPEN, PSSHARPENEDGES, PSSHARPENMORE, PSSMARTBLUR, PSSURFACEBLUR,
%   PSUNSHARPMASK

%   Thomas Ruark, 2/3/2006
%   Copyright 2006 Adobe Systems Incorporated

if nargin < 1
    r = 10;
end

% Build up the JavaScript
pstext = ['var b = "";' ...
    'try { ' ...
    '    var id29 = stringIDToTypeID( "boxblur" );' ...
    '    var desc6 = new ActionDescriptor();' ...
    '    var id30 = charIDToTypeID( "Rds " );' ...
    '    var id31 = charIDToTypeID( "#Pxl" );' ...
    '    desc6.putUnitDouble( id30, id31, ' num2str(r) ');' ...
    '    executeAction( id29, desc6, DialogModes.NO );' ...
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
