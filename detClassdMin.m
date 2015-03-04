function [c, distanceMin] = detClassdMin( caract, modele, fEtiquette, fDistance )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

iMax = size(modele, 2);

distanceMin = fDistance(modele(:,1)', caract);
c = fEtiquette(1);

for i=2:iMax
    distance = fDistance(modele(:,i)', caract);
    if (distance < distanceMin)
        distanceMin = distance;
        c = fEtiquette(i);
    end
end

end

