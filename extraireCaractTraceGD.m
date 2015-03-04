function caract = extraireCaractTraceGD( imagette, dir, nRang, nCol, nTrait )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

imagetteTracee = traceGD(imagette, dir);

densite = extraitDensites(imagetteTracee, nRang, nCol);

profil = extraitProfilGD(imagetteTracee, nTrait, dir);

caract = [profil' densite'];

end

