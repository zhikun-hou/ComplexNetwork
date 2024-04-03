% 绘制社团划分的结果

function [] = DrawCommunity(G_raw,Result)


    Community_list = unique(Result.Idx);

    subplot(2,2,1);
    plot(G_raw,'layout','force');
    subplot(2,2,2);
    plot(Result.G,'layout','force');
    subplot(2,2,3);
    h = plot(G_raw,'layout','force');
    for i=1:numel(Community_list)
        highlight(h,find(Result.Idx==i),'NodeColor',rand(1,3));
    end

    subplot(2,2,4);
    plot(Result.Q);
    xline(Result.Q_idx);
    
end

