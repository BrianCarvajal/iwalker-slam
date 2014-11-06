

pL = 0:0.05:1;
n = 10;
m = length(pL);
p = zeros(m, n);

colors = jet(length(pL));
figure;

for i = 1:length(pL)
    plaser = pL(i);
    p(i,1) = 0.5;
    for j = 2:n
       p(i,j) = GridMap.updateCell(p(i, j-1), logit(plaser));
    end
    plot(0:n-1, p(i,:), 'color', colors(i,:), 'linewidth', 2, 'userdata', num2str(plaser));
    hold on;
end
legend(get(gca, 'children'), get(get(gca, 'children'), 'userdata'));
axis([-0.1 10.1 -0.1 1.1]);
grid on;
whitebg([0 0 0]);

figure;
%plot(0:n-1, p(find(pL == 0.75),:), 'color', 'b','linewidth', 2 );
%axis([-0.1 10.1 -0.1 1.1]);
grid on;
hold on;


%% Comparation betwen dobule and 8bits solutions, plaser = 0.75
pd = zeros(1,n, 'double');
pd(1) = 0.5;
p8b = zeros(1,n, 'uint8');
p8b(1) = 127;
for i = 2:n
   p8b(i) =  p8b(i-1) + GridMap8b.cellIncrement(p8b(i-1));
   pd(i) = GridMap.updateCell(pd(i-1), logit(0.75));
end
for i = n+1:3*n
   p8b(i) = p8b(i-1) - GridMap8b.cellIncrement(p8b(i-1));
   pd(i) = GridMap.updateCell(pd(i-1), logit(0.25));
end
for i = 3*n+1:5*n
   p8b(i) = p8b(i-1) + GridMap8b.cellIncrement(p8b(i-1));
   pd(i) = GridMap.updateCell(pd(i-1), logit(0.75));
end

X = 0:length(p8b)-1;
Y1 = pd;
Y2= p8b;

[ax, h1, h2] = plotyy(X, pd, X, p8b);
set(ax(1), 'YLim', [0 1], 'YTick', 0:0.05:1);
set(ax(2), 'YLim', [0 256], 'YTick', 0:16:256);
set(h1, 'linewidth', 2);
set(h2, 'linewidth', 2);
