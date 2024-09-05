function [alpha] = updateAlpha(U,Ls)
view_num = get_ViewNum;
alpha= ones(1,view_num)/view_num;
hv_sum = 0;
hv = zeros(1,view_num);
for v = 1:view_num
    hv(v) = 2*trace(U{v}*Ls*U{v}');
    hv_sum = hv_sum+sqrt(hv(v));
end

for v = 1:view_num
    alpha(v) = sqrt(hv(v))/hv_sum;
end
end

