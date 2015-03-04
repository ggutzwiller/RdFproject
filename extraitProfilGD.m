function profil = extraitProfilGD( imagette, n, dir )
% par defaut gauche
[h, l] = size(imagette);
y = floor(linspace(h/n, h-h/n, n));

profil = zeros(n,1);

if(dir=='d')
    for i=1:n
        profil(i) = find(imagette(y(i),:) == 0, 1);
    end
    
else
    for i=1:n
        profil(i) = find(imagette(y(i),:) == 0, 1, 'last');
    end
    
end

profil = profil/l;

end
