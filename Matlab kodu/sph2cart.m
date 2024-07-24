function [x,y,z]=sph2cart(R,theta,phi)

% Bu kod küresel koordinatarı kartezyene çevirmek için kullanılır.

x=R*sin(theta)*cos(phi);
y=R*sin(theta)*sin(phi);
z=R*cos(theta);