function [r, t, n, d] = psconfig(r, t, n, d)
%PSCONFIG    Get and set the current preferences settings in Photoshop.
%   PSCONFIG('pixels') sets the ruler units to pixel mode. All dimension
%   values will be in pixel units. See PSDOCINFO for getting the width and
%   height from a document. Valid ruler units are 'cm', 'inches', 'mm',
%   'percent', 'picas', 'pixels', and 'points'.
%
%   PSCONFIG('pixels', 'pixels') sets the ruler and type units to pixel
%   mode. Valid type units are 'mm', 'pixels', and 'points'.
%
%   PSCONFIG('pixels', 'pixels', 10, 'no') sets the ruler and type units to
%   pixel mode, sets the number of history states to 10 and sets the dialog
%   modes to no dialogs. Valid history states are 1 to 1000. Lowering the
%   number of history states will enable Photoshop to run much faster and
%   consume less memory. Valid dialog modes are 'all' for showing all
%   dialogs, 'error' for showing only error dialogs, and 'no' for showing
%   no dialogs, errors will be reported to the command line.
%
%   [R] = PSCONFIG() gets the ruler units.
%
%   [R, T] = PSCONFIG() gets the ruler and type units.
%
%   It is recommended to run using the following configuration:
%   PSCONFIG('pixels', 'pixels', 10, 'no')
%
%   Example:
%   r = psconfig
%   psconfig('pixels')
%   psconfig('pixels', 'pixels', 10, 'no')
%
%   See also PSDOCINFO, PSCOLORSETTINGS, PSCONVERTPROFILE

%   Thomas Ruark, 2/3/2006
%   Copyright 2006 Adobe Systems Incorporated

pstext = ['try { '...
    'var result = "";' ...
    'var errorDetails = "";' ...
    'var a = [ app.preferences.rulerUnits.toString(),' ...
    'app.preferences.typeUnits.toString(),' ...
    'app.preferences.numberOfHistoryStates.toString(),' ...
    'app.displayDialogs.toString() ];'];

% Units. { CM INCHES MM PERCENT PICAS PIXELS POINTS }
if exist('r', 'var')
    r = upper(r);
    pstext = [pstext 'app.preferences.rulerUnits = Units.' r ';'];
end

% TypeUnits. { MM PIXELS POINTS }
if exist('t', 'var')
    t = upper(t);
    pstext = [pstext 'app.preferences.typeUnits = TypeUnits.' t ';'];
end

% ( 1 - 100 )
if exist('n', 'var')
    pstext = [pstext 'app.preferences.numberOfHistoryStates = ' num2str(n) ';'];
end

% DialogModes. { ALL ERROR NO }
if exist('d', 'var')
    d = upper(d);
    pstext = [pstext 'app.displayDialogs = DialogModes.' d ';'];
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
    'result = result.toSource();' ...
    'result = result.replace("[", "{");' ...
    'result = result.replace("]", "}");' ...
    'result = result.replace("TypeUnits.", "");' ...
    'result = result.replace("Units.", "");' ...
    'result = result.replace("DialogModes.", "");' ...
    'result = result.replace(/\"/g, String.fromCharCode(39));' ...
    'result;'];

psresult = psjavascriptu(pstext);

psresult = eval(psresult);

if strcmp(psresult{1}, '8F6AFB7E-EC1F-4b6f-AD15-C1AF34221EED')
    error(psresult{2});
end

d = lower(psresult{4});
n = str2double(psresult{3});
t = lower(psresult{2});
r = lower(psresult{1});
