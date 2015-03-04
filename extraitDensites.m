function D = extraitDensites( imagette, m, n )
    % Le petit commentaire qui va bien.
    imagette = ~imagette;

    [h, l] = size(imagette);
    x = floor(linspace(1, h, m+1));
    y = floor(linspace(1, l, n+1));

    D = zeros(m*n,1);

    for i=1:m
        for j=1:n
            % s = sum(sum(imagette(x(i):x(i+1)-1, y(j):y(j+1)-1)));
            % la matrice �tant surtout compos�e de 0 la recherche va 2 fois
            % plus vite que la somme !! (vu avec "Run and Time")
            s = size(find(imagette(x(i):x(i+1)-1, y(j):y(j+1)-1)==1),1);
            D((i-1)*n+j) = s/((x(i+1)-x(i))*(y(j+1)-y(j)));
        end
    end
end
