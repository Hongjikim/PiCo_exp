function rx = rating_5d(x, j)

global barsize recsize rec;
% rx start from 0
if mod(barsize(5,j),2) == 0     % Self, Vividness: 0<=rx<=1
    rx = (x-(rec(j,1)+(recsize(1)-barsize(1,j))/2))/barsize(1,j);
else                            % Valence, Time, Safety/Threat: -1<=rx<=1
    rx = (x-(rec(j,1)+recsize(1)/2))/(barsize(1,j)/2);
end

end