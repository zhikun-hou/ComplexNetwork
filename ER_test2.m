% 对不同参数的多个ER随机网进行分析
% 对应了【作业2】

close all;
clear;
clc;

% 生成ER随机网 ===========================

% % 【首次生成】
% N = [100,500,1000];
% P = 0.8.^[1:6];
% for i=1:numel(N)
%     for j=1:numel(P)
%         G{i,j} = ER(N(i),P(j));
%         S{i,j} = Stat(G{i,j});
%     end
% end
% S = [S{:}];

% 【加载已生成的网络】
load("ER_test2.mat");

% 展示曲线 ===============================

figure("Name","统计分析");
sgtitle("ER随机网络");

% 平均度与N、P的关系
subplot(2,2,1);
lambda = (N-1)'.*P;
scatter(  reshape(lambda,1,[])  ,[S.D_mean]);
xlabel("(N-1)*P");
ylabel("平均度");
title("平均度≈(N-1)P");

% C_net
subplot(2,2,2); % matlab列优先
scatter(  reshape(  repmat(P,numel(N),1)  ,1,[])  ,[S.C_net]);
xlabel("P");
ylabel("集聚系数");
title("集聚系数≈P");

% L_mean
subplot(2,2,3);
N_temp = reshape(  repmat(N',1,numel(P))  ,1,[]);
scatter( [S.L_mean], log(N_temp)./ log([S.D_mean] ));
xlabel("平均路径长度");
ylabel("log(N)/log(D)");
title("平均路径长度与log(N)正相关");

disp("【平均度】====================");
disp("平均度即每个节点的平均邻居个数");
disp("共有N个节点，每个节点与另外N-1个节点固定以P概率连接，故平均度=(N-1)P");

disp("【聚集系数】===================");
disp("结点聚集系数=邻居之间的边数/邻居之间的最大可能边数");
disp("网络聚集系数=结点聚集系数在所有点中求平均");
disp("由于ER网中任意两节点相连概率恒定，聚集系数≈P");

