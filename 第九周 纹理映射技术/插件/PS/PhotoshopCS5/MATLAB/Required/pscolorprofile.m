function [on, ot] = pscolorprofile(txt)
%PSCOLORPROFILE    Get or set the color profile of the active document.
%   The return values are the current profile and profile type. The profile
%   type is 'working', 'custom', or 'none.
%
%   Example:
%   p = pscolorprofile
%   [p ,t] = pscolorprofile('Adobe RGB (1998)')
%
%   See also PSCONFIG, PSDOCINFO, PSCOLORSETTINGS, PSCONVERTPROFILE

%   Thomas Ruark, 2/3/2006
%   Copyright 2006 Adobe Systems Incorporated

pssep = '8F6AFB7E-EC1F-4b6f-AD15-C1AF34221EED';

% Build up the JavaScript
pstext = ['try { '...
    'var result = "";' ...
    'var errorDetails = "";' ...
    'if (activeDocument.colorProfileType != ColorProfile.NONE) {'...
    '    var a = activeDocument.colorProfileName;'...
    '} else {'...
    '    var a = " ";'...
    '}'...
    'a += "' pssep '";'...
    'a += activeDocument.colorProfileType.toString();'];
    
if nargin == 1
    pstext = [pstext 'if (activeDocument.colorProfileName != "' txt '")'];
    pstext = [pstext 'activeDocument.colorProfileName = "' txt '";'];
end

pstext = [pstext '} catch(e) {' ...
    '    errorDetails = e.toString();' ...
    '    result = "8F6AFB7E-EC1F-4b6f-AD15-C1AF34221EED";' ...
    '}'];

pstext = [pstext 'if ( result != "8F6AFB7E-EC1F-4b6f-AD15-C1AF34221EED" ) {'...
    '    result = a;' ...
    '} else {' ...
    '    result += errorDetails;' ...
    '}' ...
    'result;'];

psresult = psjavascriptu(pstext);

l = strfind(psresult, pssep);
n = {};
if l(1) == 1
    error(psresult(l(1)+length(pssep):end));
else
    le = length(psresult);
    c = 1;
    for ii = 1:length(l)
        n{ii} = psresult(c:l(ii)-1);
        c = c + length(n{ii}) + length(pssep);
    end
    n{length(l)+1} = psresult(c:le);
end

ot = strrep(n{2}, 'ColorProfile.', '');
ot = lower(ot);
on = n{1};
