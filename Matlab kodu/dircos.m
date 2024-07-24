function [R,RR,st,ct,cp,sp]=dircos(thr,phr)

% Bu dosya yön kosinüslerinin hesaplama fonksiyonlarını içerir.

% thr, phr : theta and phi açıları
%yön kosinüsleri
% u=sintheta*cosphi
% v=sintheta*sinphi
% w=costheta
% R=[u v w]  
% uu: costheta*cosphi
% vv=costheta*sinphi
% ww=-sintheta
% RR=[uu vv ww] 
% sp=sinphi 
% cp=cosphi 

 st = sin(thr); 	
 ct = cos(thr);
 cp = cos(phr);		
 sp = sin(phr);
 u = st*cp; 			
 v = st*sp; 			
 w = ct ; 			
 R = [u v w];
 uu = ct*cp; 		
 vv = ct*sp; 		
 ww = -st;
 RR=[uu vv ww]; 