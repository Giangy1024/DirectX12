function [] = psnewpath(n, p)
%PSNEWPATH    Create a new path in Photoshop.
%   PSNEWPATH(N,P) N for the name of the new path. P is the path struct.
%
%   The path is an array of struct. See PSGETPATH and the subpathitems
%   structure.
%
%   Example:
%   psnewpath('Path 1', mypathstruct);
%
%   See also PSGETPATH, PSNUMPATHS, PSPATHNAMES

%   Thomas Ruark, 2/3/2006
%   Copyright 2006 Adobe Systems Incorporated

pssubpatharray = 'var psSubPathArray = new Array();';

for a = 1:length(p)

    if strcmp(p(a).operation, 'add')
        psoperation = 'ShapeOperation.SHAPEADD';
    elseif strcmp(p(a).operation, 'intersect')
        psoperation = 'ShapeOperation.SHAPEINTERSECT';
    elseif strcmp(p(a).operation, 'subtract')
        psoperation = 'ShapeOperation.SHAPESUBTRACT';
    elseif strcmp(p(a).operation, 'xor')
        psoperation = 'ShapeOperation.SHAPEXOR';
    end

    if p(a).closed
        psclosed = 'true';
    else
        psclosed = 'false';
    end

    pssubpatharray = [pssubpatharray 'psSubPathArray[' num2str(a-1) '] = new SubPathInfo();' ...
        'psSubPathArray[' num2str(a-1) '].operation = ' psoperation ';' ...
        'psSubPathArray[' num2str(a-1) '].closed = ' psclosed ';'];

    pspathpointstr = 'var psPointArray = new Array();';

    for b = 1:length(p(a).pathpoints)
        pspathpoint = p(a).pathpoints(b);

        if strcmp(pspathpoint.kind, 'corner')
            pskind = 'PointKind.CORNERPOINT';
        elseif strcmp(pspathpoint.kind, 'smooth')
            pskind = 'PointKind.SMOOTHPOINT';
        end

        psanchor = [num2str(pspathpoint.points(1)) ',' num2str(pspathpoint.points(2))];
        psleft = [num2str(pspathpoint.points(3)) ',' num2str(pspathpoint.points(4))];
        psright = [num2str(pspathpoint.points(5)) ',' num2str(pspathpoint.points(6))];

        pspathpointstr = [pspathpointstr 'psPointArray[' num2str(b-1) '] = new PathPointInfo();' ...
            'psPointArray[' num2str(b-1) '].kind = ' pskind ';' ...
            'psPointArray[' num2str(b-1) '].anchor = Array(' psanchor ');' ...
            'psPointArray[' num2str(b-1) '].leftDirection = Array(' psleft ');' ...
            'psPointArray[' num2str(b-1) '].rightDirection = Array(' psright ');'];

        pssubpatharray = [pssubpatharray pspathpointstr];
    end

    pssubpatharray = [pssubpatharray 'psSubPathArray[' num2str(a-1) '].entireSubPath = psPointArray;'];

end

% Build up the JavaScript
pstext = ['var psresult = "";' ...
    'try { ' ...
    '    ' pssubpatharray ' ' ...
    '    app.activeDocument.pathItems.add("' n '", psSubPathArray );' ...
    '    psresult = "OK";' ...
    '}' ...
    'catch(e) { ' ...
    '    psresult = e.toString();' ...
    '}' ...
    'psresult;'];

psresult = psjavascriptu(pstext);

if ~strcmp(psresult, 'OK')
    error(psresult);
end
