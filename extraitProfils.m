function profil = extraitProfils( imagette, n )
    % Ici un joli commentaire
    h = size(imagette, 1)
    l = size(imagette, 2)
    y = linspace(h/n, h-h/n, n)

    for i=1:n
        k = 1;
        while(imagette(int64(y(i)),k) == 255)
            k = k + 1;
        end 
        profil(i) = k;
        k = l;
        while(imagette(int64(y(i)),k) == 255)
            k = k - 1;
        end 
        profil(i+n) = l-k;
    end
    profil = profil/l;
end

