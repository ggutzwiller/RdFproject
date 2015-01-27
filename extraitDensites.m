function D = extraitDensites( imagette, m, n )
    % Le petit commentaire qui va bien.
    imagette = imagette/255;
    imagette = ~imagette;
    
    [h, l] = size(imagette);
    y = linspace(1, l, m+1)
    x = linspace(1, h, n+1)
    k = (l*h)/(m*n)
    
    for i=1:m
        for j=1:n
            s = sum(sum(imagette(int64(x(i)):int64(x(i+1))-1, int64(y(j)):int64(y(j+1))-1)));
            D(i,j) = s/k;
        end
    end    
end

