% open up some files in the Photoshop samples folder

pspathOS = psjavascriptu('app.path.fsName');
pspathOS = fullfile(pspathOS, 'Samples');
    
pspath = psjavascriptu('app.path');
pspath = [pspath '/Samples'];
    
allfiles = dir(pspathOS);
doccount = 1;
    
allnames = [];
alltimes = [];
pixelcount = 0;

for x = 1 : length(allfiles)
    if ~allfiles(x).isdir
        if ~isempty([strfind(allfiles(x).name, '.tif') > 0 strfind(allfiles(x).name, '.psd') > 0 strfind(allfiles(x).name, '.jpg') > 0])
            tic;
            n = psopendoc([pspath '/' allfiles(x).name]);
            psjavascriptu('activeDocument.flatten();');
            r = psgetpixels();
            a = ndims(r);
            b = size(r);
            if a == 3 && b(3) == 3
                pixelcount = pixelcount + length(r(:));
                figure(doccount);
                set(doccount,'Position',[-3 39 1400 942]);
                set(doccount,'Name', n);
                subplot(133);
                imagesc(r);
                axis image;
                title(n);
                h = pshistogram(1);
                subplot(132);
                hold on;
                plot(h(:,1),'red');
                plot(h(:,2),'green');
                plot(h(:,3),'blue');
                set(subplot(132),'YScale','log');
                title('Log Histogram');
                subplot(131);
                hold on;
                plot(h(:,1),'red');
                plot(h(:,2),'green');
                plot(h(:,3),'blue');
                title('Histogram');
                doccount = doccount + 1;
                alltimes = [alltimes toc];
                allnames = [allnames n];
            end
        end
    end
end       

format long g
m = ['MegaPixels/sec: ' num2str(pixelcount/sum(alltimes)/1048576)];
disp(m);
msgbox(m);
format



