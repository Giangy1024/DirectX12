% TESTALL   Find all test*.m files in order (test1.m, test2.m...) and run
% each in turn. The syntax is [a]=test1(cleanup, level); 'cleanup'
% (true/false) tells the script to clean up after itself to allow for
% individual tests to run from a known state. 'level' is 0 for simple
% tests, 1 for more complex, 2 etc. The output is a string 'PASS' otherwise
% an error is thrown giving you the line number and a descriptiont of the
% error. Please report any failures.

%   Thomas Ruark, 2/21/2007
%   Copyright 2007 Adobe Systems, Inc.

if ~exist('pscleanup', 'var')
    clear;
    pscleanup = true;
end
if ~exist('pslevel', 'var')
    pslevel = 0;
end
if ~exist('pslogfile', 'var')
    pslogfile = [strrep(which('testall'), 'testall.m', '') 'pstestlog.log'];
end
if ~exist('pstestpass', 'var')
    pstestpass = 0;
end
if ~exist('pstestfail', 'var')
    pstestfail = 0;
end
if ~exist('pstesttimes', 'var')
    pstesttimes = [];
end
if ~exist('psdisplay', 'var')
    psdisplay = true;
end
if ~exist('pslog', 'var')
    pslog = true;
end
pskeeprunning = true;
psfileindex = 1;
pslogit('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%', false, pslog, pslogfile);
pslogit('Harness / mfile version: 11', psdisplay, pslog, pslogfile);
pslogit('Harness date: 21-Feb-2007', psdisplay, pslog, pslogfile);
pslogit(datestr(now,0), psdisplay, pslog, pslogfile);
pslogit(['App name: ' psjavascriptu('app.name')], psdisplay, pslog, pslogfile);
pslogit(['App version: ' psjavascriptu('app.version')], psdisplay, pslog, pslogfile);
pslogit(['$ version: ' psjavascriptu('$.version')], psdisplay, pslog, pslogfile);
[mversion,mdate]=version;
minfo = version('-java');
pslogit(['MATLAB version: ' mversion], psdisplay, pslog, pslogfile);
pslogit(['MATLAB date: ' mdate], psdisplay, pslog, pslogfile);
[mstr,mmaxsize,mendian] = computer;
pslogit(['MATLAB computer: ' mstr], psdisplay, pslog, pslogfile);
pslogit(['MATLAB integer maxsize: ' num2str(mmaxsize)], psdisplay, pslog, pslogfile);
if strcmp(mendian, 'L')
    mendian = 'little endian';
else
    mendian = 'big endian';
end
pslogit(['MATLAB byte ordering: ' mendian], psdisplay, pslog, pslogfile);
pslogit(['MATLAB java version: ' minfo], psdisplay, pslog, pslogfile);
minfo = getenv('PROCESSOR_IDENTIFIER');
if length(minfo)
    pslogit(['env processor: ' minfo], psdisplay, pslog, pslogfile);
end
minfo = getenv('OS');
if length(minfo)
    pslogit(['env OS: ' minfo], psdisplay, pslog, pslogfile);
end

while ( pskeeprunning )
    pstestname = [ 'test' int2str( psfileindex ) ];
    psfilename = [ pstestname '.m' ];
    if exist(psfilename, 'file') == 2
        pshandle = str2func(pstestname);
        try
            tic;
            [pspass] = pshandle(pscleanup, pslevel);
            pstestpass = pstestpass + 1;
        catch
            pserror = lasterror;
            % get everything after the carriage return
            psgoodstuff = pserror.message;
            psstriploc = find(psgoodstuff == 10);
            psgoodstuff = psgoodstuff(psstriploc+1:end);
            pslogit([psfilename ' failed: ' psgoodstuff pserror.identifier pserror.stack(1).file pserror.stack(1).name ', line: ' num2str(pserror.stack(1).line)], false, pslog, pslogfile);
            pspass = ['FAIL : ' psgoodstuff ', line: ' num2str(pserror.stack(1).line)];
            pstestfail = pstestfail + 1;
        end
        pstesttimes = [pstesttimes toc];
        pslogit( [ pstestname ' : ' pspass ], psdisplay, pslog, pslogfile);
        psfileindex = psfileindex + 1;
    else
        pskeeprunning = false;
    end
end
pslogit(['Times: ' num2str(pstesttimes)], psdisplay, pslog, pslogfile);
pslogit(['Total Time: ' num2str(sum(pstesttimes))], psdisplay, pslog, pslogfile);
psdispstr = ['Total Pass: ' int2str(pstestpass) ];
psdispstr = [psdispstr ', Total Fail: ' int2str(pstestfail)];
pslogit(psdispstr, psdisplay, pslog, pslogfile);
