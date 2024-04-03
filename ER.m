% 根据不同的N值和P值生成ER随机网络
% 供ER_test使用的工具函数

% N：目标网络中的节点数
% P：任意两个节点间存在连边的概率
% 显然，ER随机网是无向图

function [G] = ER(N,P)

    A = logical(zeros(N));
    G = graph(A);
    
    for i=1:N
        for j=i+1:N
            if(rand<P)
                G = addedge(G,i,j);
            end
        end
    end
    
end
