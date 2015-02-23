function D = extraitDensites( imagette, m, n )
    % Le petit commentaire qui va bien.
    imagette = ~imagette;
    
    [h, l] = size(imagette);
    y = floor(linspace(1, l, m+1));
    x = floor(linspace(1, h, n+1));
    k = (l*h)/(m*n);
    
    D = zeros(m,n);
    
    for i=1:m
        for j=1:n
            % s = sum(sum(imagette(x(i):x(i+1)-1, y(j):y(j+1)-1)));
            % la matrice étant surtout composée de 0 la recherche va 2 fois
            % plus vite que la somme !! (vu avec "Run and Time")
            s = size(find(imagette(x(i):x(i+1)-1, y(j):y(j+1)-1)==1),1);
            D(i,j) = s/k;
        end
    end    
end

