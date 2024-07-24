function CalcRCS;

% Bu dosya seçilen modelin monostatik RKA'sını hesaplamak için kullanılır.

warning("off")
      
global C
global coord modelname symplanes matrl
global facet scale changed
global thetadeg phideg RCSth RCSph
global Ethscat Ephscat

nvert = size(coord,1);
ntria=size(facet,1);

     
     rsmethod=1;
      e0=8.85e-12; %permittivity of free space
      m0=4*pi*1e-7; %permeability of free space
      
     
      txt = ['Computing the monostatic RCS of ',modelname,' model . . .'];          
      hwait=waitbar(0,txt);
      pause(0.1);     
      
      % Parametrelerin belirlenmesi

      tstart = 90;  % tstart: theta start
      tstop  = 90; 
      delt   = 1;    % delt : theta artış miktarı
      pstart = 0;  % pstart: phi start
      pstop  = 360; 
      delp   = 1; 
      freq	 = 35;     % frekans değeri
      Lt     = 1e-5;  % Taylor serisi bölgesinin uzunluğu (sabit)
      Nt     = 5; % terim sayısı (sabit)
      

      % i_pol  = 1;     
      %    Et = 1;
      %    Ep = 0;% gelen polarizasyonun değeri   

      Et = 1+j*0; %theta polarizasyonlu dalga
      Ep = 0+j*0;
 
      C = 3*10^8;     
      wave   = C/(freq * 10^9);
      bk     = 2*pi/wave;
      rad 	 = pi/180;    

	  if tstart == tstop, thr0 = tstart*rad; end  % arayüzdeki theta ve phi değerleri
      if pstart == pstop, phr0 = pstart*rad; end
	  it = floor((tstop-tstart)/delt) + 1;  
   	  ip = floor((pstop-pstart)/delp) + 1;
      

	  Co = 1;      % Co: bütün köşelerdeki dalga genliği
  
      xpts = coord(:,1);  % her bir köşenin x, y ve z bileşenlerini içeren ayrı vektörler.... 
      ypts = coord(:,2);  % (xpts, ypts, zpts) oluşturur ve nesnenin 3B geometrisini tanımlar.
      zpts = coord(:,3);
      % Satırlardaki her sütun, üçgenin bir köşesini oluşturan coord dizisindeki bir köşenin indeksini belirtir.
      node1 = facet(:,1); % üçgenin ilk düğümü
      node2 = facet(:,2); % üçgenin ikinci düğümü
      node3 = facet(:,3); % üçgenin üçüncü düğümü
      % sağ el kuralına ve saat yönünün tersine köşe sırasına göre üçgenin dış yüzeyi aydınlanmış mı
      ilum  = facet(:,4);	
      Rs    = facet(:,5); % her bir üçgenin yüzey direnci
      
      iflag = 0;
      for i = 1:ntria 
			pts = [node1(i) node2(i) node3(i)];
		  	vind(i,:) = pts;       
	  end
      x = xpts; y = ypts;  z = zpts;
      % Köşelere konum vektörlerini tanımlama
	  for i = 1:nvert
			r(i,:) = [x(i) y(i) z(i)]; % coord'daki köşe konumu bilgilerini r matrisine kopyalar
	  end   
      % Kenar çapraz çarpımlarından kenar vektörlerini ve normalleri bulma
	  for i = 1:ntria
         % A, B, C kenar vektörleri
   		A = r(vind(i,2),:) - r(vind(i,1),:);
	   	B = r(vind(i,3),:) - r(vind(i,2),:);
		C = r(vind(i,1),:) - r(vind(i,3),:);
        % kenar vektörlerinden dışarı yönlü normal vektörünü hesaplama
        N(i,:) = - cross(B,A);
		% "i" üçgeni için kenar uzunlukları
   		d(i,1) = norm(A);
   		d(i,2) = norm(B);
		d(i,3) = norm(C);
   		s = .5*sum(d(i,:)); % üçgenin kenar uzunlukları toplamının yarısı
	   	Area(i) = sqrt(s*(s-d(i,1))*(s-d(i,2))*(s-d(i,3))); % Heron formülü kullanılarak i üçgeninin alanını hesaplar 
	   	Nn = norm(N(i,:)); % Normal vektör N(i,:)'nin büyüklüğünü (Nn) hesaplar. 
        N(i,:) = N(i,:)/Nn; % birim normalini bulma
        % döndürme açıları
        beta(i) = acos(N(i,3));  % normal vektörünün küresel açılarını (teta ve phi) hesaplar.
        alpha(i) = atan2(N(i,2),N(i,1));
	end
    
   
   	for i1 = 1:ip       % ip phi
   		for i2 = 1:it   %i theta
                waitbar(((i1-1)*it+i2)/(ip*it)); % RKA hesaplamasının ilerleme durumunu gösterme
                
                alreadycomputed=0;
				phi(i1,i2) = pstart + (i1-1)*delp;
				theta(i1,i2) = tstart + (i2-1)*delt;
                %phi ve teta değerlerini dereceden radyana dönüştürme
                phr = phi(i1,i2)*rad;
                thr = theta(i1,i2)*rad;
                %küresel açılar ve yön kosinüsleri
                st = sin(thr); ct = cos(thr);
   	            cp = cos(phr);	sp = sin(phr);
				u = st*cp; 	v = st*sp; 	w = ct ;            
                D0=[u v w];
                U(i1,i2) = u; 	V(i1,i2) = v;	 W(i1,i2) = w;     
	
                 
	if alreadycomputed==0		
                % Kartezyen koordinatları küresele dönüştürme. 
			    uu = ct*cp; vv = ct*sp; 	ww = -st;
                % Küresel koordinat sisteminde dışa doğru radyal birim vektör
				R = [u v w];
				% Global kartezyen koordinat sisteminde gelen alan 
				e0(1) = uu*Et - sp*Ep;    %x
				e0(2) = vv*Et + cp*Ep;    %y
				e0(3) = ww*Et;            %z
                 
				sumt = 0;
                sump = 0;
                sumdt = 0;
                sumdp = 0;
                              
                % rsmethod=1 olduğunda yansıma katsayısı için verilen değerler                 
                RCpar=0;
                RCperp=0;
	     		for m = 1:ntria  %teta ve phi açılarının mevcut kombinasyonu için her üçgenin toplam RKA'ya katkısını hesaplar.
                    
                    if rsmethod==2
                        [RCpar,RCperp]=RClayers(thr,phr,m,alpha(m),beta(m),freq*1e9); 
                        %  m: Geçerli üçgenin indeksi.
                        % alpha(m) ve beta(m): Üçgenin normal vektörünün küresel açıları (teta ve phi).
                    end
                    
                       Einc=e0;
                       [Ets, Etd, Eps, Epd]=facetRCS(thr,phr,thr,phr,N(m,:),ilum(m),iflag,alpha(m),beta(m),Rs(m),Area(m),x,y,z,vind(m,:),Einc,Nt,Lt,wave,rsmethod,RCpar,RCperp);
                       % Toplam alanı elde edebilmek için bütün üçgenlerin katkıları toplanır.
                       sumt = sumt + Ets;  % sumt teğetsel (Ets) saçılan elektrik alan bileşenini toplar.
   	    			   sump = sump + Eps;  % sump dik (Eps) saçılan elektrik alan bileşenini toplar.
                       sumdt = sumdt + abs(Etd); %  sumdt teğetsel (Etd) saçılan elektrik alan bileşeninin mutlak değerini toplar
                       sumdp = sumdp + abs(Epd);  % sumdp dik (Epd)  elektrik alan bileşeninin mutlak değerlerini toplar
                      
                end      
            
            Ethscat(i1,i2)=sumt;
            Ephscat(i1,i2)=sump;
            cfac1=1;
            % sth ve sph: scattered theta ve phi (dB)
            Sth(i1,i2) = 10*log10(4*pi*cfac1*(abs(sumt)^2+sqrt(1-cfac1^2)*sumdt)/wave^2+1e-10);
            Sph(i1,i2) = 10*log10(4*pi*cfac1*(abs(sump)^2+sqrt(1-cfac1^2)*sumdp)/wave^2+1e-10);
            else 
                Sth(i1,i2)=Sth(indexfound);
                Sph(i1,i2)=Sph(indexfound);
            end 
	   end	
   	end	
    
    close(hwait);
    
    RCSth=Sth;
    RCSph=Sph;
    thetadeg=theta;
    phideg=phi;

    % arkaplanı temizleme
monostatic_App, 'reuse'; gca ; axis off, title ' ';

answer=questdlg('Save RCS Results?','Save to File','Mat File','Text File','No','Mat File');
switch answer
   case 'Mat File'
      [filename, pathname]=uiputfile('*.mat','Select file name','MResults');
      if filename~=0
          save([pathname,filename],'theta','phi','freq','Sth','Sph','Ethscat','Ephscat');
      end  
      
  case 'Text File'
      [filename, pathname]=uiputfile('*.m','Select file name','MResults.m');
      Reth=real(Ethscat);
      Ieth=imag(Ethscat);
      Reph=real(Ephscat);
      Ieph=imag(Ephscat);
      if filename~=0
          save([pathname,filename],'theta','phi','freq','Sth','Sph','-ASCII');
      end              
end
