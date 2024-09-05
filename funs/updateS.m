function S = updateS(U, F, gamma, lambda,alpha,k)

num = size(U{1},2);
distf = (pdist2(F,F)).^2;
distX = zeros(num,num);
view_num = get_ViewNum;
for V = 1:view_num
    temp = L2_distance_1(U{V}, U{V})*(1/alpha(V));
    distX= distX + temp;
end

[~, idx] = sort(distX,2);

S = zeros(num);
for i=1:num
    idxa0 = idx(i,2:k+1);
    dfi = distf(i,idxa0);
    dxi = distX(i,idxa0);
    ad = -(dxi + lambda*dfi)/(2*gamma);
    S(i,idxa0) = EProjSimplex_new(ad);
end
S = (S+S')/2;

end