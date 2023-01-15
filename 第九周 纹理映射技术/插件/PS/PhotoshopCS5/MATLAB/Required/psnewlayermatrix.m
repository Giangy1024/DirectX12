function [] = psnewlayermatrix(img, t)
%PSNEWLAYERMATRIX    Create a new layer in Photoshop from a matrix.
%   PSNEWLAYERMATRIX(IMG) Create the new layer and assign the pixel values.
%   The layer will have no transparency.
%
%   PSNEWLAYERMATRIX(IMG,T) T is for the transparency values for the new
%   layer.
%
%   Dimensions of matrix must match the dimensions of the document.
%
%   Example:
%   psnewlayermatrix(img)
%   psnewlayermatrix(img, t)
%
%   See also PSLAYERNAMES, PSNUMLAYERS, PSSETACTIVELAYER, PSNEWLAYER

%   Thomas Ruark, 01/28/2007
%   Copyright 2007 Adobe Systems Incorporated

psresult = psjavascriptu('try { app.activeDocument.artLayers.add(); "OK"; } catch(e) { e.toString(); }');

if ~strcmp(psresult, 'OK')
    error(psresult);
end

ru = psconfig();

if ~strcmp(ru, 'pixels')
    psconfig('pixels');
end

if ~exist('t', 'var')
    [w, h, r, n, m, d] = psdocinfo();
    if d == 8
        d = 'uint8';
    elseif d == 16
        d = 'uint16';
    else
        d = 'double';
    end

    t = ones(h, w, d) * 255;
end

% set the transparency so we see everything
pssetpixels(t, 16);

pssetpixels(img);

if ~strcmp(ru, 'pixels')
    psconfig(ru);
end
