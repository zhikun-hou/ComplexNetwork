% 使用随机游走算法分割社团
% 假定G是无向图

function [Result] = Community_RandomWalk(G,t)
    
    A = adjacency(G);
    P = A^t; % N步扩散

    D = degree(G)';
    N_node = numnodes(G);
    N_edge = numedges(G);

    R = zeros(N_node,N_node); % 计算距离矩阵
    for i=1:N_node
        for j=1:N_node
            R(i,j) = sqrt(   sum(  (P(i,:)-P(j,:)).^2./D  )   );
        end
    end
    
    % 构建层次聚类树
    Tree = linkage(R);
    for i=1:N_node
        Community_idx = cluster(Tree,"MaxClust",i);
        Q(i) = ModularityQ(G,Community_idx);
        C{i} = Community_idx;
    end
    
    [Q_max,Q_idx] = max(Q);
    Community_idx = C{Q_idx};


    to_remove = [];
    for i=1:N_edge
        [Node_from,Node_to] = findedge(G,i);
        if(Community_idx(Node_from)==Community_idx(Node_to))
            continue;
        else
            to_remove(end+1) = i;
        end
    end
    G_community = rmedge(G,to_remove);


    Result = {};
    Result.Idx = Community_idx;
    Result.G = G_community;
    Result.Q = Q;
    Result.Q_idx = Q_idx;

end

