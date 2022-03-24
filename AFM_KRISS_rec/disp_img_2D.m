function X=disp_img_2D(xx,yy,dd)
##[a, b] = textread('fulldata5.txt', "%f %s");
##A=length(a)/3;
##
##x=a(1:3:end);
##y=a(2:3:end);
##d=a(3:3:end);
##A=length(a)/3;
##axis([0 5000 0 30])
##grid on
##axis([0 1000 0 30])
##axis([250 260 0 30])
##A=length(a)/256;
##
##xx=reshape(x,256,256);
##yy=reshape(y,256,256);
##dd=reshape(d,256,256);
##
##xx=xx';
##yy=yy';
##dd=dd';

imagesc(dd,'XData',[xx(1,1) xx(1,256)],'YData',[yy(1,1) yy(256,1)])