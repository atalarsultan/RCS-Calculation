function T21=transfermatrix(a,b)

% Bu kod giriş olarak yüzey dönüş açılarını alır ve iki dönüşüm matrisinin çarpımını hesaplar.

T1=[cos(a) sin(a) 0; -sin(a) cos(a) 0; 0 0 1];
T2=[cos(b) 0 -sin(b); 0 1 0; sin(b) 0 cos(b)];
T21=T2*T1;
