function [] = pscustom(k, s, o)
%PSCUSTOM    Run the Custom filter.
%   PSCUSTOM() Runs the Custom filter with the default values for kernel,
%   scale and offset.
%
%   PSCUSTOM(K) K for kernel is an array of 25 values (-999 -> 999), 
%   default is: (zeros are left out)
%      -1
%   -1  5 -1
%      -1
%
%   PSCUSTOM(K, S) S for scale is the scale factor (1 -> 9999), default is
%   1.
%
%   PSCUSTOM(K, S, O) O for offset for the kernel (-9999 -> 9999), default
%   is 0.
%
%   Example:
%   pscustom
%   pscustom(ones(5))
%   pscustom(ones(5), 25, 0)
%
%   See also PSADDNOISE, PSAVERAGE, PSBLUR, PSBLURMORE, PSBOXBLUR,
%   PSDUSTANDSCRATCHES, PSGAUSSIANBLUR, PSHIGHPASS, PSLENSBLUR, PSMAXIMUM,
%   PSMEDIAN, PSMINIMUM, PSMOTIONBLUR, PSOFFSET, PSRADIALBLUR, PSSHAPEBLUR,
%   PSSHARPEN, PSSHARPENEDGES, PSSHARPENMORE, PSSMARTBLUR, PSSURFACEBLUR,
%   PSUNSHARPMASK

%   Thomas Ruark, 2/3/2006
%   Copyright 2006 Adobe Systems Incorporated

if nargin < 1
    k = [ 0 0 0 0 0; 0 0 -1 0 0; 0 -1 5 -1 0;  0 0 -1 0 0; 0 0 0 0 0];
end
if nargin < 2
    s = 1;
end
if nargin < 3
    o = 0;
end

pskernelstr = mat2str(k);
pskernelstr = strrep(pskernelstr, ';', ',');
pskernelstr = strrep(pskernelstr, ' ', ',');

% Build up the JavaScript
pstext = ['var b = "";' ...
    'try { ' ...
    '    var psscale = ' num2str(s) ';' ...
    '    var psoffset = ' num2str(o) ';' ...
    '    var pskernel = ' pskernelstr ';' ...
    '    app.activeDocument.activeLayer.applyCustomFilter(pskernel, psscale, psoffset);' ...
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
