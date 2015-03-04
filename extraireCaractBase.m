function caract = extraireCaractBase( imagette, nRang, nCol, nTrait )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

densite = extraitDensites(imagette, nRang, nCol);

profil = extraitProfils(imagette, nTrait);

caract = [profil' densite'];

end

