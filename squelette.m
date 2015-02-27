%% Projet DOC Rdf 2015  |BARON GUTZWILLER ASI 4|
% <<asir.jpg>>

%%% _RAZ_
close all; clc; clear all;

[nbImageBaseTest, imagesChiffreCroppeT] = crop_image('test.tif');

%% apprentissage %%%%%%%%%%%%%%%%%%%%%%%%%

[nbImageBaseApp, imagesChiffreCroppe] = crop_image('app.tif');

%sprintf('APPRENTISSAGE detection images OK : %d images detectees\n', nbImageBaseApp);

for m = 10 : 10
for n = 5 : 5
for nTraits = 10 : 10 %nb de traits
lesprofils = zeros(nTraits*2, nbImageBaseApp);
lesdensites = zeros(m*n,nbImageBaseApp);
modele = zeros(n*m+nTraits*2, nbImageBaseApp);

for (iImage=1 : nbImageBaseApp)

    % extraire des caractéristiques ...
    lesprofils(:,iImage) = extraitProfils(imagesChiffreCroppe{iImage}, nTraits);
    lesdensites(:,iImage) = extraitDensites(imagesChiffreCroppe{iImage}, m, n);
    % faire un modèle ...
    modele(:,iImage) = [lesprofils(:,iImage)' lesdensites(:,iImage)'];
    % le sauvegarder ...
    
    % Astuce : la classe de l'image courante est donnee par : iClasse = fix((iImage-1)/20)
    %sprintf('classe de l image %d : %d\n', iImage, fix((iImage-1)/20));
    
end


modeleDEM = zeros(10,size(modele,1));
for i=0:9
    for j = 1:size(modele,1)
        modeleDEM(i+1, j) = sum(modele(j, i*20+1:(i+1)*20))/20;
    end
end

%% decision euclid %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for (iImage=1 : nbImageBaseTest)
    
    % appliquer le modèle sauvegardé sur les chiffres de l'image de test ...
    caracImage = [extraitProfils(imagesChiffreCroppeT{iImage}, nTraits)' extraitDensites(imagesChiffreCroppeT{iImage}, m, n)'];
    distance = norm(modeleDEM(1,:)-caracImage, 2);
    k(iImage) = 0;
    for i=2:10
        if (norm(modeleDEM(i,:)-caracImage, 2) < distance)
            distance = norm(modeleDEM(i,:)-caracImage, 2);
            k(iImage) = i-1;
        end
    end

end

%% Calcul des performances euclid %%%%%%%%

confusionDEM = make_confusion(k);

confusionDEM 

diag(confusionDEM)'

%% decision kppv %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for tests=2:2
    kp=tests;
    for (iImage=1 : nbImageBaseTest)

        % appliquer le modèle sauvegardé sur les chiffres de l'image de test ...
        caracImage = [extraitProfils(imagesChiffreCroppeT{iImage}, nTraits)' extraitDensites(imagesChiffreCroppeT{iImage}, m, n)'];
        distance = zeros(2,200);

        distance(:, 1) = [0 norm(modele(:,1)'-caracImage, 2)];
        for i=2:200
            distance(:,i) = [floor((i-1)/20) norm(modele(:,i)'-caracImage, 2)];
        end

        distb = sortrows(distance', 2)';

        resultats(iImage) = mode(distb(1,1:kp));

    end

%%% Calcul des performances kppv %%%%%%%%

confusionKPPV = make_confusion(resultats)

succes(tests,:) = diag(confusionKPPV);

end

succes

succesmoy = mean(succes')'

%succesTraitFull(:,nTraits) = succesmoy;

succesD(m,n,nTraits) = max(succesmoy);

end
end
end

succesD

% Commentaire on qu'on optimal pour k = 2
%% *Annexe 1* : Code MATLAB
% Voici une copie du code matlab qui vient d'être exécuté :

% system('cat squelette.m');

%% _*INSA de Rouen* - 2015_
% <<insa.png>>