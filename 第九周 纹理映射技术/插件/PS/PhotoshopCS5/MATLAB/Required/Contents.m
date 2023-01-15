% Adobe Photoshop toolbox.
% Version 1.0 13-Dec-2006
%
% General.
%   psconfig            - Get and set the current preferences settings in Photoshop.
%   psjavascript        - Execute the given text as JavaScript and return the result.
%   pslaunch            - Launch Photoshop or attach to an already running Photoshop.
%   psquit              - Quit the Photoshop application.
%
% Document functions.
%   psclosedoc          - Close the active document in Photoshop.
%   psdocinfo           - Return information for the current document in Photoshop.
%   psdocnames          - Return the names of all the open documents in Photoshop.
%   pshistogram         - Return the histogram for the current document.
%   psnewdoc            - Create a new document in Photoshop.
%   psnumdocs           - Return the number of documents currently open in Photoshop.
%   psopendoc           - Open the file in Photoshop.
%   pssetactivedoc      - Bring the document with the given name to the front.
%
% Color management functions.
%   pscolorprofile      - Get or set the color profile of the active document.
%   pscolorsettings     - Get or set the color settings.
%   psconvertprofile    - Convert the active document to the new profile.
%
% Layer functions.
%   pslayernames        - Return the layer names.
%   psnewlayer          - Create a new layer on the current document in Photoshop.
%   psnumlayers         - Return the number of layers in the current document.
%   pssetactivelayer    - Activate the current layer in the current document.
%
% Channel functions.
%   pschannelnames      - Return the channel names of the current document.
%   psnumchannels       - Return the number of channels in the current document.
%   pssetactivechannels - Activate the current channels in the current document. 
%
% Path functions.
%   psgetpath           - Return the path structure given the name.
%   psnewpath           - Create a new path in Photoshop.
%   psnumpaths          - Return the number of paths in the current document.
%   pspathnames         - Return the path names in the current document.
%
% Pixel functions.
%   psgetpixels         - Get pixel data from current layer in Photoshop.
%   psimread            - Open a document in Photoshop and return the pixel values.
%   psnewdocmatrix      - Create a new document in Photoshop from a matrix.
%   psnewlayermatrix    - Create a new layer in Photoshop from a matrix.
%   pssetpixels         - Set pixel data to the current layer in Photoshop.
%
% Filter functions.
%   psaddnoise          - Run the Add Noise filter.
%   psaverage           - Run the Average filter.
%   psblur              - Run the Blur filter.
%   psblurmore          - Run the Blur More filter.
%   psboxblur           - Run the Box Blur filter.
%   pscustom            - Run the Custom filter.
%   psdustandscratches  - Run the Dust and Scratches filter.
%   psgaussianblur      - Run the Gaussian Blur filter.
%   pshighpass          - Run the High Pass filter
%   pslensblur          - Run the Lens Blur filter.
%   psmaximum           - Run the Maximum filter.
%   psmedian            - Run the Median filter.
%   psminimum           - Run the Minimum filter.
%   psmotionblur        - Run the Motion Blur filter.
%   psoffset            - Run the Offset filter.
%   psradialblur        - Run the Radial Blur filter.
%   psshapeblur         - Run the Shape Blur filter.
%   pssharpen           - Run the Sharpen filter.
%   pssharpenedges      - Run the Sharpen Edges filter.
%   pssharpenmore       - Run the Sharpen More filter.
%   pssmartblur         - Run the Smart Blur filter.
%   pssurfaceblur       - Run the Surface Blur filter.
%   psunsharpmask       - Run the Unsharp Mask filter.

%   Copyright 2006 Adobe Photoshop, Inc.
