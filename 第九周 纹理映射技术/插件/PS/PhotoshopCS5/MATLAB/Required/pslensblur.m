function [] = pslensblur(s, f, v, sh, r, c, rot, b, t, a, d, m)
%PSLENSBLUR    Run the Lens Blur filter.
%   PSLENSBLUR runs the filter with the default options.
%
%   PSLENSBLUR(S,F,V,SH,R,C,ROT,B,T,A,D,M) S for source for the depth map,
%   default is 'none'. F for focal distance is the blur focal distance for
%   the depth map, default is 0. V for invert depth map indicates whether
%   the depth map is inverted, default is false. SH for shape geometry of
%   the iris, default is 'hexagon'. R for radius of the iris, default is
%   15. C for blade curvature of the iris, default is 0. ROT for rotation
%   of the iris, default is 0. B for brightness for the specular
%   highlights, default is 0. T for threshold for the specular highlights,
%   default is 0. A for amount of noise, default is 0. D for distribution
%   value for the noise, default is 'uniform'. M for monochromatic
%   indicates whether the noise is monochromatic, default is false.  
%
%   Example:
%   pslensblur
%   pslensblur('none', 0, false, 'hexagon', 15, 0, 0, 0, 0, 0, 'uniform', false);
%
%   See also PSADDNOISE, PSAVERAGE, PSBLUR, PSBLURMORE, PSBOXBLUR,
%   PSCUSTOM, PSDUSTANDSCRATCHES, PSGAUSSIANBLUR, PSHIGHPASS, PSMAXIMUM,
%   PSMEDIAN, PSMINIMUM, PSMOTIONBLUR, PSOFFSET, PSRADIALBLUR, PSSHAPEBLUR,
%   PSSHARPEN, PSSHARPENEDGES, PSSHARPENMORE, PSSMARTBLUR, PSSURFACEBLUR,
%   PSUNSHARPMASK

%   Thomas Ruark, 2/3/2006
%   Copyright 2006 Adobe Systems Incorporated

% Build up the JavaScript
pstext = ['var b = "";' ...
    'try { ' ...
    '    app.activeDocument.activeLayer.applyLensBlur('];

if nargin > 0
    pstext = [pstext 'DepthMapSource.' upper(s) ','];
else
    pstext = [pstext 'undefined,'];
end
if nargin > 1
    pstext = [pstext num2str(f) ','];
else
    pstext = [pstext 'undefined,'];
end
if nargin > 2
    pstext = [pstext mat2str(v) ','];
else
    pstext = [pstext 'undefined,'];
end
if nargin > 3
    pstext = [pstext 'Geometry.' upper(sh) ','];
else
    pstext = [pstext 'undefined,'];
end
if nargin > 4
    pstext = [pstext num2str(r) ','];
else
    pstext = [pstext 'undefined,'];
end
if nargin > 5
    pstext = [pstext num2str(c) ','];
else
    pstext = [pstext 'undefined,'];
end
if nargin > 6
    pstext = [pstext num2str(rot) ','];
else
    pstext = [pstext 'undefined,'];
end
if nargin > 7
    pstext = [pstext num2str(b) ','];
else
    pstext = [pstext 'undefined,'];
end
if nargin > 8
    pstext = [pstext num2str(t) ');'];
else
    pstext = [pstext 'undefined);'];
end




if nargin > 0
    pstext = [pstext num2str(a) ','];
else
    pstext = [pstext 'undefined,'];
end
if nargin > 3
    pstext = [pstext 'NoiseDistribution.' upper(d) ','];
else
    pstext = [pstext 'undefined,'];
end
if nargin > 6
    pstext = [pstext mat2str(m) ','];
else
    pstext = [pstext 'undefined,'];
end

pstext = [pstext '    b = "OK";' ...
    '}' ...
    'catch(e) { ' ...
    '    b = e.toString();' ...
    '}' ...
    'b;'];

psresult = psjavascriptu(pstext);

if ~strcmp(psresult, 'OK')
    error(psresult);
end
