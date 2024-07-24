function modelview(action) 
% Bu dosya, model geometrisinin kullanıcı görüşünü geliştirmek için MODELSHOW GUI'nin işlevlerini uygular.

global nvert coord scale symplanes comments matrl
global ntria facet modelname changed

switch(action)
      
   case 'Save'
      [filename, pathname]=uiputfile('*.mat','Select file name',modelname);
      if filename~=0
          save([pathname,filename],'coord','facet','scale','symplanes','comments','matrl');
           modelname=filename(1:length(filename)-4);
           modelname=replace(modelname,'_','-');
           changed=0;
      end  
   
  case 'Close'
    if changed==1
      a=questdlg('The model was changed. Do you want to save the changes?','Save Model?','Yes','No','Yes');
      switch a
        case 'Yes'
          modelview('Save');
      end
    end
    close(gcf); 
    global monostaticApp;
    monostaticApp.focus;
end 
