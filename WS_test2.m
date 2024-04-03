% 对应了【作业3】

close all;
clear;
clc;

% 生成WS小世界网络 ===========================

N = 1000;
K = 4;
P = 0.6.^[0:1:20];
for i=1:numel(P)
    G{i} = WS(N,K,P(i));
    S{i} = SimpleStat(G{i});
end

G0 = WS(N,K,0);
S0 = SimpleStat(G0);

S = [S{:}];

% 对小世界特性进行可视化 ==================


C_net  = [S.C_net];   % 平均聚集系数
L_mean = [S.L_mean]; % 平均最短路径

figure("Name","WS");
semilogx(P,C_net./S0.C_net);
hold on;
semilogx(P,L_mean./S0.L_mean);
legend("平均集聚系数","平均最短路径");
title("小世界特性");

% 简化版的Stat函数，避免计算其它特征浪费时间
function [S] = SimpleStat(G)
    
    N_node = numnodes(G);
    D_node = degree(G);
    
    A = adjacency(G);

    % 节点的聚集系数=排除掉自己后，邻居之间实际边数/最大可能边数
    C_node = zeros(1,N_node);
    for i=1:N_node
        k = D_node(i);
        
        if(k==0 || k==1) % 没有任何邻居的孤立节点，或者只有一个邻居
            C_node(i) = 0;
        else
            nn = neighbors(G,i); % 邻居列表
            
            A_sub = A(nn,nn);
            edge_count = sum(A_sub,"all");
            
            edge_max = k*(k-1); % 最大可能边数
            
            C_node(i) = edge_count / edge_max;
        end
    end

    % 网络的集聚系数=所有节点集聚系数的平均
    C_net = sum(C_node,"all") / N_node;

    % 所有节点两两之间的最短距离
    L_node = distances(G);
    % 网络的平均路径长度=任意两个节点最短距离的平均值
    L_mean = sum(L_node,"all") / (N_node*(N_node-1));

    S = {};
    S.C_net = C_net;
    S.L_mean = L_mean;
end