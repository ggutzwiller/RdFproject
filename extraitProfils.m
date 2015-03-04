function profil = extraitProfils( imagette, n )
    % Ici un joli commentaire
    [h, l] = size(imagette);
    y = floor(linspace(h/n, h-h/n, n));

    profil = zeros(2*n,1);
    
    for i=1:n
        profil(i) = find(imagette(y(i),:) == 0, 1);
        profil(i+n) = find(imagette(y(i),:) == 0, 1, 'last');
    end
    profil = profil/l;
end
