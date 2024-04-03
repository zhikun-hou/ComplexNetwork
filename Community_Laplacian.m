% 使用拉普拉斯矩阵的特征向量分割社团
% 假定G是无向图

function [Result] = Community_Laplacian(G)
    
    L = full(laplacian(G));
    [Eig_vec,Eig_val] = eig(L);
    Eig_val = diag(Eig_val);

    % 寻找大于0的第一个特征值，并锁定其对应的特征向量
    [Eig_val,Sort_idx] = sort(Eig_val);
    Eig_vec = Eig_vec(:,Sort_idx);
    target_idx = find(Eig_val>10e-3,1,"first"); % 避免浮点数误差
    X = Eig_vec(:,target_idx);
    
    % 计算紧密程度R
    N_node = numnodes(G);
    N_edge = numedges(G);
    R = zeros(N_node,N_node);
    for i=1:N_node
        for j=i+1:N_node
            R(i,j) = abs(X(i)-X(j));
            R(j,i) = R(i,j);
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

