function f = fact(m)

% Bu kod faktöriyel hesaplamak için kullanılır.

	f = 1;
	if m >= 1
		for n = 1:m
			f = f*n;
		end
	end   