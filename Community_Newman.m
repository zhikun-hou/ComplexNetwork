% 使用Newman贪心算法分割社团
% 假定G是无向图

function [Result] = Community_Newman(G)
    
    A = adjacency(G);
    N_node = numnodes(G);
    N_edge = numedges(G);

    Community_idx = 1:N_node;
    Community_list = unique(Community_idx);
    N_community = numel(Community_list);

    count = 1;
    
    while(N_community>1)
        
        E = ModularityE(G,Community_idx);
        
        % 根据公式计算delta Q
        A_i = sum(E,2);
        A_j = sum(E,1);
        Q_delta = E+E' - 2*A_i.*A_j;
        Q_delta(logical(eye(size(E)))) = -inf; % 防止死循环，只允许合并两个不同的社团

        % 贪心选择最大的Q_delta合并社团
        [Q_max,Q_idx] = max(Q_delta,[],"all");
        [i,j] = ind2sub([N_community,N_community],Q_idx);
        
        
        Community_idx(Community_idx==Community_list(i)) = Community_list(j);
        
        % 对合并后的图进行保存
        C{count} = Community_idx;
        Q(count) = ModularityQ(G,Community_idx);

        % 迭代
        Community_list = unique(Community_idx);
        N_community = numel(Community_list);
        count = count+1;
    end

    [Q_peak,Q_idx] = max(Q);
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

