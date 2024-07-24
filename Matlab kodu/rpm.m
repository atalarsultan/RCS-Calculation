% radar cross section prediction with matlab (rpm)

% Global Değişkenlerin ilk değerleri
% Main Screen'in ilklendirilmesi

 clear all; clc; close all;

 global facet ntria modelname  	  
 global coord nvert 
 global scale symplanes
 global comments matrl
 global changed
 global coord1 facet1 scale1 symplanes1 comments1 matrl1
 global coord2 facet2 scale2 symplanes2 comments2 matrl2
 global attach
 global materials
 global thetadeg phideg RCSth RCSph dynr

 
 modelname='New';
 attach=0;
  
 mainscreen_App