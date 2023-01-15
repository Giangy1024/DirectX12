function h = pshistogram(a)
%PSHISTOGRAM   Return the histogram for the current document.
%   H = PSHISTOGRAM Returns the document histogram. The composite channels
%   must be selected in order for this to work. 
%
%   H = PSHISTOGRAM(0) is the same as above.
%   
%   H = PSHISTOGRAM(1) is the histogram for each active channel.
%
%   Example:
%   h = pshistogram
%   ach = pshistogram(1)
%
%   See also PSSETACTIVEDOC, PSCLOSEDOC, PSDOCNAMES, PSNEWDOC,
%   PSNEWDOCMATRIX, PSNUMDOCS, PSOPENDOC, PSDOCINFO

%   Thomas Ruark, 2/3/2006
%   Copyright 2006 Adobe Systems Incorporated

usedochistogram = 'true';

if exist('a', 'var')
    if a == 1
        usedochistogram = 'false';
    end
end

% Build up the JavaScript
pstext = ['var channelHistograms = [];' ...
    'var useDocHistogram = ' usedochistogram ';' ...
    'if (app.documents.length) {' ...
    '    var doc = app.activeDocument;' ...
    '    if (useDocHistogram) {' ...
    '        channelHistograms.push(doc.histogram);' ...
    '    } else {' ...
    '        for (var i = 0; i < doc.activeChannels.length; i++) {' ...
    '            channelHistograms.push(doc.activeChannels[i].histogram);' ...
    '        }' ...
    '    }' ...
    '}' ...
    'var b = channelHistograms.toSource();' ...
    'b = b.replace(/\\\"/g, "");' ...
    'b = b.replace(/\"/g, "");' ...
    'b = b.replace(/\[/g, "{");' ...
    'b = b.replace(/\]/g, "}");' ...
    'b;'];

psresult = psjavascriptu(pstext);

cellhistogram = eval(psresult);

c = length(cellhistogram);
r = length(cellhistogram{1});

h = zeros(r,c);

for x = 1 : c
    h(:,x) = cell2mat(cellhistogram{x});
end
