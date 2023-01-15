% Do a plot in MATLAB and Photoshop

A=[0 -6 -1; 6 2 -16; -5 20 -10];
x0=[1;1;1];
X=[];
for t = 0:0.01:1
    X=[X expm(t*A)*x0];
end
plot3(X(1,:),X(2,:),X(3,:), '-o');
grid on;
print -dpng 'test.png';
psopendoc(fullfile(pwd,'test.png'));
psjavascriptu('app.bringToFront()');


