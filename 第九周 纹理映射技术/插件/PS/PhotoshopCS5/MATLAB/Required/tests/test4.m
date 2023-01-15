function [e] = test4(cleanup, level)
%TEST4 Open all samples

%   Thomas Ruark, 10/30/2007
%   Copyright 2007 Adobe Systems, Inc.

psSamplesStr = psjavascriptu('localize("$$$/LocalizedFilenames.xml/SourceDirectoryName/id/Extras/[LOCALE]/[LOCALE]_Samples/value=Samples");');

pspath = psjavascriptu('app.path');
pspath = [pspath '/' psSamplesStr];

allfiles = psjavascriptu(['Folder("' pspath '").getFiles();']);
doccount = 0;

commalocations = find(allfiles == ',');
fileascells = {};
for x = 1:length(commalocations)
    if x == 1
        fileascells{x} = allfiles(1:commalocations(x)-1);
    else if x == length(commalocations)
            fileascells{x} = allfiles(commalocations(x)+1:end);
        else
            fileascells{x} = allfiles(commalocations(x)+1:commalocations(x+1)-1);
        end
    end
end

for x = 1 : length(fileascells)
    if ~isempty([strfind(fileascells{x}, '.tif') > 0 strfind(fileascells{x}, '.psd') > 0 strfind(fileascells{x}, '.jpg') > 0 strfind(fileascells{x}, '.dng') > 0])
        psopendoc(fileascells{x});
        doccount = doccount + 1;
    end
end

if ~doccount
    error('test4:openalldocs', ['no documents where found in : ' pspath]);
end

if exist('cleanup', 'var') && cleanup
    while psnumdocs()
        psclosedoc(1);
    end
end

e = 'PASS';

