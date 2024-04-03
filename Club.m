% 在Matlab中可视化空手道俱乐部，并计算基本统计性质
% 对应了【作业1】和【作业5】


% 读取文件 =================================================================
lines = readlines("空手道俱乐部.txt");
% 构造图 ===================================================================
G = graph(logical([]),{});

for i=1:numel(lines)-1
    % 读取行 ==============
    line = lines(i);
    edge = split(line);
    node_from = edge(1);
    node_to   = edge(2);

    % 增加节点 ============
    if(findnode(G,node_from)==0)
        G = addnode(G,node_from);
    end
    if(findnode(G,node_to)==0)
        G = addnode(G,node_to);
    end
    % 连边 ===============
    % 人际关系应当是无向图，但是数据中给出的是有向边
    % 因此需要稍加判别
    if(findedge(G,node_from,node_to)==0)
        G = addedge(G,node_from,node_to);
    end
end


% 统计性质 =================================================================

S = Stat(G);
VisualizeStat(G,S);
disp("空手道俱乐部是异配网络")
