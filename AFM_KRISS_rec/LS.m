function X=LS(x,y,d,N)
Z=[sum(x.*x) sum(x) sum(x.*d);...

   sum(x) N sum(d);...

   sum(x.*d) sum(d) N];

Y=[sum(x.*y); sum(y); sum(y.*d)];

X=inv(Z)*Y;