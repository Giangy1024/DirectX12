function [e] = test6(cleanup, level)
%TEST6 Channels tests

%   Thomas Ruark, 5/10/2006
%   Copyright 2006 Adobe Systems, Inc.

psnewdoc();
a = pschannelnames();
b = pschannelnames(1);
c = psnumchannels();
d = psnumchannels(1);
if (length(cell2mat(a)) == length(cell2mat(b)))
    if (sum(cell2mat(a)==cell2mat(b)) ~= length(cell2mat(a)))
        error('test6:names', 'count of channels and channel names are off');
    end
else
    error('test6:names2', 'count of channels and channel names are off');
end
if (c == d)
    if (c ~= length(a))
        error('test6:names3', 'count is off');
    end
    if (d ~= length(b))
        error('test6:names4', 'count is off');
    end
else
    error('test6:names5', 'count is off');
end
pssetactivechannels({a{1},a{2}});
a = pschannelnames();
b = pschannelnames(1);
c = psnumchannels();
d = psnumchannels(1);
if (length(cell2mat(a)) == length(cell2mat(b)))
    error('test6:names6', 'count is off');
end
if (c == d)
    error('test6:names7', 'count is off');
end

if exist('cleanup', 'var') && cleanup
    while psnumdocs()
        psclosedoc(1);
    end
end

e = 'PASS';
