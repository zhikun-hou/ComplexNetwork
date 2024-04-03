% 用于计算Q函数中的E

function [E] = ModularityE(G,Community_idx)


    Community_list = unique(Community_idx);
    N_community = numel(Community_list);

    N_edge = numedges(G);

    A = adjacency(G);
    E = zeros(N_community,N_community);
    
    % 两两成对，遍历社区
    for i=1:N_community
        Community_i = Community_list(i);
        Node_i = find(Community_idx==Community_i);
        N_i = numel(Node_i);

        for j=i+1:N_community % 社团间的情形
            Community_j = Community_list(j);
            Node_j = find(Community_idx==Community_j);
            N_j = numel(Node_j);

            % 根据节点号取出它们的子邻接矩阵
            A_ij = A(Node_i,Node_j);
            A_ji = A(Node_j,Node_i);
            E_ij = (  sum(A_ij,"all")  ) / N_edge;
            E_ji = (  sum(A_ji,"all")  ) / N_edge;
            E(i,j) = E_ij / N_edge;
            E(j,i) = E_ji / N_edge;
        end
        
        % 社团内的情形
        E(i,i) = sum(A(Node_i,Node_i),"all")*0.5 / N_edge;

    end


end

