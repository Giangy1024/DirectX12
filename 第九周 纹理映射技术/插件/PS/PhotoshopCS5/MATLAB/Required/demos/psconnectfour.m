function [] = psconnectfour()
%PSCONNECTFOUR    Play a connect four game in Photoshop
%   PSCONNECTFOUR Allows two people to play a game of connect four in
%   Photoshop. This demo shows some of the features of the Photoshop
%   Toolbox.
%
%   Example:
%   psconnectfour
%

%   Scott Cohen, 10/20/2006
%   Copyright 2006 Adobe Systems Incorporated


psopendoc(fullfile(pwd, 'c4redchecker.psd'));
redchecker = psgetpixels('undefined');
redcheckeralpha = psgetpixels(16);
psopendoc(fullfile(pwd, 'c4blackchecker.psd'));
blackchecker = psgetpixels('undefined');
blackcheckeralpha = psgetpixels(16);
psopendoc(fullfile(pwd, 'c4gameboard.psd'));

B = zeros(6,7);

turn = 1;
while (~all(B(:)))
    if (turn == 1)
        ans = input('RED''s turn: which column (1 to 7)? ');
    else
        ans = input('BLACKS''s turn: which column (1 to 7)? ');
    end
    col = ans;
    if ((col < 1) | (col > 7))
        continue;
    end

    R = find(B(:,col),1);
    if (isempty(R)) R = 7; end
    if (R == 1)
        continue;
    end
    B(R-1,col) = turn;

    pssetactivelayer('Checker');
    if (turn == 1)
        checker = redchecker;
        checkeralpha = redcheckeralpha;
    else
        checker = blackchecker;
        checkeralpha = blackcheckeralpha;
    end

    for r=0:(R-1)
        left = 100*(col-1) + 50;
        right = left + 100;
        top = 100*r;
        bottom = top + 100;
        restore = psgetpixels('undefined',top,left,bottom,right);
        restorealpha = psgetpixels(16,top,left,bottom,right);
        pssetpixels(checkeralpha,16,top,left,bottom,right);
        pssetpixels(checker,'undefined',top,left,bottom,right); 
        psjavascriptu('app.refresh();');
        if (r < R-1)
            pssetpixels(restore,'undefined',top,left,bottom,right);
            pssetpixels(restorealpha,16,top,left,bottom,right);
        end
    end

    turn = 3-turn;
end
