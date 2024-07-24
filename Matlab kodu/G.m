function g = G(n,w)

% Bu dosya G fonksiyonunu hesaplar.


	jw = j*w;
   g = (exp(jw) - 1)/jw;
  	if n > 0 % formülde n>=1
  		for m = 1:n
   		go = g; 
    		g = (exp(jw) - n*go)/jw; %g değerini günceller.
   	end
  	end
