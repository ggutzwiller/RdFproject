function profil = extraitProfils( imagette, n )
    % On récupère les dimension pour définir ensuite où chercher (y)
    [h, l] = size(imagette);
    y = floor(linspace(h/n, h-h/n, n));

    profil = zeros(2*n,1);
    
    for i=1:n
        % On cherche le premier 1 à gauche, bord gauche du chiffre
        profil(i) = find(imagette(y(i),:) == 0, 1);
        % On cherche le dernier 1 à droite, bord droit du chiffre
        profil(i+n) = find(imagette(y(i),:) == 0, 1, 'last');
    end
    profil = profil/l;
end
