close all;

r = 4;
res = 0.5;
X = r*cosd(0:res:260);
Y = r*sind(0:res:260);
lim = [-5 5];
gm8b = GridMap8b(res, lim, lim);
tic;
gm8b.update([0; 0], [X;Y], ones(1,length(X))*r, [0 100]);
toc
imshow(gm8b.map);

gm = GridMap(res, lim, lim);
tic;
gm.update([0; 0], [X;Y], ones(1,length(X))*r, [0 100]);
toc
figure;
imshow(gm.image);
