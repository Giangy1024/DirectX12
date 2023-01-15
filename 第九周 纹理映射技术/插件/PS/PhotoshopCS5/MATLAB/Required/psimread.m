function img = psimread(f, fd, c)
%PSIMREAD    Open a document in Photoshop and return the pixel values.
%   PSIMREAD(F) Is equivalent to calling PSOPENDOC(F); I = PSGETPIXELS();
%   F is the name of the file. Full path to the file is required.
%
%   PSIMREAD(F,FD) FD is for flatten the document. If the document is a
%   layered document and you do not flatten the document, the current layer
%   pixel data is returned. Default is true, flatten the document.
%
%   PSIMREAD(F,FD,C) C is for close the document. Grab the pixels then
%   close the document. Default is false, leave the document open.
%
%   Example:
%   img = psimread('myfile.psd');
%
%   See also PSQUIT, PSJAVASCRIPT, PSCONFIG

%   Thomas Ruark, 2/23/2006
%   Copyright 2006 Adobe Systems Incorporated

psopendoc(f);

ft = true;

if exist('fd', 'var')
    if ~fd
        ft = false;
    end
end

if ft
    psjavascriptu('activeDocument.flatten()');
end

img = psgetpixels();

% ScottC, ScottC, ScottC, are you kidding me!
if exist('c', 'var')
    if c
        psclosedoc(1);
    end
end
