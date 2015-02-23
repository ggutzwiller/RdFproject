function [ nb, imgs ] = crop_image( filename )
%crop_image Extract subimages, return number and images
%   Detailed explanation goes here

im = imread(filename); % lecture fichier image d'apprentissage
coordImages = extractionImages(im); 
nb = length(coordImages);

imgs = cell(1,nb);

for (iImage=1 : nb)
    % localisation et extraction des imagettes
    largeur = coordImages(iImage, 2) - coordImages(iImage, 1) - 2;
    hauteur = coordImages(iImage, 4) - coordImages(iImage, 3) - 2;
    x0 = coordImages(iImage, 1);
    y0 = coordImages(iImage, 3);
    imageChiffre = subimage(im, largeur, hauteur, x0, y0);
  
    % crop (supprimer les bords blancs)
    imgs{iImage} = crop(imageChiffre);
    
end

end

