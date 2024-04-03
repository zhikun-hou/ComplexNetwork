% 在Matlab中可视化恒河猴网络，并计算其统计性质
% 刷毛次数，无向加权图
% 对应了【作业6】【作业7】

clear;
clc;
close all;

% 读取文件 =================================================================
lines = readlines("恒猴数据.txt");
% 构造图 ===================================================================
G = graph([],{});

for i=1:numel(lines)-1
    % 读取行 ==============
    line = lines(i);
    edge = split(line);
    node_from = edge(1);
    node_to   = edge(2);
    weight = double(edge(3));

    % 增加节点 ============
    if(findnode(G,node_from)==0)
        G = addnode(G,node_from);
    end
    if(findnode(G,node_to)==0)
        G = addnode(G,node_to);
    end
    % 连边 ===============
    if(findedge(G,node_from,node_to)==0)
        G = addedge(G,node_from,node_to,weight);
    end
end

% 统计性质 =================================================================
% Stat函数是基于无向图写的，这里需要单独写一个有向图的版本

S = Stat(G);
VisualizeStat(G,S);

% 社团结构划分 =============================================================
 
figure("Name","基于边介数的GN算法");
Result_gn = Community_GN(G);
DrawCommunity(G,Result_gn);

figure("Name","Newman贪婪算法");
Result_newman = Community_Newman(G);
DrawCommunity(G,Result_newman);

figure("Name","基于随机游走的层次聚类");
Result_rw = Community_RandomWalk(G,3);
DrawCommunity(G,Result_rw);

figure("Name","基于拉普拉斯矩阵的谱聚类");
Result_lap = Community_Laplacian(G);
DrawCommunity(G,Result_lap);

