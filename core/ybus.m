function Y = ybus(d)
%YBUS  9x9 bara admitans matrisi (hatlar pi eşdeğeri, trafolar seri reaktans).
Y = zeros(9);
for k = 1:size(d.lines,1)
    i = d.lines(k,1); j = d.lines(k,2);
    y = 1/complex(d.lines(k,3), d.lines(k,4)); b = d.lines(k,5);
    Y(i,i) = Y(i,i) + y + 1i*b/2;  Y(j,j) = Y(j,j) + y + 1i*b/2;
    Y(i,j) = Y(i,j) - y;           Y(j,i) = Y(j,i) - y;
end
for k = 1:size(d.trafos,1)
    i = d.trafos(k,1); j = d.trafos(k,2); y = 1/(1i*d.trafos(k,3));
    Y(i,i) = Y(i,i) + y;  Y(j,j) = Y(j,j) + y;
    Y(i,j) = Y(i,j) - y;  Y(j,i) = Y(j,i) - y;
end
end
