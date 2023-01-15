function n = pslayernames()
%PSLAYERNAMES    Return the layer names.
%   N = PSLAYERNAMES returns a cell array of all the layers in the
%   document.
%
%   Example:
%   n = pslayernames
%
%   See also PSNUMLAYERS, PSSETACTIVELAYER, PSNEWLAYER, PSNEWLAYERMATRIX

%   Thomas Ruark, 2/3/2006
%   Copyright 2006 Adobe Systems Incorporated

% Build up the JavaScript
%    'b = b.replace("[", "");' ...
  %  'b = b.replace("]", "");' ...

pssep = '8F6AFB7E-EC1F-4b6f-AD15-C1AF34221EED';

pstext = ['var layerNames = "";' ...
    'if (app.documents.length)' ...
    '{' ...
    '    for (var i = 0; i < app.activeDocument.layers.length; i++) {' ...
    '        layerNames += app.activeDocument.layers[i].name;' ...
    '        if ((i + 1) != app.activeDocument.layers.length) {' ...
    '            layerNames += "' pssep '";'...
    '        }' ...
    '    }' ...
    '}' ...
    'layerNames;'];

t = psjavascriptu(pstext);
l = strfind(t, pssep);
n = {};
if ~isempty(l)
    le = length(t);
    c = 1;
    for ii = 1:length(l)
        n{ii} = t(c:l(ii)-1);
        c = c + length(n{ii}) + length(pssep);
    end
    n{length(l)+1} = t(c:le);
else
    n{1} = t;
end
