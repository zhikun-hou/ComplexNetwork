% 给定I个社团，每个社团含有g个节点
% 社团内的节点，连边概率为P_in，不同社团连接概率P_out
% 对应【作业7】

function [G] = GN_benchmark(I,g,P_in,P_out)

    % 使用分块对角矩阵构造社内连接
    for i=1:I
        P = rand(g,g);
        A_ii = logical(P<P_in);
        A_ii = A_ii - diag(diag(A_ii)); % 对角置0，消除自环
        A_ii = triu(A_ii); % 取上三角
        A_ii = A_ii + A_ii'; % 构造对称下三角

        A{i} = A_ii;
    end
    
    A = blkdiag(A{:});

    for i=1:I  
        for j=i+1:I
            P = rand(g,g);
            A_ij = logical(P<P_out);
            rows = (i-1)*g+1 : 1 : i*g;
            cols = (j-1)*g+1 : 1 : j*g;
            A(rows,cols) = A_ij;
            A(cols,rows) = A_ij';
        end
    end

    G = graph(A);
    
end