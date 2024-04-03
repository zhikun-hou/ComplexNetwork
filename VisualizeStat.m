% 输入计算过的统计信息，将其可视化

function [] = VisualizeStat(G,Stat)

    
    figure("Name","VisualizeStat");

    subplot(2,3,1);
    P = plot(G,'Layout','force');
    % 标记边介数
    labeledge(P,1:Stat.N_edge,Stat.B_edge);
    % 标记点介数
    labelnode(P,1:Stat.N_node,Stat.B_node);
    % 聚集系数使用节点大小来表示
    P.MarkerSize = 1 + rescale(Stat.C_node)*3;
    title("标签=边/点介数、大小=点聚集系数");
    
    subplot(2,3,2);    
    yyaxis left;
    stem(Stat.D_list,Stat.D_pdf);
    hold on;
    yyaxis left;
    ksdensity(Stat.D_node);
    hold on;
    ylabel("出现概率");
    yyaxis right;
    stem(Stat.D_list,Stat.D_cdf);
    ylabel("累积出现概率");
    legend("度分布","度分布拟合","累积度分布");
    xlabel("节点的度");
    title("度分布");


    subplot(2,3,3);
    plot(Stat.D_list,Stat.D_corrfunc,'o-');
    xlabel("节点的度");
    ylabel("邻居平均度");
    title("度相关函数");

    subplot(2,3,4);
    heatmap(Stat.P_edge);
    title("e_{jk}");


    subplot(2,3,6);
    plot(Stat.R_club,'o-');
    ylabel("实际边数/最大可能边数");
    xlabel("前r个度最高的节点");
    title("富人俱乐部");



    % ===================================

    disp("【统计信息】===================");
    disp("【总结点数】N_node="+Stat.N_node);
    disp("【平均度】D_mean="+Stat.D_mean);

    disp("【总边数】N_edge="+Stat.N_edge);
    disp("【最大边数】N_edge="+Stat.N_maxedge);
    disp("【网络密度】Rho="+Stat.Rho);

    disp("【网络聚集系数】C_net="+Stat.C_net);
    disp("【网络平均距离】L_mean="+Stat.L_mean);
    disp("【网络直径】L_max="+Stat.L_max);

    disp("【同配系数】D_assor="+Stat.D_assor);
    
end

