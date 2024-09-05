function [GAMMA,S] = initS(U,m)

if nargin < 3
    k = 5;
end

view_num = get_ViewNum;
distU = zeros(size(U{1},2),size(U{1},2));
for v = 1:view_num
    temp = (pdist2((U{v})',U{v}')).^2;
    distU= distU+temp;
end


[distU1, idx] = sort(distU, 2);
S = zeros(m);
GAMMA = 0;
for i = 1:m
    di = distU1(i,2:k+2); 
    GAMMA = GAMMA + 0.5*(k*di(k+1)-sum(di(1:k)));
    id = idx(i,2:k+2);
    S(i,id) = (di(k+1)-di)/(k*di(k+1)-sum(di(1:k))+eps);
end

end

