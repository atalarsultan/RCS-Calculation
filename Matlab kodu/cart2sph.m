function [R,theta,phi]=cart2sph(x,y,z)

% Bu dosya kartezyen koordinatları küresele dönüştürmek için kullanılır. 

R=sqrt(x^2+y^2+z^2);
theta=atan2(sqrt(x^2+y^2),z);
phi=atan2(y,x);