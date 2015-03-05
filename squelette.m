%% Projet DOC Rdf 2015  |BARON GUTZWILLER ASI 4|
% <<asir.jpg>>

%%% _RAZ_
close all; clc; clear all;
format short g;

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

% Parametres optimaux
m = 10; % rangées de densitée
n = 5; % col de densité
nTraits = 10; % nb de traits

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

%% Test sans moyenner les classes

% Recherche du chiffre qui approche le plus du modele
for iImage=1 : nbImageBaseTest
    
resultatsEuclidMin(iImage) = ...
    detClassdMin(caractImagesTest(:,iImage)',modele,classes,dEuclid);

end

%% _Resultats de cette methode_

confusionDE = make_confusion(resultatsEuclidMin);

%%
% Voici sur les chiffres de 0 a 9 les taux de reconnaissance de cette methode :
diag(confusionDE)

%%
% Soit un taux moyen de :
mean(diag(confusionDE))

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

%% Méthode des kppv avec d'autres distances
% Definition de la distance minkowski 3 et manhattan :
dMinkow3 = @(x,y) nthroot(sum(abs(x - y) .^ 3),3);
dManhat = @(x,y) sum(abs(x - y));

%%
% Pour Manhattan :
resultatsKppvMan = zeros(1,nbImageBaseTest);

for iImage=1 : nbImageBaseTest

    tppv = kppv(caractImagesTest(:,iImage)',2,modele,classes,dManhat);

    resultatsKppvMan(iImage) = mode(tppv(1,:));

end

confusionKPPVMan = make_confusion(resultatsKppvMan)

%%
% Soit un taux moyen de réussite de :
mean(diag(confusionKPPVMan))

%%
% Pour Minkowski de degré 3 :
resultatsKppvMink = zeros(1,nbImageBaseTest);

for iImage=1 : nbImageBaseTest

    tppv = kppv(caractImagesTest(:,iImage)',2,modele,classes,dMinkow3);

    resultatsKppvMink(iImage) = mode(tppv(1,:));

end

confusionKPPVMink = make_confusion(resultatsKppvMink)

%%
% Soit un taux moyen de réussite de :
mean(diag(confusionKPPVMink))

%%%
% On gagne un pourcent de plus avec Minkowski de degré 3 mais les 9 posent 
% toujours problème.

%% Autres caractéristiques
% Nous allons tenter de mettre en oeuvre d'autres caracteristiques comme la
% trace vers la gauche ou vers la droite.
% On recommence l'apprentissage :

%%
% Voici la fonction d'extraction des caracteristiques avec trace :
system('type extraireCaractTraceGD.m');
system('type traceGD.m');

%%%
% Voici les parametres optimaux :
% m = 8; n = 6; nTraits = 10;
% ou
% m = 10; n = 7; nTraits = 10;
 m = 9; n = 6; nTraits = 10;
%%
% On extrait les caracteristiques de la base d'apprentissage :
for iImage=1 : nbImageBaseApp

% extraction des caracteristiques pour la trace gauche
caractTG = extraireCaractTraceGD(imagesChiffreCroppe{iImage}, 'g', m, n, nTraits);
% creation du modele pour la trace gauche
modeleTG(:,iImage) = caractTG;

% extraction des caracteristiques pour la trace droite
caractTD = extraireCaractTraceGD(imagesChiffreCroppe{iImage}, 'd', m, n, nTraits);
% creation du modele pour la trace droite
modeleTD(:,iImage) = caractTD;

end

%%%
% On teste avec kppv Minkowski 3 et distance euclidienne mini :

caractImagesTestG = zeros(n*m+nTraits, nbImageBaseTest);
caractImagesTestD = zeros(n*m+nTraits, nbImageBaseTest);

resultatsEuclidMinG = zeros(1,nbImageBaseTest);
resultatsEuclidMinD = zeros(1,nbImageBaseTest);

resultatsG = zeros(1,nbImageBaseTest);
resultatsD = zeros(1,nbImageBaseTest);

for iImage=1 : nbImageBaseTest

    caractImagesTestG(:,iImage) = ...
        extraireCaractTraceGD(imagesChiffreCroppeT{iImage}, 'g', m, n, nTraits);
    
    caractImagesTestD(:,iImage) = ...
        extraireCaractTraceGD(imagesChiffreCroppeT{iImage}, 'd', m, n, nTraits);
    
    resultatsEuclidMinG(iImage) = ...
    detClassdMin(caractImagesTestG(:,iImage)',modeleTG,classes,dEuclid);

    resultatsEuclidMinD(iImage) = ...
    detClassdMin(caractImagesTestD(:,iImage)',modeleTD,classes,dEuclid);
    
    tppvG = kppv(caractImagesTestG(:,iImage)',1,modeleTG,classes,dMinkow3);
    
    tppvD = kppv(caractImagesTestD(:,iImage)',1,modeleTD,classes,dMinkow3);

    resultatsG(iImage) = mode(tppvG(1,:));
    
    resultatsD(iImage) = mode(tppvD(1,:));

end

%% Resultats pour la trace gauche
confusionkppvG = make_confusion(resultatsG);
confusionDEG = make_confusion(resultatsEuclidMinG);

%%
% Soit un taux moyen de réussite de :
mean(diag(confusionkppvG))
mean(diag(confusionDEG))

%% Resultats pour la trace droite
confusionkppvD = make_confusion(resultatsD);
confusionDED = make_confusion(resultatsEuclidMinD);

%%
% Soit un taux moyen de réussite de :
mean(diag(confusionkppvD))
mean(diag(confusionDED))

%% Caracteristique de la dernière chance avec trace gauche ET droite
% Le but ici est de mieux discriminer les 9 :

% Parametres optimaux :
m = 8; n = 10;
    
% On extrait les caracteristiques de la base d'apprentissage :
for iImage=1 : nbImageBaseApp

% extraction des caracteristiques pour la trace gauche droite
caractTGD = extraitDensites(traceGD(traceGD(imagesChiffreCroppe{iImage}, 'g'),'d'), m, n);

% creation du modele pour la trace gauche droite
modeleTGD(:,iImage) = caractTGD;

end

for iImage=1 : nbImageBaseTest

    caractImagesTestGD(:,iImage) = ...
        extraitDensites(traceGD(traceGD(imagesChiffreCroppeT{iImage}, 'g'),'d'), m, n);
    
    resultatsEuclidMinGD(iImage) = ...
        detClassdMin(caractImagesTestGD(:,iImage)',modeleTGD,classes,dEuclid);

end

%% Resultats pour la trace gauche droite
confusionDEGD = make_confusion(resultatsEuclidMinGD);
diag(confusionDEGD)

%%%
% On remarque qu'avec cette methode les 9 sont bien mieux discriminés mais
% le reste non, le taux moyen de réussite étant de :
mean(diag(confusionDEGD))

%% Combinaison des classifieurs
% On va combiner le classifieur kppv minkoski3 avec le distance euclidienne
% trace droite et le distance euclidienne gauche droite.
% Sur les matrices de confusion predentes, les certitudes sont les colonnes
% qui ne contiennent une seule donnée sur la diagonale. On va commencer par
% le plus précis pour finir par le moins précis mais qui discrimine mieux
% les 9 des 8. Dans chaque cas on reprend les parametres optimaux.

% Vecteurs des certitudes par méthodes :
certainKppvMink3 = [ 0 1 3 4 5 6 ];
certainDETD = [ 0 1 2 3 5 6 7 ];

% Les calculs étants déja effectués, on reprend avec les résultats d'avant:
for iImage=1 : nbImageBaseTest
    if(ismember(resultatsKppvMink(iImage),certainKppvMink3))
        resultatsCombi(iImage) = resultatsKppvMink(iImage);
    
    else if (ismember(resultatsEuclidMinD(iImage),certainDETD))
            resultatsCombi(iImage) = resultatsEuclidMinD(iImage);
         
        else if (resultatsEuclidMinGD(iImage)==9)
                resultatsCombi(iImage) = 9;
            else
                resultatsCombi(iImage) = 8;
            end
        end
    end
end

%% Resultats combinés
confusionCombi = make_confusion(resultatsCombi);
diag(confusionCombi)

mean(diag(confusionCombi))

%% *Annexe 1 :* Code MATLAB
% Voici une copie du code matlab qui vient d'Ãªtre exÃ©cutÃ© :

% system('cat squelette.m');

%% _*INSA de Rouen* - 2015_
% <<insa.png>>