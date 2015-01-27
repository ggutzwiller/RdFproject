function coordLignes = extractionLignes(im)
% coordLigne[yDebLigne][yFinLigne]

[image_dy, image_dx] = size(im)
nbLigne = 0;

%for (iy = 1:image_dy)
iy = 1;
while (iy<=image_dy)
    
    % recherche début ligne
    while ((iy<=image_dy) && (sum(im(iy, :)) == image_dx*255)) % ligne blanche
        iy = iy + 1;
    end    
    
    if (iy<image_dy) 
        nbLigne = nbLigne + 1;
        coordLignes(nbLigne, 1) = iy;
        while ((iy<=image_dy) && (sum(im(iy, :)) ~= image_dx*255)) % ligne non blanche
            iy = iy + 1;
        end
        coordLignes(nbLigne, 2) = iy - 1;
    end          
end
