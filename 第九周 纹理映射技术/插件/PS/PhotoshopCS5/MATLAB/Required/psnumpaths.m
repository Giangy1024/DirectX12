function n = psnumpaths()
%PSNUMPATHS    Return the number of paths in the current document.
%
%   Example:
%   n = psnumpaths
%
%   See also PSNEWPATH, PSGETPATH, PSPATHNAMES

%   Thomas Ruark, 2/14/2006
%   Copyright 2006 Adobe Systems Incorporated

n = str2double(psjavascriptu('var a = 0; if (app.documents.length) a = app.activeDocument.pathItems.length; a;'));
