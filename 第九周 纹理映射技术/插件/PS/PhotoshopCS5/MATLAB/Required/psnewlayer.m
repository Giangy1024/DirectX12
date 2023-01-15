function [] = psnewlayer(n)
%PSNEWLAYER    Create a new layer on the current document in Photoshop.
%   PSNEWLAYER creates a layer with the default name.
%
%   PSNEWLAYER(N) create a new layer with the given name (N)
%
%   Example:
%   psnewlayer
%   psnewlayer('hi')
%
%   See also PSLAYERNAMES, PSNUMLAYERS, PSSETACTIVELAYER, PSNEWLAYERMATRIX

%   Thomas Ruark, 2/3/2006
%   Copyright 2006 Adobe Systems Incorporated

% Build up the JavaScript
pstext = 'try { var result = "";';
pstext = [pstext 'app.activeDocument.artLayers.add();'];


% footer start, wrap in try catch block
pstext = [pstext ' result = "OK";'];
pstext = [pstext '}'];
pstext = [pstext 'catch(e) { result = e.toString(); } '];
pstext = [pstext 'result;'];
% footer end, wrap in try catch block

psresult = psjavascriptu(pstext);

if ~strcmp(psresult, 'OK')
    error(psresult);
end

if exist('n', 'var')
    pstext = 'try { var result = "";';
    pstext = [pstext 'app.activeDocument.activeLayer.name = "' n '";'];

    % footer start, wrap in try catch block
    pstext = [pstext ' result = "OK";'];
    pstext = [pstext '}'];
    pstext = [pstext 'catch(e) { result = e.toString(); } '];
    pstext = [pstext 'result;'];
    % footer end, wrap in try catch block

    psresult = psjavascriptu(pstext);

    if ~strcmp(psresult, 'OK')
        error(psresult);
    end
end
