%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Squelette de programme pour tp de reco de formes 	%%%%%
%%%%%   Cl�ment Chatelain          janvier 2013		%%%%%
%%%%%   D�partement ASI - INSA de Rouen 		%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

%%%%%%%%%%%%%%%%%%%% apprentissage %%%%%%%%%%%%%%%%%%%%%%%%%
im = imread('app.tif'); % lecture fichier image d'apprentissage
coordImages = extractionImages(im); 
nbImageBaseApp = length(coordImages);
sprintf('APPRENTISSAGE detection images OK : %d images detect�es\n', nbImageBaseApp);

m = 5;
n=5;%nb de traits
lesprofils = zeros(n*2, nbImageBaseApp);
lesdensites = zeros(m,n,nbImageBaseApp);
modele = zeros(n*m+n*2, nbImageBaseApp);

for (iImage=1 : nbImageBaseApp)
    iImage;
    % localisation et extraction des imagettes
    largeur = coordImages(iImage, 2) - coordImages(iImage, 1) - 2;
    hauteur = coordImages(iImage, 4) - coordImages(iImage, 3) - 2;
    x0 = coordImages(iImage, 1);
    y0 = coordImages(iImage, 3);
    imageChiffre = subimage(im, largeur, hauteur, x0, y0);
  
    % crop (supprimer les bords blancs)
    imageChiffreCroppee = crop(imageChiffre);    
    imagesc(imageChiffreCroppee); %afficher les imagettes de chiffres    
    
    %%%%%% ICI c'est à vous de Jouer !!!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % extraire des caractéristiques ...
    lesprofils(:,iImage) = extraitProfils(imageChiffreCroppee, n);
    lesdensites(:,:,iImage) = extraitDensites(imageChiffreCroppee, m, n);
    % faire un modèle ...
    modele(:,iImage) = [lesprofils(:,iImage)' reshape(lesdensites(:,:,iImage), 1, m*n)]    
    % le sauvegarder ...
    
    % Astuce : la classe de l'image courante est donn�e par : iClasse = fix((iImage-1)/20)
    sprintf('classe de l image %d : %d\n', iImage, fix((iImage-1)/20))
    
    %%%%%%%%%%%%%%%%%%%%%%
end


modeleDEM = zeros(10,35)
for i=0:9
    for j = 1:35
        modeleDEM(i+1, j) = sum(modele(j, i*20+1:(i+1)*20))/20
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% decision %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
imTest = imread('test.tif'); % lecture fichier image test
coordImagesTest = extractionImages(imTest);
length(coordImagesTest)
nbImageBaseTest = length(coordImagesTest);



for (iImage=1 : nbImageBaseTest)
    largeur = coordImagesTest(iImage, 2) - coordImagesTest(iImage, 1) - 2;
    hauteur = coordImagesTest(iImage, 4) - coordImagesTest(iImage, 3) - 2;
    
    % extraction image
    imageChiffre = subimage(imTest, largeur, hauteur, coordImagesTest(iImage, 1), coordImagesTest(iImage, 3));
    
    % crop
    imageChiffreCroppee = crop(imageChiffre);    
    imagesc(imageChiffreCroppee); %afficher les imagettes de chiffres
    %%%%%% ICI c'est à vous de Jouer !!!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % appliquer le modèle sauvegardé sur les chiffres de l'image de test ...
    caracImage = [extraitProfils(imageChiffreCroppee, n) reshape(extraitDensites(imageChiffreCroppee, m, n), 1, m*n)];
    distance = norm(modeleDEM(1,:)-caracImage, 2);
    k(iImage) = 0;
    for i=2:10
        if (norm(modeleDEM(i,:)-caracImage, 2) < distance)
            distance = norm(modeleDEM(i,:)-caracImage, 2);
            k(iImage) = i-1;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%
end
%%%%%%%%% Calcul des performances %%%%%%%%

confusionDEM = zeros(10,10)
confusionDEM




