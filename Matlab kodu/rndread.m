function [fout, vout, cout] = rndread(fileloc)
% CAD programları tarafından oluşturulan STL ASCII dosyalarını okuma ve
% CAD 3D verilerinin MATLAB patch'lerini oluşturmak için kullanılır.
% Vertex ve face listelerini MATLAB patch kodu için dönüştüme işlemleri.

fid=fopen(fileloc, 'r'); %STL ASCII formatlı dosyayı okuma.  
if fid == -1 
    error('File could not be opened, check name or path.')
end
%
CAD_object_name = sscanf(fgetl(fid), '%*s %s');  %Gerekiyorsa CAD model ismi
%                                                %Bazı STL dosyaları var, bazıları yok.   
vnum=0;       %Vertex number counter.
report_num=0; %Durumu rapor etme
VColor = 0;
%
while feof(fid) == 0                    % dosyanın sonunu test etme.
    tline = fgetl(fid);                 % dosyadan gelen veri çizgilerini okuma
    fword = sscanf(tline, '%s ');       % bir character string çizgisi oluşturma
% Check for color
    if strncmpi(fword, 'c',1) == 1;    % "C" 1'inci karakter olduğunda "C"olor line olup olmadığı kontrolü.
       VColor = sscanf(tline, '%*s %f %f %f'); % Bu satır, sonraki üç sayıyı satırdan çıkarır (ilk kelimeyi atlayarak) ve bunları VColor değişkeninde saklar. Bu sayılar rengin kırmızı, yeşil ve mavi bileşenlerini temsil eder.
    end                                % Sıradaki renk kullanılana kadar bu rengi tut.
    if strncmpi(fword, 'v',1) == 1;    % "V" 1'inci karakter olduğunda "V"ertex line olup olmadığı kontrolü.
       vnum = vnum + 1;                % Şimdiye kadar karşılaşılan köşe sayısını takip etmek için bir sayacı (vnum) artırır.
       report_num = report_num + 1;    % Dosyaların durumu göstermesi için bir sayaç bildirir.
       if report_num > 249;
           disp(sprintf('Reading vertex number: %d.',vnum));
           report_num = 0;
       end
       v(:,vnum) = sscanf(tline, '%*s %f %f %f'); % & eğer V ise onun XYZ datalarını getir.
       c(:,vnum) = VColor;              % Her köşe için yüzeyleri renklendirecek bir renk.
    end                                 % "*s" ile "renk" adını atlayıp veriyi alıyoruz.                                         
end
disp('Rendering drawing...')
%   Yüzey listesi oluşturun; Köşeler sıralıdır, bu yüzden onları numaralandırın.
%
fnum = vnum/3;      %Yüzey sayısını bulma. (vnum köşe sayısı)
flist = 1:vnum;     %flist, nesnenin yüzeylerindeki köşelerin sırasını listeler.
F = reshape(flist, 3,fnum); %flist vektörünü üç satır ve fnum sütunlu bir matris (F) halinde yeniden şekillendirir.
%
% 
%
fout = F';  %üç sütunlu ve fnum satırlı bir 'fout' matrisi elde etmek için F matrisinin transpozunu alır.Diziyi patch'de direk kullanılabilmek için.
vout = v';  % "
cout = c';
%
fclose(fid);

