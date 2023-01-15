function o = pscolorsettings(txt)
%PSCOLORSETTINGS    Get or set the color settings.
%   The color settings can be set using a saved set only.
%
%   Example:
%   pscolorsettings
%   pscolorsettings('North America General Purpose 2')
%
%   See also PSCONFIG, PSDOCINFO, PSCOLORPROFILE, PSCONVERTPROFILE

%   Thomas Ruark, 2/3/2006
%   Copyright 2006 Adobe Systems Incorporated

% Build up the JavaScript
pstext = ['try { '...
    'var result = "";' ...
    'var errorDetails = "";' ...
    'var a = app.colorSettings;'];
    
if nargin == 1
    pstext = [pstext 'app.colorSettings = "' txt '";'];
end

pstext = [pstext '} catch(e) {' ...
    '    errorDetails = e.toString();' ...
    '    result = "8F6AFB7E-EC1F-4b6f-AD15-C1AF34221EED";' ...
    '}'];

pstext = [pstext 'if ( result != "8F6AFB7E-EC1F-4b6f-AD15-C1AF34221EED" ) {'...
    '    result = a;' ...
    '} else {' ...
    '    result = [result, errorDetails];' ...
    '}' ...
    'result;'];

psresult = psjavascriptu(pstext);

if isempty(findstr(psresult, '8F6AFB7E-EC1F-4b6f-AD15-C1AF34221EED'))
    o = psresult;
else
    error(strrep(psresult, '8F6AFB7E-EC1F-4b6f-AD15-C1AF34221EED', ''));
end
