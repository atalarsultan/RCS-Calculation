function [R,theta,phi]=sphlocal2global(Rloc,thetaloc,philoc,T21)

% Bu kod yerel küresel koordinatları global küresel koordinatlara çevirmek için kullanılır.

%kartezyene çevirme
[xloc,yloc,zloc]=sph2cart(Rloc,thetaloc,philoc);
%yerel koordinatlara dönüştürme
tmp=inv(T21)*[xloc;yloc;zloc];
%küresele çevirme
[R,theta,phi]=cart2sph(tmp(1),tmp(2),tmp(3));



