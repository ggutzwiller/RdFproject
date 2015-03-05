function profil = extraitProfils( imagette, n )
    % On r�cup�re les dimension pour d�finir ensuite o� chercher (y)
    [h, l] = size(imagette);
    y = floor(linspace(h/n, h-h/n, n));

    profil = zeros(2*n,1);
    
    for i=1:n
        % On cherche le premier 1 � gauche, bord gauche du chiffre
        profil(i) = find(imagette(y(i),:) == 0, 1);
        % On cherche le dernier 1 � droite, bord droit du chiffre
        profil(i+n) = find(imagette(y(i),:) == 0, 1, 'last');
    end
    profil = profil/l;
end
