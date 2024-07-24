function Plotmodel
 
% Bu dosya bir modeli çizdirmek için kullanılır. 

global coord nvert modelname
global ntria facet scale symplanes

reset(gca);
% köşe ve üçgenlerin sayısı
nvert=size(coord,1);
ntria=size(facet,1);
%bütün köşelerin koordinatları
xpts = coord(:,1)*scale;
ypts = coord(:,2)*scale;
zpts = coord(:,3)*scale;
% bütün üçgenlerin düğümleri
node1 = facet(:,1); 	
node2 = facet(:,2); 
node3 = facet(:,3);
% Yüzey direnci ve aydınlanma durumu
ilum  = facet(:,4);
Rs	= facet(:,5);
% her bir köşe noktasının düğümünü vind dizisine depolar
for i  = 1:ntria 
			pts = [node1(i) node2(i) node3(i)];
			vind(i,:) = pts;       
end
x = xpts; 	y = ypts; 	z = zpts;
% X, Y ve dizilerini belirleme ve çizdirme
      for i = 1:ntria
         X = [x(vind(i,1)) x(vind(i,2)) x(vind(i,3)) x(vind(i,1))];
    	 Y = [y(vind(i,1)) y(vind(i,2)) y(vind(i,3)) y(vind(i,1))];
	     Z = [z(vind(i,1)) z(vind(i,2)) z(vind(i,3)) z(vind(i,1))];
         plot3(X,Y,Z,'b')
		 if i == 1
     			hold on
         end
      end      
      axis square   
      title([modelname,' Dosyasının Üçgen Modeli']);
	  xlabel('x');  ylabel('y');    zlabel('z');

      xmax = max(xpts); xmin = min(xpts);
      ymax = max(ypts); ymin = min(ypts);
      zmax = max(zpts); zmin = min(zpts);
      dmax = max([xmax ymax zmax]); 
      dmin = min([xmin ymin zmin]);
	  xmax = dmax; 	ymax = dmax; 	zmax = dmax;
      xmin = dmin; 	ymin = dmin; 	zmin = dmin;
      bufx=.2*(xmax-xmin);
      bufy=.2*(ymax-ymin);
      bufz=.2*(zmax-zmin);
      axis([xmin-bufx, xmax+bufx, ymin-bufy, ymax+bufy, zmin-bufz, zmax+bufz]*1.1); 

    
