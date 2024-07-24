function varargout = utilities(varargin)  

% Bu kod CAD programlarında tasarlanan ve stereo-litografik formatta (*.stl) 
% kaydedilen modellerin içe aktarılmasına ve pdetool ile tasarlanan modellerin dışa aktarılmasına olanak sağlar.

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @utilities_OpeningFcn, ...
                   'gui_OutputFcn',  @utilities_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function utilities_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

guidata(hObject, handles);

function varargout = utilities_OutputFcn(hObject, eventdata, handles)

varargout{1} = handles.output;

% ImportACAD butonuna basıldığında çalışır.
% STL import fonksiyonu Matlab Central (www.mathworks.com)'dan alınmıştır.
function ImportSTL_Callback(hObject, eventdata, handles)

[filename, pathname]=uigetfile('*.stl','Select Stereo-Lithographic model');
fid=fopen([pathname,filename]);
if filename~=0

 % CAD dosyasını okuma
 modelname=fgetl(fid);
 modelname=replace(modelname,'_','-');
 disp(['Importing STL model name: ',modelname])
 disp('Working...')
 lnn=0;
 fct=0;
 nv=0;
 nod=0;
 ntri=1;
 scale=1;
 while ~feof(fid)
            sin=fgetl(fid);
            lnn=lnn+1;
            S=strfind(sin,'vertex');
            K=strrep(sin,'vertex',' ');  % yalnızca sayıları bırakarak dizilerden kurtulma
            if S>0
                nv=nv+1;     % bütün düğümleri sayma
                nod=nod+1;   % bir üçgendeki düğümleri sayma
                B=sscanf(K,'%f');  % strigten sayıları çıkarma
                A(nv,:)=B;
                x(ntri,nod)=B(1);
                y(ntri,nod)=B(2);
                z(ntri,nod)=B(3);
                Nv(ntri,nod)=nv;     % n'inci üçgenin (ntri) düğüm indisleri
            end
            if nod==3, nod=0; ntri=ntri+1; end
 end
 fclose(fid);

% yinelenen (dublicate) düğümleri kaldırma  
 [V, indexm, indexn] =  unique(A, 'rows');
 F = indexn(Nv);
 disp(['CAD file ' filename ' data is read'])
  facet=F;
  coord=V;
% Yüzey aydınlanma, yüzey direnci vs ekleme
  facet(:,4)=1;
  facet(:,5)=0;
  scale=1;
  symplanes=[0,0,0];
  for i=1:size(facet,1)
    comments{i,1}='Model Surface';
    matrl{i,1}='PEC';
    matrl{i,2}=[0 0 0 0 0];
  end
%köşe ve yüzeylerin boyutları
nvert=size(coord,1);
ntria=size(facet,1);
%bütün köşelerin koordinatları
xpts = coord(:,1)*scale;
ypts = coord(:,2)*scale;
zpts = coord(:,3)*scale;
%bütün yüzeylerin düğümleri
node1 = facet(:,1); 	
node2 = facet(:,2); 
node3 = facet(:,3);
%vind dizisine her bir düğümü kaydetme
for i  = 1:ntria 
			pts = [node1(i) node2(i) node3(i)];
			vind(i,:) = pts;       
end
iplt=input('Do you want to plot the object (y/n)? ','s');
if iplt=='y' | iplt=='Y'
    figure(2)
    clf;
    xlabel('X'),ylabel('Y'),zlabel('Z')
    x = xpts; 	y = ypts; 	z = zpts;
    % X,Y,Z dizilerini tanımlama ve çizdirme 
      for i = 1:ntria
         X = [x(vind(i,1)) x(vind(i,2)) x(vind(i,3)) x(vind(i,1))];
    	 Y = [y(vind(i,1)) y(vind(i,2)) y(vind(i,3)) y(vind(i,1))];
	     Z = [z(vind(i,1)) z(vind(i,2)) z(vind(i,3)) z(vind(i,1))];
         plot3(X,Y,Z,'b')
		 if i == 1
     			hold on
         end
      end      
      axis equal   
      title([modelname,' dosyasının üçgensel modeli']);
	  xlabel('x');  ylabel('y');    zlabel('z');
end
  %koordinat, yüzey ve ölçeği (scale) dosyaya kaydetme
  [FILENAME, PATHNAME, FILTERINDEX] = uiputfile('*.mat','Input name of file to save data');
  if FILENAME~=0
    save([PATHNAME FILENAME],'coord','facet','scale','symplanes','comments','matrl');
  end
end

% Export STL
function ExportSTL_Callback(hObject, eventdata, handles)

[filename, pathname]=uigetfile('*.mat','Select model to export stl');
if filename~=0
    load([pathname,filename],'coord','facet','scale','symplanes','comments','matrl');
    faces=facet(:,1:3);
    [filename, pathname]=uiputfile('*.stl','Select output stl file name');
    modelname=filename(1:length(filename)-4); 
    modelname=replace(modelname,'_','-');
    STL_Export(coord,faces,filename,modelname);    % modelin adını katı modelin adı olarak kullanma

end 

function STL_Export(nodes_file, triangles_file, STL_file_name, solid);
% Bu fonksiyon, Üçgen yüzeye sahip bir model dosyasını ASCII STL dosyasına
% export etmek için kullanılır.
[node_num,dum]=size(nodes_file);
[triangle_num,dum]=size(triangles_file);
%yüzey verilerinin boyutunu yazdırma
fprintf (1,'\n');
fprintf (1,'  TRI_SURFACE data:\n');
fprintf (1,'  Number of nodes     = %d\n',node_num);
fprintf (1,'  Number of triangles = %d\n',triangle_num);
ercc=0;
if triangle_num<4, disp('model must have at least 4 triangles'); 
    ercc=1; 
end

if ercc==0;
%loop yapmadan normal vektörleri hesaplama 
%point_one matrisi, point_triangles'ın her satırındaki ilk (satır) öğeyi içerir. Bunlar, her üçgendeki ilk 
% köşe (vertex) noktasının X, Y ve Z koordinatlarını temsil eder.
points_triangles=[nodes_file(triangles_file,1),nodes_file(triangles_file,2),nodes_file(triangles_file,3)]; %node_file ve triangles_file olmak üzere iki matrisin öğelerini birleştirir
points_one=points_triangles(1:length(points_triangles)/3,:);
points_two=points_triangles(length(points_triangles)/3+1:length(points_triangles)/3*2,:);
points_three=points_triangles(length(points_triangles)/3*2+1:length(points_triangles),:);
vectors_one=points_two-points_one;
vectors_two=points_three-points_one;
normal_vectors=cross(vectors_one,vectors_two);
norms=repmat(sqrt(sum(normal_vectors.^2,2)),[1,3]);
normalized_normal_vectors=normal_vectors./norms;
%output matrix oluşturma
output=zeros(length(points_one)*4,3);
for i=1:length(points_one)
    output(i*4-3,:)=normalized_normal_vectors(i,:);
    output(i*4-2,:)=points_one(i,:);
    output(i*4-1,:)=points_two(i,:);
    output(i*4,:)=points_three(i,:);
end
output=output';
%STL dosyası yazma 
STL_file = fopen (STL_file_name,'wt');
if (STL_file < 0)
    fprintf (1,'\n');
    fprintf (1,'Could not open the file "%s".\n',STL_file_name);
    error ('STL_WRITE - Fatal error!');
end
fprintf (STL_file,'solid %s\n',solid);
fprintf (STL_file, '  facet normal  %14e  %14e  %14e\n    outer loop\n      vertex %14e %14e %14e\n      vertex %14e %14e %14e\n      vertex %14e %14e %14e\n    endloop\n  endfacet\n',output);  
fprintf (STL_file,'endsolid %s\n',solid );
fclose (STL_file);
end
