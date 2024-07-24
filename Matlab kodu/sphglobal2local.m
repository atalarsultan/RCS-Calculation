function [Rloc,thetaloc,philoc]=sphglobal2local(R,theta,phi,T21)

% Bu kod global küresel koordinatları yerel küresel koordinatlara çevirmek için kullanılır.

%kartezyene çevirme
[x,y,z]=sph2cart(R,theta,phi);
%yerel koordinatlara dönüştürme
tmp=T21*[x;y;z];
%küresele çevirme
[Rloc,thetaloc,philoc]=cart2sph(tmp(1),tmp(2),tmp(3));



