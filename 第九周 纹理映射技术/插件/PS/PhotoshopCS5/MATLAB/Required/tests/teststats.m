function [a] = teststats()
%TESTSTATS   Look at all the functions in 'mfiles' and then calculate the
%usage by scanning the 'tests' folders.
%
% Returns an array of structs (a.name a.count)
%
% Also writes to a comma separated file, 'teststats.csv'
%
% Example: [a] = teststats();
% 
% Find the ones that are not getting tested via
%  bbb=find([a.count] == 0)
%  a(bbb).name
%  Show some coverage stats with this
%  [a.count]

a = struct;
b = 1;

% get all the routines
c = which('pslaunch.m');
d = strrep(c, 'pslaunch.m', '');
e = dir(d);
for g = 1 : length(e)
    if ~e(g).isdir && ~strcmp(e(g).name, '.DS_Store') && ~isempty(strfind(e(g).name, '.m'))
        a(b).name = strrep(e(g).name, '.m', '');
        a(b).count = 0;
        b = b + 1;
    end
end

% get all the tests
c = fullfile(d, 'tests\');
e = dir(c);
f = {};
for g = 1 : length(e)
    if ~e(g).isdir && ~strcmp(e(g).name, '.DS_Store') && ~isempty(strfind(e(g).name, '.m'))
        f = [f {[c e(g).name]}];
    end
end

for g = 1 : length(f)
    fid = fopen(f{g});
    bb = fread(fid, 'uint8=>char') ;
    bb = bb';
    for gg = 1 : length(a)
        bbb = strfind(bb, a(gg).name);
        a(gg).count = a(gg).count + length(bbb);
        for ggg = 1 : length(bbb)
            if uint8(bb(bbb(ggg)-1)) == 39
                a(gg).count = a(gg).count - 1;
            end
        end
    end
    fclose(fid);
end

fid = fopen(fullfile(c, 'teststats.csv'), 'w');
for gg = 1 : length(a)
    fprintf(fid, '%s, %d\n', a(gg).name, a(gg).count);
end
fclose(fid);
