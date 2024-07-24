function [Ets,Etd,Eps,Epd]=facetRCS(thr,phr,ithetar,iphir,N,ilum,iflag,alpha,beta,Rs,Area,x,y,z,vind,e0,Nt,Lt,wave,rsmethod,RCpar,RCperp)
% N : Normal vector
% ithetar,iphr: incidence angle
% vind: yüzeyin köşe indis matrisi
% e0 : incident field
% Rs : yüzey direnci 
% Lt : Taylor serisi bölgesi
% Nt : Taylor serisindeki terim sayısı
% Area: üçgen yüzeyin alanı
% Co: bütün köşelerdeki dalga genliği (wave amplitude)
% wave: wavelength


Co=1; 
bk=2*pi/wave; % wavenumber
Etd = 0; % teğetsel (tangential) elektrik alan bileşeni
Epd = 0; % dik (perpendicular) elektrik alan bileşeni


%MONOSTATIC DURUM
if (thr==ithetar) & (phr==iphir)
    
      %global açılar ve yön kosinüsleri
                st = sin(thr); ct = cos(thr);
   	            cp = cos(phr);	sp = sin(phr);
				u = st*cp; 	v = st*sp; 	w = ct ;            
                D0=[u v w]; % küresel yön kosinüslerini bir dizi vektörü olarak tutar.
                uu = ct*cp; vv = ct*sp; 	ww = -st;
                % Küresel koordinat sisteminde dışarı yönlü radyal birim vektör
				R = [u v w];
				    	   % Yüzeyin aydınlanıp aydınlanmadığının testi
                    ndotk = N*R.';  % N:Normal vector,  R.' : R dışa doğru radyal birim vektörünün karmaşık eşleniğinin transpozesi
                   if (ilum == 1 & ndotk >= 1e-5) | ilum == 0
							% yerel yön kosinüsleri
            	      ca = cos(alpha); sa = sin(alpha);  cb = cos(beta); sb = sin(beta);
					  T1 = [ca sa 0; -sa ca 0; 0 0 1]; T2 = [cb 0 -sb; 0 1 0; sb 0 cb]; % dönüşüm matrisleri
                      D1 = T1*D0.';
                      D2 = T2*D1;
	                  u2 = D2(1); v2 = D2(2);  w2 = D2(3); %  D2 vektöründen yerel yön vektörünün bireysel bileşenlerini (x, y ve z) çıkarır.
				      % yerel koordinatlarda küresel açıları bulma
                      st2 = sqrt(u2^2 + v2^2)*sign(w2);  % st2: yerel koordinatlarda sinteta
                      ct2 = sqrt(1 - st2^2); % ct2 :yerel koordinatlarda costeta
    				  phi2 = atan2(v2,u2+1e-10); % u2'nin sıfır olması durumunda sıfıra bölünmesini önler.
				      th2 = acos(ct2);
   	                  cp2 = cos(phi2); 
      	              sp2 = sin(phi2);
        			  % üçgen yüzeyin köşelerindeki fazlar; monostatik durum için 2* gerekli  % Bu fark, üçgen üzerindeki iki nokta arasındaki yol farkı nedeniyle dalganın yaşadığı faz kaymasını temsil eder.  
            	   	  Dp = 2*bk*((x(vind(1)) - x(vind(3)))*u + (y(vind(1)) - y(vind(3)))*v + (z(vind(1)) - z(vind(3)))*w);
	               	  Dq = 2*bk*((x(vind(2)) - x(vind(3)))*u + (y(vind(2)) - y(vind(3)))*v + (z(vind(2)) - z(vind(3)))*w);
         	      	  Do = 2*bk*(x(vind(3))*u + y(vind(3))*v + z(vind(3))*w);
					  % yerel koordinatlarda gelen alan (e2 de depolanır)
		              e1 = T1*e0.';          
				      e2 = T2*e1;
					  % yerel küresel koordinatlarda gelen alan 
		     		  Et2 =  e2(1)*ct2*cp2 + e2(2)*ct2*sp2 - e2(3)*st2;
					  Ep2 = -e2(1)*sp2 + e2(2)*cp2;
    				% yansıma katsayıları (Reflection coefficients) (Rs eta0 a normalize edilir )
		  			if rsmethod==1
                               % yansıma katsayıları
   		           				perp = -1/(2*Rs*ct2 + 1);  	%yerel TE polarization (perpendicular)
					     	    para = 0;                	%yerel TM polarization (parallel)
     						    if ((2*Rs + ct2) ~=0)
                                    para = -ct2/(2*Rs + ct2); 
                                end  
                     end
                     if rsmethod==2
                                perp=RCperp;
                                para=RCpar;
                      end
  	   	    		  % Yerel kartezyen koordinatlarda yüzey akımları
					  Jx2 = (-Et2*cp2*para + Ep2*sp2*perp*ct2);   
    				  Jy2 = (-Et2*sp2*para - Ep2*cp2*perp*ct2);   
					  % (Moreira & Prata, 1994)'den Ic akım hesabı
					  DD = Dq - Dp;
					  expDo = exp(j*Do);
					  expDp = exp(j*Dp);
					  expDq = exp(j*Dq);
					  % Durum 1
   	  	       		  if abs(Dp) < Lt & abs(Dq) >= Lt
      	   				sic=0.;
         				for n = 0:Nt % n= 0'dan Nt ye kadar
		      	    			sic = sic + (j*Dp)^n/fact(n)*(-Co/(n+1)+expDq*(Co*G(n,-Dq)));
         				end
         				Ic=sic*2*Area*expDo/j/Dq;
						% Durum 2
		     		  elseif abs(Dp) < Lt & abs(Dq) < Lt
	   	      			sic = 0.;
         				for n = 0:Nt
          					for nn = 0:Nt
           						sic = sic+(j*Dp)^n*(j*Dq)^nn/fact(nn+n+2)*Co;
          					end
         				end
	         			Ic = sic*2*Area*expDo;
					% Durum 3
    				elseif abs(Dp) >= Lt & abs(Dq) < Lt
       					sic = 0.;
       					for n = 0:Nt
       						sic = sic+(j*Dq)^n/fact(n)*Co*G(n+1,-Dp)/(n+1);
       					end
       					Ic = sic*2*Area*expDo*expDp;
					% Durum 4
   					elseif abs(Dp) >= Lt & abs(Dq) >= Lt & abs(DD) < Lt
          				sic = 0.;
      					for n = 0:Nt
         					sic = sic+(j*DD)^n/fact(n)*(-Co*G(n,Dq)+expDq*Co/(n+1));
        				end
	       				Ic = sic*2*Area*expDo/j/Dq;
   	  				else
      	   				Ic = 2*Area*expDo*(expDp*Co/Dp/DD-expDq*Co/Dq/DD-Co/Dp/Dq);
       	    		end   % özel durum testleri sonu
                       
                                                            
                     % Yerel koordinatlarda m sayıda üçgen için saçılan alan bileşenleri
                     Es2(1) = Jx2*Ic; 	 Es2(2) = Jy2*Ic; 	Es2(3) = 0; % Es2(3) z bileşeni
        			 % Global koordinatlara geri dönme ve alanların toplamı
	      			 Es1 =  T2.'*Es2.';
                     Es0 =  T1.'*Es1; % Es0 :global koordinatlarda küresel elektrik alan
                     Ets =  uu*Es0(1) + vv*Es0(2) + ww*Es0(3); 
      				 Eps = -sp*Es0(1) + cp*Es0(2);
                     
                 else
                   Ets =0;
      			   Eps =0;
                   Etd =0;
				   Epd =0;
                 
                   end 

end % MONOSTATİC DURUM
