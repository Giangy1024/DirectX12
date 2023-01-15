function p = psgetpath(n)
%PSGETPATH    Return the path structure given the name.
%   P = PSGETPATH(N) N is the name of the path. P is a struct.
%
%   P.kind is the kind of path: 'normal', 'clipping', 'vector', 'work', or
%   'text'.
%
%   P.subpathitems is an array of struct.
%
%   subpathitems.closed is a boolean for whether the path is a closed path
%   or not.
%
%   subpathitems.operation is the operation the path performs: 'add',
%   'intersect', 'subtract', or 'xor'.
%
%   subpathitems.pathpoints is yet another array of struct.
%
%   pathpoints.kind is the kind for the path point: 'corner' or 'smooth'
%
%   pathpoints.points is an array of 6 representing 3 x-y points. The first
%   point is the anchor, the second point is the left direction and the
%   third point is the right direction.
%
%   Example:
%   p = psgetpath('Path 1')
%
%   See also PSNEWPATH, PSNUMPATHS, PSPATHNAMES

%   Thomas Ruark, 2/3/2006
%   Copyright 2006 Adobe Systems Incorporated

% Build up the JavaScript
pstext = ['var psresult = "";' ...
    'try { ' ...
    '    var psPath = [];' ...
    '    var onePath = app.activeDocument.pathItems["' n '"];' ...
    '    psPath.push(onePath.kind.toString());' ...
    '    for (var i = 0; i < onePath.subPathItems.length; i++) { ' ...
    '        var psSubPath = [];' ...
    '        var oneSubPath = onePath.subPathItems[i];' ...
    '        psSubPath.push(oneSubPath.closed.toString());' ...
    '        psSubPath.push(oneSubPath.operation.toString());' ...
    '        for (var j = 0; j < oneSubPath.pathPoints.length; j++) { ' ...
    '            var psPathPoint = [];' ...
    '            var onePathPoint = oneSubPath.pathPoints[j];' ...
    '            psPathPoint.push(onePathPoint.kind.toString());' ...
    '            psPathPoint.push(onePathPoint.anchor[0]);' ...
    '            psPathPoint.push(onePathPoint.anchor[1]);' ...
    '            psPathPoint.push(onePathPoint.leftDirection[0]);' ...
    '            psPathPoint.push(onePathPoint.leftDirection[1]);' ...
    '            psPathPoint.push(onePathPoint.rightDirection[0]);' ...
    '            psPathPoint.push(onePathPoint.rightDirection[1]);' ...
    '            psSubPath.push(psPathPoint);' ...
    '        }' ...
    '        psPath.push(psSubPath);' ...
    '    }' ...
    '    psresult = psPath.toSource();' ...
    '    psresult = psresult.replace(/\"/g, String.fromCharCode(39));' ...
    '    psresult = psresult.replace(/\[/g, "{");' ...
    '    psresult = psresult.replace(/\]/g, "}");' ...
    '}' ...
    'catch(e) { ' ...
    '    psresult = e.toString();' ...
    '}' ...
    'psresult;'];

psresult = psjavascriptu(pstext);

try
    pspathdata = eval(psresult);
catch
    if ischar(psresult)
        error(psresult);
    end
end

p = struct;

if strcmp(pspathdata{1}, 'PathKind.NORMALPATH')
    p.kind = 'normal';
elseif strcmp(pspathdata{1}, 'PathKind.CLIPPINGPATH')
    p.kind = 'clipping';
elseif strcmp(pspathdata{1}, 'PathKind.VECTORMASK')
    p.kind = 'vector';
elseif strcmp(pspathdata{1}, 'PathKind.WORKPATH')
    p.kind = 'work';
elseif strcmp(pspathdata{1}, 'PathKind.TEXTMASK')
    p.kind = 'text';
else
    p.kind = 'unknown';
end

pssubpathitems = [];

% first item is handled above
for a = 2:length(pspathdata)
    pssubpathdata = pspathdata{a};
    pssubpath = struct;
    pssubpath.closed = eval(cell2mat(pssubpathdata(1)));

    if strcmp(cell2mat(pssubpathdata(2)), 'ShapeOperation.SHAPEADD')
        pssubpath.operation = 'add';
    elseif strcmp(cell2mat(pssubpathdata(2)), 'ShapeOperation.SHAPEINTERSECT')
        pssubpath.operation = 'intersect';
    elseif strcmp(cell2mat(pssubpathdata(2)), 'ShapeOperation.SHAPESUBTRACT')
        pssubpath.operation = 'subtract';
    elseif strcmp(cell2mat(pssubpathdata(2)), 'ShapeOperation.SHAPEXOR')
        pssubpath.operation = 'xor';
    else
        pssubpath.operation = 'unknown';
    end

    pssubpath.pathpoints = [];

    % first two items handled above
    for b = 3:length(pssubpathdata)
        pspathpointdata = pssubpathdata{b};
        pspathpoint = struct;
        if strcmp(cell2mat(pspathpointdata(1)), 'PointKind.CORNERPOINT')
            pspathpoint.kind = 'corner';
        elseif strcmp(cell2mat(pspathpointdata(1)), 'PointKind.SMOOTHPOINT')
            pspathpoint.kind = 'smooth';
        else
            pspathpoint.kind = 'unknown';
        end
        pspathpoint.points = cell2mat([pspathpointdata(2) pspathpointdata(3) pspathpointdata(4) pspathpointdata(5) pspathpointdata(6) pspathpointdata(7)]);
        pssubpath.pathpoints = [pssubpath.pathpoints pspathpoint];
    end
    pssubpathitems = [pssubpathitems pssubpath];
end

p.subpathitems = pssubpathitems;
