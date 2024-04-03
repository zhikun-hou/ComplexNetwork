% 对GN_benchmark网络进行社团划分，对应了【作业7】


% 四个社团，每个社团10个成员，社内0.9概率连接，社外0.1概率连接
G = GN_benchmark(4,10,0.9,0.1);


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