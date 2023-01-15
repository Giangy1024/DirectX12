function [e] = test7(cleanup, level)
%TEST7 psconfig tests. This has a level 0 and level 1 tests.

%   Thomas Ruark, 5/10/2006
%   Copyright 2006 Adobe Systems, Inc.



% FULL TESTS
if exist('level', 'var') && level > 0
    ruc = { 'cm' 'inches' 'mm' 'percent' 'picas' 'pixels' 'points' };
    tuc = { 'mm' 'pixels' 'points' };
    nhv = [ 1 2 3 4 5 50 60 70 90 100 ]; % this could be fuller!
    ddc = { 'error' 'no' }; % leave out 'all' because well that is annoying
else
    ruc = { 'inches' 'pixels' };
    tuc = { 'mm' 'pixels' };
    nhv = [ 5 50 ];
    ddc = { 'error' 'no' }; % leave out 'all' because well that is annoying
end

[sru, stu, shs, sdd] = psconfig();

for a = 1 : length(ruc)
    for b = 1 : length(tuc)
        for c = 1 : length(nhv)
            for d = 1 : length(ddc)
                [ru, tu, hs, dd] = psconfig(ruc{a}, tuc{b}, nhv(c), ddc{d});
                [ru, tu, hs, dd] = psconfig();
                if ~strcmp(ruc{a}, ru)
                    error('test7:config1', [ruc{a} ' ~= ' ru]);
                end
                if ~strcmp(tuc{b}, tu)
                    error('test7:config2', [tuc{a} ' ~= ' tu]);
                end
                if nhv(c) ~= hs
                    error('test7:config3', [num2str(nhv(c)) ' ~= ' num2str(hs)]);
                end
                if ~strcmp(ddc{d}, dd)
                    error('test7:config4', [ddc{d} ' ~= ' dd]);
                end
            end
        end
    end
end

psconfig(sru, stu, shs, sdd);

e = 'PASS';

