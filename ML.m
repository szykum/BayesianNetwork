clc 
% z= -5 :0.02:5;
% y = hardlims(z);
% % y = logsig(z);
% % y = tansig(z);
% % y = purelin(z);
% plot(z,y,'r+');
INput = [5 20; -10 10; 0 1; 100 10000];

net = newff(INput, [4 5 6],{'hardlim','logsig','logsig'})
%net.view;

netAND = newff([0 1;0 1], 1, {'hardlim'})
netAND.IW{1}=[1 1];
netAND.b{1}= -1.5;

sim(netAND,[0 0 1 1;0 1 0 1])

[X,Y] = meshgrid(-1:0.02:2);
Z = X;
Z(:) = sim(netAND,[X(:)';Y(:)']);
%surf(X,Y,Z)

netNOR = newff([0 1;0 1], 1, {'hardlim'})
netNOR.IW{1}=[-1 -1];
netNOR.b{1}= 0.5;
sim(netNOR,[0 0 1 1;0 1 0 1])
[X,Y] = meshgrid(-1:0.02:2);
Z = X;
Z(:) = sim(netNOR,[X(:)';Y(:)']);
%surf(X,Y,Z)


netXOR = newff([0 1;0 1], [2 1], {'hardlim', 'hardlim'})
netXOR.IW{1}=[-1 1; 1 -1];
netXOR.b{1}=[-0.5;-0.5];
netXOR.LW{2,1}=[1 1];
netXOR.b{2}=-0.5;
sim(netXOR,[0 0 1 1;0 1 0 1])


