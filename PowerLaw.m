% 进行实证网络的幂律拟合
% 对应了【作业4】

% 数据来源：Facebook的friend list数据，显然是无向图
% https://snap.stanford.edu/data/egonets-Facebook.html

close all;
clear;
clc;

% 读取文件 =================================================================

% % 【首次加载原始数据】
% lines = readlines("facebook_combined.txt");
% G = graph(logical([]),{});
% for i=1:numel(lines)-1
%     % 读取行 ==============
%     line = lines(i);
%     edge = split(line);
%     node_from = edge(1);
%     node_to   = edge(2);
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

% 【直接加载已经预处理好的数据】
load("PowerLaw.mat");

% 幂律拟合 =================================================================

% 幂律分布：随机抽取一个节点，其度为K的概率正比于K^gamma

% 计算度分布和累计度分布
D = degree(G);
D_count = tabulate(D);
D_list = D_count(:,1);
D_pdf = D_count(:,3) ./ 100;
D_cdf = cumsum(D_pdf,'reverse');

% 进行非线性拟合
PowerFunc = @(Coeff,D) Coeff(1)*D.^Coeff(2)+Coeff(3);
mdl = fitnlm(D_list,D_pdf,PowerFunc,[0,0,0]);
coef = mdl.Coefficients.Estimate;

% 绘制
figure("Name","幂律拟合");
sgtitle("P="+coef(1)+"*K^{"+coef(2)+"}+"+coef(3));

subplot(2,2,1);
scatter(D_list,D_pdf,'.');
hold on;
plot(D_list,PowerFunc(coef,D_list));
xlabel("节点度K");
ylabel("概率P");
legend("幂律分布","拟合曲线");

subplot(2,2,3);
loglog(D_list,D_pdf,'x');
xlabel("节点度K");
ylabel("度分布");
title("度分布的尾部服从幂律分布");

subplot(2,2,4);
loglog(D_list,D_cdf,'x');
xlabel("节点度K");
ylabel("累积度分布");
title("累积度分布");
