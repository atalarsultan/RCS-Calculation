% Bu kod, MATLAB'da 3B bir modelin .mat dosyasını açıp temizleyerek, sıfır alanlı yüzeyleri ve 
% yinelenen köşeleri kaldırarak sıkıştırılmış bir versiyonunu kaydeder.

clear
[filename, pathname]=uigetfile('*.mat','Select model'); % Seçilen dosya adını ve yolunu "filename" ve "pathname" değişkenlerinde saklar.
if filename~=0 % dosya seçildi mi?
      load([pathname,filename],'coord','facet','scale','symplanes','comments','matrl') % .mat dosyasını yüklemek için kullanılır.
      L=size(facet); nfaces=L(1); % facet verisinin boyutunu alır ve üçgen sayısını (nfaces) bir değişkene atar.
      P=size(coord); nverts=P(1); % koordinat verilerinin boyutunu alır ve köşe sayısını (nverts) bir değişkene atar.
      disp(['cleaning and compressing ',filename])
      disp(['number of vertices read: ',num2str(nverts)])
      disp(['number of faces read ',num2str(nfaces)])
      h=waitbar(0,'Searching zero area facets ...');
      pause(0.1);      
  ifct=0;
  n1=facet(:,1); n2=facet(:,2); n3=facet(:,3); % üçgen yüzey verilerinden her bir yüzey için köşe indislerini çıkarır.
  del=1e-6; % Bu değer, bir yüzeyin hesaplanan alanının sıfır alanlı bir yüzey olarak kabul edilebilecek kadar sıfıra yakın olup olmadığını belirleme.
  vind=coord;
    for i=1:nfaces % modeldeki tüm yüzeyler (nfaces) üzerinde yineleme yapan bir döngü başlatır.
        x1=coord(n1(i),1); y1=coord(n1(i),2); z1=coord(n1(i),3);
        x2=coord(n2(i),1); y2=coord(n2(i),2); z2=coord(n2(i),3);
        x3=coord(n3(i),1); y3=coord(n3(i),2); z3=coord(n3(i),3);
        % köşe koordinatlarından mevcut yüzeyin kenar uzunluklarını (L1,L2,L3) hesaplama.
        L1=sqrt((x1-x2)^2+(y1-y2)^2+(z1-z2)^2);
        L2=sqrt((x3-x2)^2+(y3-y2)^2+(z3-z2)^2);
        L3=sqrt((x1-x3)^2+(y1-y3)^2+(z1-z3)^2);
        if L1>del & L2>del & L3>del % (L1, L2, L3)'ün tolerans değerinden (del) büyük olup olmadığını kontrol etme. 
            ifct=ifct+1; % sıfır olmayan alanla tanımlanan yüzeylerin sayısı için sayacı (ifct) artırır.
            newfacet(ifct,1:5)=facet(i,1:5); % facet'teki her satırın ilk beş öğesini kopyalayarak newfacet'ta depolama.
       % Tüm kenarların sıfır olmayan bir uzunluğa sahip olması, yüzeyin sıfır olmayan bir alana sahip olduğu anlamına gelir.
        end
    end 
    close(h);    
    % Kaç adet yüzeyin sıfır alan olarak tanımlandığını bulma.
disp(['number of facets with zero area removed: ',num2str(nfaces-ifct)]) % Başlangıçtaki yüzey sayısı (nfaces) ile geçerli yüzeyler sayacı (ifct) arasındaki farkı hesaplama.

idup=0;
  for i=1:nverts
      for n=i+1:nverts
     % İki köşenin (i ve n) karşılık gelen koordinatları (x, y ve z) arasındaki mutlak farkların tümünün tolerans değerinden (del) 
     % küçük olup olmadığını kontrol etme
          if abs(coord(i,1)-coord(n,1))<del & abs(coord(i,2)-coord(n,2))<del & abs(coord(i,1)-coord(n,2))<del
              idup=idup+1; 
              dn(idup,1)=i; dn(idup,2)=n;
          end
      end
  end
disp(['number of duplicate nodes found (not removed): ',num2str(idup)]) % Yinelenen köşelerin (idup) sayısını gösterir.
disp(['final number of vertices saved: ',num2str(nverts)]) % modelde depolanan son köşe sayısını (nverts) gösterir.
disp(['final number of facets saved: ',num2str(ifct)]) % sıfır alanlı yüzeyler çıkarıldıktan sonra tutulan son yüzey sayısını (ifct) gösterir. 

facet=newfacet; % orijinal yüzey (facet) verilerini newfacet (sıfır olmayan alana sahip olanlar) içeriği ile değiştirir. 
      [filename pathname]=uiputfile('*.mat','Name of compressed file'); % Sıkıştırılmış modeli kaydetmek için diyalog penceresi açma.
      if filename~=0 % Kullanıcı bir dosya adı seçmiş mi?
        save([pathname, filename],'coord','facet','scale','symplanes','comments','matrl'); %değişkenleri .mat dosyasına kaydetme.
      end      
 end 
 