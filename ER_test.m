% 对单个ER随机网进行分析

% 生成ER随机网 ===========================
close all;
clear;
clc;

N = 100;
P = 0.1;

G = ER(N,P);

% 可视化 =================================

figure("Name","ER随机网");

plot(G,'layout','circle');
title("N="+N+" P="+P);  

% 需要计算的统计信息 ======================

S = Stat(G);
VisualizeStat(G,S);

% 统计性质理论与实际比较 ===================

disp("可以发现，富人俱乐部的现象很明显");

disp("【度分布】===================");
figure("Name","统计性质");
D_max = max(S.D_list);

lambda = (N-1)*P;
E_lambda = poissfit(S.D_node);
disp("理论λ："+lambda);
disp("最大似然估计λ："+E_lambda);
disp("ER网中，两两之间的连接服从二项分布。由于泊松分布是二项分布的等待分布，度的分布符合泊松分布");
disp("泊松分布的lambda=节点的平均度，一个节点只能和N-1个其它节点产生连接，故λ=(N-1)P");

D_poisson = makedist('Poisson','lambda',lambda);
P_poisson = pdf(D_poisson,1:D_max);

plot(1:D_max,P_poisson,'o-');
hold on;
plot(S.D_list,S.D_pdf,'x-');
legend("泊松分布","实际分布");
xline(lambda,'-',"理论λ",'LabelVerticalAlignment','top','HandleVisibility','off');
xline(E_lambda,'--',"估计λ",'LabelVerticalAlignment','bottom','HandleVisibility','off');

% KS和AD检验仅适用于连续分布，泊松分布是离散分布
% 使用专用于检验离散数据的卡方拟合优度检验
[H,P_value] = chi2gof(S.D_node,'CDF',D_poisson);
if(H==0)
    disp("卡方拟合优度检验表明：ER网的度分布服从泊松分布，P值="+P_value);
else
    disp("卡方拟合优度检验表明：ER网的度分布不服从泊松分布，P值="+P_value);
end
