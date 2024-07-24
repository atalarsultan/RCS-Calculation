function planewave(action)

% Bu kod Monostatik RKA GUI Hesaplama işlevlerini uygular ve seçilen bir modelin monostatik RKA'sını hesaplar.
 
global C
global coord nvert modelname symplanes matrl comments
global ntria facet scale changed

C = 3*10^8;	% ışık hızı m/s

switch(action);

case 'LoadFile'  
 

      model('OpenFile',gcbo,[],guidata(gcbo));
      uiwait;
      txt=['Calculation of Monostatic RCS for the ',modelname,' model'];
      set(findobj(gcf,'Tag','figtitle'),'String',txt);    
      set(findobj(gcf,'Tag','Calculate'),'Enable','on');    
      set(findobj(gcf,'Tag','groundplane'),'Enable','on'); 
      coord=coord*scale;  % yeniden ölçeklendirme
      scale=1;    % koordinatlar değiştiğine göre ölçek faktörünü 1'e eşitleyin
    
      case 'PEC'    
          pec=get(findobj(gcf,'Tag','checkpec'),'Value');
          if pec==0
              set(findobj(gcf,'Tag','relativeperm'),'Enable','on');
              set(findobj(gcf,'Tag','relpermtext'),'Enable','on');
          else
              set(findobj(gcf,'Tag','relativeperm'),'Enable','off');
              set(findobj(gcf,'Tag','relpermtext'),'Enable','off');
          end
          
          
   case 'Calculate'
      CalcRCS;
                
   case 'Close' 
      close(gcf);
      global mainApp;
      mainApp.focus;
 end 
   