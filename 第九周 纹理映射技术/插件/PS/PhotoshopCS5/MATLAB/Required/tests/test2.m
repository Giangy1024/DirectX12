function [e] = test2(cleanup, level)
%TEST2 pslaunch, psquit

%   Thomas Ruark, 03/06/2010
%   Copyright 2006 Adobe Systems, Inc.

if strcmp(computer, 'MAC') || strcmp(computer, 'MACI') || strcmp(computer, 'MAC64') || strcmp(computer, 'MACI64')
    extraErrorMsg = 'known issue doing pslaunch';
else
    extraErrorMsg = '';
    pslaunch();
end

if strcmp(computer, 'MAC') || strcmp(computer, 'MACI') || strcmp(computer, 'MAC64') || strcmp(computer, 'MACI64')
    extraErrorMsg = 'known issue doing pslaunch';
else
    extraErrorMsg = '';
    psquit();
end

e = ['PASS ' extraErrorMsg];

