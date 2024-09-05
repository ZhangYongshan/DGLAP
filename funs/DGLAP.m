function [y_pred, Z, S, W,clusterNum] = main(X, spLabel, m, c, r,iter_num)
%%
% Input:
%       X: 2D data matrix, each column is a pixel(sample).
%       spLabel: superpixel labels, column vector
%       m: anchor number (superpixel number).
%       c: cluster number.
%       r: Projection dimension.
% Output:
%       y_pred: Predict labels
%       Z: anchor graph, n by m
%       S: anchor-anchor graph, m by m.
%       W: projection matrix.
%       clusternum: The number of connected components of 'S'.
%%

view_num = get_ViewNum;
A = cell(1,view_num);
W = cell(1,view_num);
St = cell(1,view_num);
U = cell(1,view_num);
alpha = ones(1,view_num)/view_num;
mu = ones(1,view_num)/view_num;

Iter = [iter_num,30];
k = 5;
for v = 1:view_num
    A{v} = initA(X{v}, spLabel,m);
    St{v} = X{v}*X{v}';
end
% init Z
Z= updateZ(X, A, k);
    
for iter1 = 1:Iter(1)

    for v = 1:view_num
        W{v} = updateW(X{v}, A{v}, Z, r{v});
        U{v} = W{v}' * A{v};
    end
    
    mu = updateMu(W,X,A,Z);
    Z= updateZ(X, U, k,W,mu);
    [GAMMA,S] = initS(U,m);
    gamma = GAMMA/m;
    lambda = gamma;
    
    Ds = diag(sum(S));
    Ls = Ds - S;
    [F, ~, ~]=eig1(Ls, c, 0);

    for iter2 = 1:Iter(2)
        S = updateS(U, F, gamma, lambda, alpha,k);
        
        Ls = diag(sum(S)) - S;
        F_old = F;
        [F, ~, ev] = eig1(Ls, c, 0);
        
        fn1 = sum(ev(1:c));
        fn2 = sum(ev(1:c+1));
        if fn1 > 0.00000000001
            lambda = 2*lambda;
        elseif fn2 < 0.00000000001
            lambda = lambda/2;
            F = F_old;
        else
            break;
        end
    end
    
    fprintf('%2d,',iter2);
    alpha = updateAlpha(U,Ls);
    for v = 1:view_num
        A{v} = (alpha(v)*X{v}*Z)/(alpha(v)*diag(sum(Z))+2*mu(v)*Ls);
        if find(isnan(A{v}))
            break;
        end
    end
    
end

[U_label]=conncomp(graph(sparse(S)));
clusterNum = length(unique(U_label));
[~, X_subLabel] = max(Z,[],2); 
y_pred = zeros(size(Z,1),1); 
for ii = 1:m
    y_pred(X_subLabel == ii) = U_label(ii);
end

end