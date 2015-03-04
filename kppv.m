function npp = kppv( caract, n, modele, fEtiquette, fDistance )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

iMax = size(modele, 2);

distances = zeros(2,iMax);

for i=1:iMax
    distances(:,i) = [fEtiquette(i) fDistance(modele(:,i)', caract)];
end

distb = sortrows(distances', 2)';

npp = distb(:,1:n);

end

