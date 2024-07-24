function [gammapar,gammaperp,thetat,TIR]=ReflCoeff(er1,mr1,er2,mr2,thetai)

% Bu fonksiyon paralel ve dikey polarizasyon için yansıma katsayısını, 
% transmisyon açısını ve Toplam İç Yansımanın (TIR) oluşup oluşmadığını hesaplar.

% er1,mr1 : dalganın geldiği ortamın relative parametreleri
% er2,mr2 :tranmsisyonun olduğu ortamın relative parametreleri
% thetai: dalganın geliş açısı
% gammapar, gammaperp: paralel ve dik yansıma katsayıları 
% thetat: transmisyon açısı
% Total Internal Reflection oluşursa TIR=1, oluşmazsa TIR=0


m0=4*pi*1e-7;  e0=8.854e-12;

TIR=0;
sinthetat=sin(thetai)*sqrt(real(er1)*real(mr1)/(real(er2)*real(mr2)));
if sinthetat>1
    TIR=1;
    thetat=pi/2;
end
thetat=asin(sinthetat);
n1=sqrt(mr1*m0/(er1*e0));
n2=sqrt(mr2*m0/(er2*e0));
gammaperp=(n2*cos(thetai)-n1*cos(thetat))/(n2*cos(thetai)+n1*cos(thetat));
gammapar=(n2*cos(thetat)-n1*cos(thetai))/(n2*cos(thetat)+n1*cos(thetai));
    
    
