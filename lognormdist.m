%% function numeros=lognormdist(maxval,minval,cuantos)
% create a lognorm distribution of values (for example, ITIs and ISIs)
% using lognpdf

% maxval= maxvalue
% minval= minvalue
% cuantos -- how many individual values in your distribution

function numeros=lognormdist(maxval,minval,cuantos)

xITI=0:.2:(maxval- minval);
yITI = lognpdf(xITI,0,1.0);
yITI=floor(yITI/sum(yITI)*cuantos);
numeros=[];
for g=1:length(yITI)
    numeros=[numeros,ones(1,yITI(g))*(xITI(g)+minval)];
end


end

