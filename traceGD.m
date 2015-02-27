function [ imagette ] = traceGD( imagette, dir )
%traceGD trace de l'image vers gauche (g) ou droite (d) (gauche par defaut)
%   Detailed explanation goes here

hauteur = size(imagette,1);

if(dir=='d')
    for i=1:hauteur
        p = find(imagette(i,:) == 0, 1);
        imagette(i,1:p)=0;
    end
else
    for i=1:hauteur
        p = find(imagette(i,:) == 0, 1, 'last');
        imagette(i,p:end)=0;
    end
end
