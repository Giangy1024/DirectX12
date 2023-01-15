function [] = psconvertprofile(txt, intent, b, d)
%PSCONVERTPROFILE    Convert the active document to the new profile.
%   PSCONVERTPROFILE('Adobe RGB (1998)', 'perceptual') converts the active
%   document to the 'Adobe RGB (1998)' profile and uses the 'perceptual'
%   rendering intent. The INTENT values can be 'absolutecolorimetric',
%   'perceptual', 'relativecolorimetric', or 'saturation'
%
%   PSCONVERTPROFILE('Adobe RGB (1998)', 'perceptual', false) sets the black
%   point compensation to false, default is true. 
%
%   PSCONVERTPROFILE('Adobe RGB (1998)', 'perceptual', false, false) sets
%   the dither value to false, default is true. 
%
%   Example:
%   psconvertprofile('Adobe RGB (1998)', 'perceptual')
%   psconvertprofile('Adobe RGB (1998)', 'perceptual', false)
%   psconvertprofile('Adobe RGB (1998)', 'perceptual', false, false)
%
%   See also PSCONFIG, PSDOCINFO, PSCOLORSETTINGS, PSCOLORPROFILE

%   Thomas Ruark, 5/9/2006
%   Copyright 2006 Adobe Systems Incorporated

% Build up the JavaScript
if nargin < 2
    intent = 'RELATIVECOLORIMETRIC';
else
    if strcmp(intent, 'absolutecolorimetric')
        intent = 'ABSOLUTECOLORIMETRIC';
    elseif strcmp(intent, 'perceptual')
        intent = 'PERCEPTUAL';
    elseif strcmp(intent, 'saturation')
        intent = 'SATURATION';
    else
        intent = 'RELATIVECOLORIMETRIC';
    end
end

if nargin < 3
    b = 'true';
else
	if b
		b = 'true';
	else
		b = 'false';
	end
end

if nargin < 4
    d = 'true';
else
	if d
		d = 'true';
	else
		d = 'false';
	end
end

% Build up the JavaScript
pstext = ['var b = "";' ...
    'try { ' ...
    '    app.activeDocument.convertProfile("' txt '", Intent.' intent ', ' b ', ' d ');' ...
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