function imCrop = crop(im)

[image_dy, image_dx] = size(im);

iy = 1;

% on vire les lignes blanche horizontales
while (iy<=image_dy)
    while ((iy<=image_dy) & (sum(im(iy, :)) == image_dx*255)) % ligne blanche
        iy = iy + 1;
    end    
    yImageCrop = 1;
    
    % tant que ligne non blanche : on recopie la ligne dans l'image destination
    if (iy<image_dy) 
        while ((iy<=image_dy) & (sum(im(iy, :)) ~= image_dx*255)) % ligne non blanche
            imTmp(yImageCrop, :) = im(iy, :);
            iy = iy + 1;
            yImageCrop = yImageCrop + 1;
        end
    end          
end

imCrop = imTmp;
% PAS NECESSAIRE...
% % idem pour les colonnes
% [image_dy, image_dx] = size(imTmp);
% 
% ix = 1;
% while (ix<=image_dx)
%     while ((ix<=image_dx) & (sum(im(:, ix)) == image_dy*255)) % colonne blanche
%         ix = ix + 1;
%     end    
%     xImageCrop = 1;
%        
%     if (ix<image_dx) 
%         while ((ix<=image_dx) & (sum(im(:, ix)) ~= image_dy*255)) % colonne non blanche
%             imCrop(:, xImageCrop) = imTmp(:, ix);
%             ix = ix + 1;
%             xImageCrop = xImageCrop + 1;
%         end
%     end          
% end

