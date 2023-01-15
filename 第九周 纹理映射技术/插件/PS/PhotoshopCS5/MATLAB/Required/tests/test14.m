function [e] = test14(cleanup, level)
%TEST14 Unicode tests, You need your machine set up and the level needs to
%be higher than 1. For windows, install the Asian fonts and switch to
%Japanese mode.

%   Thomas Ruark, 5/10/2006
%   Copyright 2006 Adobe Systems, Inc.


if level > 1

        % J characters
        j = [26085 26412];
        jt = char(j);
        psnewdoc('undefined', 'undefined', 'undefined', jt);

        [a,b,c,d] = psdocinfo;

        if length(j) ~= sum(d==j)
            error('test14:unicode1', 'name does not match');
        end

        psnewlayer(jt);
        t = pslayernames;
        if length(j) ~= sum(t{1}==j)
            error('test14:unicode2', 'layer name does not match');
        end

        % hebrew characters
        j = [1488 1489];
        jt = char(j);
        psnewdoc('undefined', 'undefined', 'undefined', jt);

        [a,b,c,d] = psdocinfo;

        if length(j) ~= sum(d==j)
            error('test14:unicode3', 'name does not match');
        end

        psnewlayer(jt);
        t = pslayernames;
        if length(j) ~= sum(t{1}==j)
            error('test14:unicode4', 'layer name does not match');
        end

        % Latin high ascii
        j = [218 219];
        jt = char(j);
        psnewdoc('undefined', 'undefined', 'undefined', jt);

        [a,b,c,d] = psdocinfo;

        if length(j) ~= sum(d==j)
            error('test14:unicode5', 'name does not match');
        end

        psnewlayer(jt);
        t = pslayernames;
        if length(j) ~= sum(t{1}==j)
            error('test14:unicode6', 'layer name does not match');
        end

        if exist('cleanup', 'var') && cleanup
            while psnumdocs()
                psclosedoc(1);
            end
        end
end

e = 'PASS';
