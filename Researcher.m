% 在Matlab中可视化经济物理学家网络，并计算其度度匹配性
% 对应了【作业5】

clear;
clc;
close all;

% 读取文件 =================================================================

% % 【首次加载】
% lines = readlines("经济物理学（文章-作者编号）.txt");
% G = digraph(logical([]),{});
% for i=1:numel(lines)-1
%     % 读取行 ==============
%     line = lines(i);
%     edge = split(line);
%     node_to = "Paper_"+edge(1);
%     node_from   = "Author_"+edge(2);
% 
%     % 增加节点 ============
%     if(findnode(G,node_from)==0)
%         G = addnode(G,node_from);
%     end
%     if(findnode(G,node_to)==0)
%         G = addnode(G,node_to);
%     end
%     % 连边 ===============
%     if(findedge(G,node_from,node_to)==0)
%         G = addedge(G,node_from,node_to);
%     end
% end
% 
% % 通过投影变成只有作者的合作网络，即：变成一个无向图
% G_author = graph(logical([]),{});
% Name_node = string(G.Nodes.Name);
% Idx_author = Name_node.startsWith("Author");
% Name_author = Name_node(Idx_author);
% G_author = addnode(G_author,Name_author);
% 
% for i=1:numnodes(G_author)
%     Author_self = Name_author(i);
%     Paper_join = successors(G,Author_self);
%     for j=1:numel(Paper_join)
%         Author_friends = setdiff(predecessors(G,Paper_join(j)),Author_self);
%         for k=1:numel(Author_friends)
%             if(findedge(G_author,Author_self,Author_friends(k))==0) % 避免重复边
%                 G_author = addedge(G_author,Author_self,Author_friends(k));
%             end
%         end
%     end
% end

% 【读取已预处理的图】
load("Researcher.mat");

% 绘图 =====================================================================

figure("Name","经济物理学网络");
plot(G);
title("作者->文章");

figure("Name","学者合作网络");
plot(G_author);
title("作者合作关系");



D_node = degree(G_author);
D_count = tabulate(D_node);  % 三列：度、度对应节点的数量、度出现的百分比频率
D_list  = D_count(:,1);
D_len  = numel(D_list); % 度列表的长度，不等于度的种类数


% 为什么networkx的算法会在对角线有自环啊？而且数量还是我的

[Edge_from,Edge_to] = findedge(G_author);
D_edge(:,1) = D_node(Edge_from); % 边对应的两个节点各自的度
D_edge(:,2) = D_node(Edge_to);
P_edge = zeros(D_len,D_len); % 度的联合分布，即选择一条无向边，端点为ij或ji的概率
for i=1:D_len
    for j=i+1:D_len
        % 无向图，对称处理
        P_edge(i,j) = sum(D_edge(:,1)==D_list(i) & D_edge(:,2)==D_list(j) | D_edge(:,1)==D_list(j) & D_edge(:,2)==D_list(i));
        P_edge(j,i) = P_edge(i,j);
    end
    % 无向图的上下三角相当于正着看一次，反着看一次，因此对角线需要乘二
    P_edge(i,i) = 2 * sum(D_edge(:,1)==D_list(i) & D_edge(:,2)==D_list(i));
end
P_edge = P_edge ./ sum(P_edge,"all");

Q_i = sum(P_edge,2);
Q_j = sum(P_edge,1);

[j_list,i_list] = meshgrid(D_list,D_list);
Var_i  = sum(Q_i  .* D_list.^2) - sum(Q_i  .* D_list)^2;
Var_j  = sum(Q_j' .* D_list.^2) - sum(Q_j' .* D_list)^2;
Sigma2 = sqrt(Var_i * Var_j);
D_assor = sum(i_list .* j_list .* (P_edge - Q_i.*Q_j) ,"all") / Sigma2;

disp("同配系数r="+D_assor);
disp("讲义里的python演示代码只取了合作者网络中的最大连通子集，因此得到的结果不同。换成整个网络的话结果是一样的。");
