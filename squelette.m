%% Projet DOC Rdf 2015  |BARON GUTZWILLER ASI 4|
% <<asir.jpg>>

%%% _RAZ_
close all; clc; clear all; format short g;

%%% *Introduction*
% Voici notre projet de reconnaissance de chiffres proposé par M.Chatelain

%%% *1 - Les données*
% Base d'apprentissage :
%
% <<app.tif>>
%
% Base de test :
%
% <<test.tif>>

%%% *2 - Découpe des imagettes*
% On réutilise les fonctions données par M.Chatelain pour procéder au
% découpage des imagettes, nous les avons condensées dans un crop_image.m :

% Base d'apprentissage
[nbImageBaseApp, imagesChiffreCroppe] = crop_image('app.tif');

% Base de test
[nbImageBaseTest, imagesChiffreCroppeT] = crop_image('test.tif');

%% *3 - Apprentissage du modèle*
% Dans la suite, les parametres m,n et nTraits ont été testés via des
% boucles "for" pour trouver les optimum, on affichera seulement les 
% résultats obtenus avec ces paramètres pour plus de clareté.

% Paramètres optimaux
m = 10; % rangées de densitée
n = 5; % col de densité
nTraits = 10; % nb de traits

modele = zeros(n*m+nTraits*2, nbImageBaseApp);

%%
% Voici les fonctions d'extraction des caractéristiques de base :
type extraireCaractBase.m;
type extraitDensites.m;
type extraitProfils.m;

%%
% On extrait les caractéristiques de la base d'apprentissage :
for iImage=1 : nbImageBaseApp

    % extraction des caractéristiques
    caract = extraireCaractBase(imagesChiffreCroppe{iImage}, m, n, nTraits);
    % création du modèle
    modele(:,iImage) = caract;
end

%%%
% Astuce : la classe de l'image courante est donnée par : iClasse = fix((iImage-1)/20)
classes = @(i) floor((i-1)/20);

%%%
% Enfin, on sauvegarde le modèle :
save('modeleRDF.mat', 'modele');

%% *4 - Classification*
% Extraction des caractéristiques des exemples
caractImagesTest = zeros(n*m+nTraits*2, nbImageBaseTest);

for iImage=1 : nbImageBaseTest
    
    caractImagesTest(:,iImage) = ...
           extraireCaractBase(imagesChiffreCroppeT{iImage}, m, n, nTraits);
end

%% 4 - a : Reconaissance avec distance euclidienne minimale sur modèle moyen

% Création du modèle moyen
modeleDEM = zeros(size(modele,1),10);
for i=0:9
    for j = 1:size(modele,1)
        modeleDEM(j, i+1) = sum(modele(j, i*20+1:(i+1)*20))/20;
    end
end

% Classes des images moyennes
classeMoy = [ 0 1 2 3 4 5 6 7 8 9 ];

% Définition de la distance euclidienne
dEuclid = @(x,y) sqrt(sum((x - y) .^ 2));

resultatsEuclidMin = zeros(1,nbImageBaseTest);

% Recherche du chiffre qui approche le plus du modèle moyen
for iImage=1 : nbImageBaseTest
    
resultatsEuclidMin(iImage) = ...
    detClassdMin(caractImagesTest(:,iImage)',modeleDEM,classeMoy,dEuclid);

end

%% _Résultats de cette methode_

confusionDEM = make_confusion(resultatsEuclidMin)

%%
% Voici sur les chiffres de 0 a 9 les taux de reconnaissance de cette méthode :
diag(confusionDEM)

%%
% Soit un taux moyen de :
mean(diag(confusionDEM))

%% Test sans moyenner les classes

% Recherche du chiffre qui approche le plus du modèle
for iImage=1 : nbImageBaseTest
    
    resultatsEuclidMin(iImage) = ...
          detClassdMin(caractImagesTest(:,iImage)',modele,classes,dEuclid);
end

%% _Resultats de cette methode_

confusionDE = make_confusion(resultatsEuclidMin);

%%
% Voici sur les chiffres de 0 à 9 les taux de reconnaissance de cette methode :
diag(confusionDE)

%%
% Soit un taux moyen de :
mean(diag(confusionDE))

%% 4 - b : Décision avec la méthode des kppv
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
% Voici les taux de reconnaissance de cette methode pour les k testés :
succes

%%
% Soit en taux moyen par k :
mean(succes')
%%%
% On voit que le k optimal est 2.

%% *Méthode des kppv avec d'autres distances*
% Définition de la distance minkowski 3 et manhattan :
dMinkow3 = @(x,y) nthroot(sum(abs(x - y) .^ 3),3);
dManhat = @(x,y) sum(abs(x - y));

%%
% Pour Manhattan :
resultatsKppvMan = zeros(1,nbImageBaseTest);

for iImage=1 : nbImageBaseTest

    tppv = kppv(caractImagesTest(:,iImage)',2,modele,classes,dManhat);

    resultatsKppvMan(iImage) = mode(tppv(1,:));
end

confusionKPPVMan = make_confusion(resultatsKppvMan);

diag(confusionKPPVMan)

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

confusionKPPVMink = make_confusion(resultatsKppvMink);

diag(confusionKPPVMink)

%%
% Soit un taux moyen de réussite de :
mean(diag(confusionKPPVMink))

%%%
% On gagne un pourcent de plus avec Minkowski de degré 3 mais les 9 posent 
% toujours problème.

%% *Autres caractéristiques*
% Nous allons tenter de mettre en oeuvre d'autres caracteristiques comme la
% trace vers la gauche ou vers la droite. Voici la fonction trace et
% quelques exemples de son action :
type traceGD.m

figure
subplot(1,3,1)
imagesc(traceGD(imagesChiffreCroppe{167},'g'))
subplot(1,3,2)
imagesc(imagesChiffreCroppe{167})
subplot(1,3,3)
imagesc(traceGD(imagesChiffreCroppe{167},'d'))

%%
% On recommence l'apprentissage :
% Voici la fonction d'extraction des caractéristiques avec trace :
type extraireCaractTraceGD.m

%%
% Voici les 3 sets de paramètres optimaux :

% m = 8; n = 6; nTraits = 10;
% m = 10; n = 7; nTraits = 10;
m = 9; n = 6; nTraits = 10;

%%
% On extrait les caractéristiques de la base d'apprentissage :
for iImage=1 : nbImageBaseApp

    % extraction des caractéristiques pour la trace gauche
    caractTG = extraireCaractTraceGD(...
                          imagesChiffreCroppe{iImage}, 'g', m, n, nTraits);
    % création du modèle pour la trace gauche
    modeleTG(:,iImage) = caractTG;

    % extraction des caractéristiques pour la trace droite
    caractTD = extraireCaractTraceGD(...
                          imagesChiffreCroppe{iImage}, 'd', m, n, nTraits);
    % création du modèle pour la trace droite
    modeleTD(:,iImage) = caractTD;
end

%%%
% On teste avec kppv Minkowski 3 et distance euclidienne mini :

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

%% _Résultats pour la trace gauche_
confusionkppvG = make_confusion(resultatsG);
confusionDEG = make_confusion(resultatsEuclidMinG);

%%
% Soit un taux moyen de réussite de :
mean(diag(confusionkppvG))
mean(diag(confusionDEG))

%% _Résultats pour la trace droite_
confusionkppvD = make_confusion(resultatsD);
confusionDED = make_confusion(resultatsEuclidMinD);

%%
% Soit un taux moyen de réussite de :
mean(diag(confusionkppvD))
mean(diag(confusionDED))

%% *Caractéristique avec trace gauche ET droite*
% Le but ici est de mieux discriminer les 9 :

% Paramètres optimaux :
m = 8; n = 10;
    
% On extrait les caractéristiques de la base d'apprentissage :
for iImage=1 : nbImageBaseApp

    % extraction des caractéristiques pour la trace gauche droite
    caractTGD = extraitDensites(traceGD(traceGD(...
                             imagesChiffreCroppe{iImage}, 'g'),'d'), m, n);

    % création du modele pour la trace gauche droite
    modeleTGD(:,iImage) = caractTGD;
end

for iImage=1 : nbImageBaseTest

    caractImagesTestGD(:,iImage) = extraitDensites(traceGD(traceGD(...
                            imagesChiffreCroppeT{iImage}, 'g'),'d'), m, n);

    resultatsEuclidMinGD(iImage) = ...
      detClassdMin(caractImagesTestGD(:,iImage)',modeleTGD,classes,dEuclid);
end

%% _Résultats pour la trace gauche droite_
confusionDEGD = make_confusion(resultatsEuclidMinGD);
diag(confusionDEGD)

%%
% On remarque qu'avec cette methode les 9 sont bien mieux discriminés mais
% le reste non, le taux moyen de réussite étant de :
mean(diag(confusionDEGD))

%% *Combinaison des classifieurs*
% On va combiner le classifieur kppv minkoski3 avec le distance euclidienne
% trace droite et le distance euclidienne trace gauche droite.
%
% Sur les matrices de confusion prédentes, les certitudes sont les colonnes
% qui ne contiennent qu'une seule donnée sur la diagonale (i.e: on ne 
% confond ces chiffres avec aucun autre).
% 
% On va commencer par le plus précis pour finir par le moins précis mais
% qui discrimine mieux les 9 des 8. Dans chaque cas on reprend les
% paramètres optimaux.

% Vecteurs des certitudes par méthodes :
certainKppvMink3 = [ 0 1 3 4 5 6 ];
certainDETD = [ 0 1 2 3 5 6 7 ];

% Les calculs étants déja effectués, on reprend avec les résultats d'avant:
for iImage=1 : nbImageBaseTest
    % on teste a chaque fois si l'estimation obtenue est une certitude
    if(ismember(resultatsKppvMink(iImage),certainKppvMink3))
        resultatsCombi(iImage) = resultatsKppvMink(iImage);
    
    % Si non on passe à la méthode suivante
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

%% _Résultats combinés_
confusionCombi = make_confusion(resultatsCombi);
diag(confusionCombi)

%%
% 
mean(diag(confusionCombi))

%%
% On obtient un taux moyen de réussite de 98%, les confusions étant avec
% cette méthode sur un 3 et un 8 confondus en 9.

%% *Conclusion*
% Nous venons de voir que la reconnaissance de formes est sensible aux
% parametres initiaux et aux caractéristiques utilisées. En combinant des
% méthodes plutôt basiques et pas toujours efficaces globalement, on peut
% créer une très bon classifieur.

%% _*INSA de Rouen* - 2015_
% <<insa.png>>