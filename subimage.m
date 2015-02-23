function s = subimage(imageMere, largeur, hauteur, xDeb, yDeb)

s = imageMere(yDeb : yDeb + hauteur , xDeb : xDeb + largeur );

% [dy, dx] = size(s);
% 
% for r = 1:largeur 
%     for c = 1:hauteur 
%         s(c, r) = imageMere(yDeb + c, xDeb + r);
%     end
% end 