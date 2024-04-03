% 根据不同的N值和K值生成WS小世界网络
% 供WS_test使用的工具函数

% N：目标网络中的节点数
% K：第一步的环状规则网络中，与相邻的K个节点存在连接（必须为偶数）
% P：随机重连的概率

function [G] = WS(N,K,P)

    if(mod(K,2)==1)
        error("K必须为偶数");
    elseif(K<2)
        error("K必须大于等于2");
    end

    % 第一步：生成一个环状网络，并且与左右各K/2个节点相连
    K = K/2;
    A = logical(zeros(N));
    line = false(1,N);
    line(1,2:1+K) = true;
    line(1,N-K+1:N) = true;
    for i=1:N
        A(i,:) = line;
        line = circshift(line,1);
    end

    % 第二步：随机重连（不能有自环和重边）
    for i=1:N
        for j=i+1:N
            % 无边，不用管
            if(A(i,j)==false)
                continue;
            end
            % 随机判定失败，不重连
            if(rand>P)
                continue;
            end
            % 随机选择一个无边节点连接
            candidate = find(A(i,:)==false); % 排除重边
            candidate = setdiff(candidate,i); % 排除自环
            choice = unidrnd(numel(candidate)); % 均匀采样
            k = candidate(choice);
            A(i,k) = true;
            % 不要忘记重连后需要断开原边
            A(i,j) = false;
            % 无向图，需要处理对称位置
            A(j,i) = false;
            A(k,i) = true;
        end
    end

    % 使用邻接矩阵构造图
    G = graph(A);

end