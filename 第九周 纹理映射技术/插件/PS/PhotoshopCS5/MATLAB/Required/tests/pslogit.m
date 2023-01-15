function [] = pslogit(m, displayit, logit, logfilename)
%PSLOGIT   Log using 'disp' or to a file
% pslogit('message', logtodisp, logtofile, logfilename);

%   Thomas Ruark, 11/07/2005
%   Copyright 2005 Adobe Systems, Inc.

if exist('displayit', 'var') && islogical(displayit) && displayit == true
    disp(m);
end

if exist('logit', 'var') && islogical(logit) && logit == true
    fid = fopen(logfilename, 'a');
    if (fid)
        fseek(fid, 0, 'eof');
        if ischar(m)
            fprintf(fid, '%s\n', m);
        elseif iscell(m)
            mstr = cell2struct(m, 'hello');
            fprintf(fid, '%s\n', mstr.hello);
        else
            fprintf(fid, 'unsupported logit:%s\n', class(m));
        end
        fclose(fid);
    end
end
