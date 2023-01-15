function n = psnumlayers ()
%PSNUMLAYERS    Return the number of layers in the current document.
%
%   Example:
%   n = psnumlayers
%
%   See also PSLAYERNAMES, PSSETACTIVELAYER, PSNEWLAYER, PSNEWLAYERMATRIX

%   Thomas Ruark, 2/14/2006
%   Copyright 2006 Adobe Systems Incorporated

n = str2double(psjavascriptu('var a = 0; if (app.documents.length) a = app.activeDocument.layers.length; a;'));
