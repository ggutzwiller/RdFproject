function coordImages = extractionImages(im);
%coordImages[xO, x1, y0, y1]

[image_dy, image_dx] = size(im);
coordLignes = extractionLignes(im);
nbLigne = length(coordLignes);
nbImage = 0;

for (iLigne = 1:nbLigne)
    
    y0_ligne = coordLignes(iLigne, 1);
    y1_ligne = coordLignes(iLigne, 2);
    hauteurLigne = y1_ligne - y0_ligne;
    ix = 1;
    if (hauteurLigne > 2)
        while (ix <= image_dx - 1)            
            while ((ix <= image_dx - 1) && (sum(im( y0_ligne:y1_ligne - 1 , ix)) == hauteurLigne*255)) % colonne blanche
                ix = ix + 1;
            end
            x0 = ix;
          
            while ((ix <= image_dx    ) && (sum(im( y0_ligne:y1_ligne - 1, ix)) ~= hauteurLigne*255)) % colonne non blanche
                ix = ix + 1;
            end
            x1 = ix;
        
            if (ix < image_dx - 1)
                nbImage = nbImage + 1;
                coordImages(nbImage, 1) = x0;
                coordImages(nbImage, 2) = x1;
                coordImages(nbImage, 3) = y0_ligne;
                coordImages(nbImage, 4) = y1_ligne;
            end
        end
    end
    sprintf('ligne %d ordonnée de %d à %d : %d images detectées\n', iLigne, y0_ligne, y1_ligne, nbImage)

end
