% STL'den PET (points, edges triangles output)'e dönüştürme
% PET formatı MATLAB pdetool tarafından rndread(...) kullanılarak oluşturulur.

[filename, pathname]=uigetfile('*.stl','Select STL model');
fileloc=[pathname, filename];
if filename~=0
% CAD dosyasını okuma
[F, V, C] = rndread(fileloc); %F:faces, V:vertices, C:Colors
figure(2) % 2 rakamı ile bir figür penceresi oluşturur.
clf; %Geçerli figür penceresini temizler.
  P = patch('faces', F, 'vertices' ,V);
  set(P, 'facec', 'flat');            % yüzey rengini "flat" olarak ayarlar. (her yüzeyin tek bir renk kullanması anlamına gelir)
  set(P, 'FaceVertexCData', C);       % dosyadan rengi set eder
  set(P, 'EdgeColor','none');         % nesnenin kenar renklerini kaldırır
  light                               % görselleştirmeyi iyileştirmek için varsayılan bir ışık kaynağı ekler
  daspect([1 1 1])                    % tüm eksenlerde eşit ölçeklendirme için en boy oranını 1:1:1 olarak ayarlar.
  view(3)                           
  xlabel('X'),ylabel('Y'),zlabel('Z')
  title('Imported STL model')
  drawnow                             
  disp(['CAD file ' fileloc ' data is read'])
  [N,M]=size(F');
  t=[F'; ones(1,M)];
  p=V';
  e=p; 
% değişkenleri dosyaya kaydetme
  [FILENAME, PATHNAME, FILTERINDEX] = uiputfile('*.mat','Input name of file to save data');
  if FILENAME~=0
    save([PATHNAME FILENAME],'p','e','t');
  end
   close(2)
end
    

