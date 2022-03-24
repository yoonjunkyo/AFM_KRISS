function Y=Flush(A,B,n)

x=A;

N=length(x);

y=B;

hold on;

threshold=-30;
d=1*(y>threshold)+-1*(y<threshold);
Index=find(diff(d));

d_start=Index(n)+1;
d_finish=Index(n+1);
d_length=d_finish-d_start+1;
wlength=floor(d_length/3);
#round -> 반올림 / ceiling -> 올림

a_finish=Index(n);
a_start=a_finish-d_length+1;

b_start=Index(n+1)+1;
b_finish=b_start+d_length-1;

real_index=[a_start:a_finish-wlength,d_start+wlength:d_finish-wlength,...
b_start+wlength:b_finish];

x1=x(real_index);
y1=y(real_index);
d1=d(real_index);
N1=length(real_index);

X=LS(x1,y1,d1,N1);

plot(x1,X(1)*x1+X(2)+d1*X(3),'k-')

Y=2*X(3)
