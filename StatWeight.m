% 输入一张【无向有权图】，计算其统计信息

function [Result] = StatWeight(G)
    
    % 基本统计量 =============================
    N_edge = numedges(G); % 总边数
    N_node = numnodes(G); % 总节点数
    
    N_maxedge = 0.5 * N_node*(N_node-1); % 最大可能边数
    Rho = N_edge / N_maxedge; % 网络密度

    D_node = degree(G);

    A = adjacency(G);
    W = adjacency(G,'weighted');
    W_node = sum(W,1); % 点强度
    W_edge = G.Edges.Weight;

    W_count = tabulate(W_node);
    W_list  = W_count(:,1);
    W_len   = numel(W_list);
    W_prob  = W_count(:,3);
    W_count = W_count(:,2);
    W_pdf   = W_prob ./ 100; % 点强度分布
    W_cdf   = cumsum(W_pdf,'reverse');
    W_mean  = W_list' * W_pdf; % 平均点强度


    % 基于度的统计量 ========================

    % 度相关函数
    % 1. 对于每个节点计算最近邻平均度值，即nnmd=邻居的度之和/邻居个数
    % 2. 对于所有自身度为k的节点，计算nnmd的均值
    % 3. 以k为横轴，d的均值为纵轴绘制曲线，增函数说明是同配网络，减函数说明是异配网络
%     D_corrfunc = zeros(1,numel(D_list));

%     for i=1:numel(D_list)
%         k = D_list(i);
%         k_nodes = find(D_node==k);    % 所有度为k的节点，它们的索引值
%         k_nums  = numel(k_nodes); % 度为k的节点共计有多少个
%         k_nn    = k_nums*k;     % 度为k的这些节点，共计有多少个邻居
%         k_nnd   = 0; % 邻居的度，累积起来是多少
% 
%         if(k_nn==0)
%             continue;
%         end
% 
%         for j=1:k_nums % 第j个度为k的节点
%             nn_nodes = neighbors(G,k_nodes(j)); % 邻居列表
%             for m=1:k  % j节点的第m个邻居
%                 k_nnd = k_nnd + degree(G,nn_nodes(m));
%             end
%         end
% 
%         D_corrfunc(i) = k_nnd / (k_nn*k_nums);
%     end
    

    % 书中的相关系数，正确的叫法是同配系数Assoativity Coefficient
    % 公式来自于NetworkX中的源代码中的_numeric_ac，所以重复计算了Var_i和Var_j
    
    [Edge_from,Edge_to] = findedge(G);
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


    % 富人俱乐部
    % 网络中前r个度最大的节点，他们之间的边数与这r个节点最大可能边数的比值
    R_club = zeros(1,N_node);
    [~,R_idx] = sort(D_node,1,'descend');
    G_sort = reordernodes(G,R_idx); % 将所有节点按照度从大到小排列
    for r=1:N_node
        % 提取子图
        G_sub = subgraph(G_sort,1:r);
        % 计算Phi
        edge_max   = 0.5*r*(r-1);
        edge_count = numedges(G_sub);
        R_club(r) = edge_count/edge_max;
    end

    % 基于拓扑结构的统计量 ====================
    
    % 加权聚集系数：由于有好几个版本，C_net就不写了
    % 基于Barrat的定义
    C_barrat = zeros(1,N_node);
    for i=1:N_node
        d = D_node(i);
        
        if(d==0 || d==1) % 没有任何邻居的孤立节点，或者只有一个邻居
            C_barrat(i) = 0;
        else
            nn = neighbors(G,i); % 邻居列表
            N_nn = numel(nn);
            C = 0;
            for j=1:N_nn
                for k=1:N_nn
                    C = C + ( W(i,nn(j))+W(i,nn(k)) ) * A(nn(j),nn(k));
                end
            end
            C_barrat(i) = C/(2*(d-1)*W_node(i));
        end
    end
    % 基于Petter Holme的定义
    C_holme = zeros(1,N_node);
    for i=1:N_node
        nn = neighbors(G,i); % 邻居列表
        N_nn = numel(nn);
        C_upper = 0;
        C_lower = zeros(N_node,N_nn);
        for j=1:N_nn
            C_temp = 0;
            for k=1:N_nn
                C_lower = C_lower + ( W(i,nn(j))+W(nn(k),i) );
                C_temp  = C_temp + ( W(i,nn(j))+W(nn(k),i)+W(nn(j),nn(k)) );
            end
            C_lower(i,j) = W(i,nn(j)) * C_temp;
        end
        C_holme(i) = C_upper / max(C_lower,[],"all");
    end

    
    % 所有节点两两之间的最短距离
    L_node = distances(G);
    % 最短路径
    L_mean = sum(L_node,"all") / (N_node*(N_node-1));
    % 网络直径=任意两点间最短距离的最大值
    L_max  = max(L_node,[],"all");

    % 点介数=穿过该节点的最短路径的条数（自己不能作为端点）
    B_node = zeros(1,N_node);
    % 边介数=穿过该边的最短路径的条数
    B_edge = zeros(1,N_edge);
   
    for i=1:N_node
        for j=i+1:N_node
            path = shortestpath(G,i,j);
            % 边介数
            for m=2:numel(path)
                edge_idx = findedge(G,path(m-1),path(m));
                B_edge(edge_idx) = B_edge(edge_idx) + 1;
            end
            % 点介数，途径的点+1
            path = path(2:end-1); % 去除两个端点
            B_node(path) = B_node(path)+1;
        end
    end

    % 输出 ===================================

    Result = {};
    Result.N_edge = N_edge;
    Result.N_node = N_node;
    Result.N_maxedge = N_maxedge;
    Result.Rho = Rho;


%      Result.D_corrfunc = D_corrfunc;
    Result.D_assor = D_assor;
    Result.P_edge  = P_edge;

    Result.R_club = R_club;

    Result.C_barrat = C_barrat;
    Result.C_holme  = C_holme;

    Result.L_node = L_node;
    Result.L_mean = L_mean;
    Result.L_max  = L_max;

    Result.B_node = B_node;
    Result.B_edge = B_edge;


    Result.W = W;
    Result.W_edge = W_edge;
    Result.W_node = W_edge;
    Result.W_list = W_list;
    Result.W_count = W_count;
    Result.W_pdf   = W_pdf;
    Result.W_cdf   = W_cdf;
    Result.W_mean  = W_mean;


end

