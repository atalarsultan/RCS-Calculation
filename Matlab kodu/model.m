function varargout = model(varargin)

% Bu dosya modeli açmaya yarar.

if nargin == 0  % GUI'yi başlatma % fonksiyonun herhangi bir argüman olmadan çağrılıp çağrılmadığını kontrol eder

	fig = openfig(mfilename,'reuse'); % 'reuse': zaten figure açıksa yeniden oluşturulmamasını sağlar.

	handles = guihandles(fig); % figure içindeki tüm kullanıcı arayüzü öğelerinin (düğmeler, düzenleme kutuları, vb.) handle'ları alır ve bunları handles adlı bir yapıda saklar.
	guidata(fig, handles); % handles yapısını guidata fonksiyonunu kullanarak şeklin kullanıcı verisi içinde saklar. 

	if nargout > 0 % nargout, istenen çıktı argümanlarının sayısını kontrol eder
		varargout{1} = fig; % açılan figürü varargout çıktı argümanı listesinin ilk öğesine atar.
	end

elseif ischar(varargin{1}) % ilk girdi bağımsız değişkeninin (varargin{1}) bir dize olduğu durumları ele alır. 

	try
		[varargout{1:nargout}] = feval(varargin{:}); 
	catch
		disp(lasterr); % Bu satır sadece try bloğu içinde karşılaşılan son hata mesajını görüntüler.
	end

end

% --------------------------------------------------------------------
function varargout = close_Callback(h, eventdata, handles, varargin)

close(gcf); % Mevcut şekil penceresini kapatır   
     
nvert=size(coord,1); % coord verisinin ilk satırını bularak modeldeki köşe sayısını (nvert) alır.
valid=0; %  Valid değişkeni çift köşelerin bulunup bulunmadığını belirtmek için bir bayrak olarak kullanılacaktır.
for i = 1:(nvert-1) % bir çiftteki ilk köşe olarak tüm köşeleri (i) yineler.
      for j = (i+1):nvert % bir çiftteki ikinci köşe olarak i+1'den başlayarak kalan köşeleri (j) yineler. 
               if coord(i,:) == coord(j,:) % iki köşenin (i ve j) karşılık gelen tüm koordinatlarını (x, y ve z) karşılaştırır.
                    close(gcf);
            		errordlg('Duplicate vertex coordinates!', 'Coordinate Status', 'error'); % yinelenen köşe koordinatlarının bildirir.
                  valid = 1; % en az bir yinelenen köşe çifti tespit edildiğini belirtmek için valid bayrağını 1 olarak ayarlar.         
                  break;
               end % if
      end % for
      if valid == 1
               break;
      end            
end 

global ntria facet modelname comments matrl

hobj=gcf;     
ntria=size(facet,1);

function Scale_Callback(hObject, eventdata, handles)

global scale
scale = str2num(get(findobj(gcf,'Tag','Scale'),'String'));


% menüde OpenFile seçildiğinde yürütülür
function OpenFile(hObject, eventdata, handles)

global coord nvert modelname symplanes comments matrl
global ntria facet scale

[filename, pathname]=uigetfile('*.mat','Select model');
if filename~=0
      load([pathname,filename],'coord','facet','scale','symplanes','comments','matrl')
      modelname=filename(1:length(filename)-4);
      modelname=replace(modelname,'_','-');
     set(findobj(gcf,'Tag','Save'),'Enable','on'); 
   hobj=gcf;

    
    modelshow_App
    PlotModel;

end
