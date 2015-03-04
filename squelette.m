%% Projet DOC Rdf 2015  |BARON GUTZWILLER ASI 4|
% <<asir.jpg>>

%%% _RAZ_
close all; clc; clear all;

%% *1 - Les données*
% Base d'apprentissage :
%
% <<app.tif>>
%
% Base de test :
%
% <<test.tif>>

%% *2 - Decoupe des imagettes*
% Base d'apprentissage
[nbImageBaseApp, imagesChiffreCroppe] = crop_image('app.tif');
%%%
% Base de test
[nbImageBaseTest, imagesChiffreCroppeT] = crop_image('test.tif');

%% *3 - Apprentissage du modèle*

m = 10; %rangées de densitée
n = 5; %col de densité
nTraits = 10; %nb de traits

modele = zeros(n*m+nTraits*2, nbImageBaseApp);

%%
% Voici la fonction d'extraction des caracteristiques de base :
system('type extraireCaractBase.m');

%%
% On extrait les caracteristiques de la base d'apprentissage :
for iImage=1 : nbImageBaseApp

    % extraction des caracteristiques
    caract = extraireCaractBase(imagesChiffreCroppe{iImage}, m, n, nTraits);
    % creation du modele
    modele(:,iImage) = caract;

end

%%%
% Astuce : la classe de l'image courante est donnee par : iClasse = fix((iImage-1)/20)
classes = @(i) floor((i-1)/20);

%%%
% Enfin, on sauvegarde le modele :
save('modeleRDF.mat', 'modele');

%% *4 - Classification*
% Extraction des caracteristiques des exemples
caractImagesTest = zeros(n*m+nTraits*2, nbImageBaseTest);

for iImage=1 : nbImageBaseTest
    caractImagesTest(:,iImage) = ...
        extraireCaractBase(imagesChiffreCroppeT{iImage}, m, n, nTraits);
end

%% 4 - a : Reconaissance avec distance euclidienne minimale sur modele moyen

% Creation du modele moyen
modeleDEM = zeros(size(modele,1),10);
for i=0:9
    for j = 1:size(modele,1)
        modeleDEM(j, i+1) = sum(modele(j, i*20+1:(i+1)*20))/20;
    end
end

% Classes des images moyennes
classeMoy = [ 0 1 2 3 4 5 6 7 8 9 ];

% Definition de la distance euclidienne
dEuclid = @(x,y) sqrt(sum((x - y) .^ 2));

resultatsEuclidMin = zeros(1,nbImageBaseTest);

% Recherche du chiffre qui approche le plus du modele moyen
for iImage=1 : nbImageBaseTest
    
resultatsEuclidMin(iImage) = ...
    detClassdMin(caractImagesTest(:,iImage)',modeleDEM,classeMoy,dEuclid);

end

%% _Resultats de cette methode_

confusionDEM = make_confusion(resultatsEuclidMin);

%%
% Voici sur les chiffres de 0 a 9 les taux de reconnaissance de cette methode :
diag(confusionDEM)

%%
% Soit un taux moyen de :
mean(diag(confusionDEM))

%% 4 - b : Decision avec la methode des kppv
%
resultatsKppv = zeros(1,nbImageBaseTest);

for tests=1:4
    
    for iImage=1 : nbImageBaseTest

        tppv = kppv(caractImagesTest(:,iImage)',tests,modele,classes,dEuclid);
        
        resultatsKppv(iImage) = mode(tppv(1,:));

    end

confusionKPPV = make_confusion(resultatsKppv);

succes(tests,:) = diag(confusionKPPV);

end

%% _Resultats de cette methode_
% Voici les taux de reconnaissance de cette methode pour les k testes :
succes

%%
% Soit en taux moyen par k :
mean(succes')
%%%
% On voit que le k optimal est 2.

%% kppv avec d'autres distances
% Definition de la distance minkowski 3 et manhattan :
dMinkow3 = @(x,y) nthroot(sum(abs(x - y) .^ 3),3);
dManhat = @(x,y) sum(abs(x - y));


%% *Annexe 1 :* Code MATLAB
% Voici une copie du code matlab qui vient d'Ãªtre exÃ©cutÃ© :

% system('cat squelette.m');

%% _*INSA de Rouen* - 2015_
% <<insa.png>>