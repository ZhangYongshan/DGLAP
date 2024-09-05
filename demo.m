clear; close all; clc;

addpath(genpath('funs'));
addpath("data\");
dataType = 'Augsburg'; dk = 5; set_ViewNum(3);
iter = 10;
%%
data3D = cell(1,get_ViewNum);
projDim = cell(1,get_ViewNum);
switch dataType

    case 'Augsburg'
        load('data_DSM.mat');
        load('data_HS_LR.mat');
        load('data_SAR_HR.mat');
        load('Augsburg_gt.mat');
        data3D{1} = data_DSM; % d=1
        projDim{1} = 1;
        data3D{2} = data_HS_LR; % d=180
        projDim{2} = 70;
        data3D{3} =data_SAR_HR; % d=4
        projDim{3} = 4;
        gt2D = Augsburg_gt;
        num_Pixel = 260;
        clear  data_DSM data_HS_LR data_SAR_HR TestImage;
end

gt = double(gt2D(:));
ind = find(gt);
c = length(unique(gt(ind)));

[X,spLabel] = preData(data3D,dk,num_Pixel);
[y_pred, Z, S, W,clusterNum] = DGLAP(X, spLabel, num_Pixel, c, projDim,iter);
results = evaluate_results_clustering(gt(ind),y_pred(ind));
