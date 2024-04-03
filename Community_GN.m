% 使用GN算法分割社团

function [Result] = Community_GN(G)

    % 模块度函数的Q值
    Q = zeros(1,numedges(G));
    % 暂存各个子图
    G_cache = cell(1,numedges(G));
    % 用于迭代的临时图
    G_temp = G;

    % 迭代断开边介数最大的边
    i = 1;
    while(numedges(G_temp)>0)
        % 计算边介数
        B_edge = Betweeness_edge(G_temp);
        % 移除介数最大的边
        [B_max,B_idx] = max(B_edge);
        G_temp = rmedge(G_temp,B_idx);
        % 暂存子图
        G_cache{i} = G_temp;
        % 计算Q
        Community_idx = conncomp(G_temp); % 每个连通子集相当于一个社区
        Q(i) = ModularityQ(G,Community_idx);

        i = i+1;
    end
    % 分割社团
    [Q_peak,Q_idx] = max(Q);
    G_community = G_cache{Q_idx};
    Community_idx = conncomp(G_community);


    Result = {};
    Result.Idx = Community_idx;
    Result.G = G_community;
    Result.Q = Q;
    Result.Q_idx = Q_idx;
    Result.Gs = G_cache;


end


function [B_edge] = Betweeness_edge(G)
    
    B_edge = zeros(1,numedges(G));

    for i=1:numnodes(G)
        for j=i+1:numnodes(G)
            path = shortestpath(G,i,j);
            % 边介数，途径的边+1
            for m=2:numel(path)
                edge_idx = findedge(G,path(m-1),path(m));
                B_edge(edge_idx) = B_edge(edge_idx)+1;
            end
        end
    end

end
