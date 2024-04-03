% 网络上的SIR仿真
% 对应【作业8】

clear;
clc;
close all;

P_sick    = 0.1; % 普通个体以beta概率成为感染个体
P_recover = 0.4; % 感染个体以gamma概率成为免疫个体

SIR_init = []; % 设置不同的初始状态

S = 95;
I = 5;
R = 0;
N = S+I+R;
T = 100;

% 网络模拟 =================================================================

G0 = InitNetwork(S,I,R);
S0 = Stat(G0);
[Gs,Ns_1] = SimulateNetwork(G0,T,P_sick,P_recover);

% 绘制 =====================================================================

fig = figure("Name","SIR");
fig.WindowState = 'maximized';

for t=1:T
    subplot(2,2,1);
    plot(Ns_1);
    legend("普通个体","感染个体","免疫个体");
    title("网络模拟");
    xline(t);
    subplot(2,2,2);
    H = plot(Gs{t},'Layout','force');
    highlight(H,Gs{t}.Nodes.State=="I",'NodeColor','r');
    sgtitle("t="+t);
    drawnow;
    pause(0.1);
end


% =========================================================================

function [G] = InitNetwork(S,I,R)
    
    G = WS(I+S+R,10,0.1);
    
    state = [ repmat("S",S,1);repmat("I",I,1);repmat("R",R,1) ];
    state = shuffle(state);
    
    G.Nodes.State = state;

end

function [Gs,Ns] = SimulateNetwork(G,T,P_sick,P_recover)
    
    Gs = cell(T,1);
    Ns = zeros(T,3);

    % 一个健康人可能有多个病患邻居，感染概率随病患邻居的个数指数增长
    for t=1:T
        States = G.Nodes.State;
        NewStates = States;

        for n=1:numnodes(G)
            Self_type = States(n);
            
            if(Self_type=="S")
                NN_idx = neighbors(G,n);
                INN_idx = findnode(G,find(States(NN_idx)=="I"));
                INN_num = numel(INN_idx);
                if( rand < 1-(1-P_sick)^INN_num )
                    NewStates(n) = "I";
                end
            elseif(Self_type=="I" && rand<P_recover)
                NewStates(n) = "R";
            end
        end
        
        Ns(t,1) = sum(NewStates=="S");
        Ns(t,2) = sum(NewStates=="I");
        Ns(t,3) = sum(NewStates=="R");
        G.Nodes.State = NewStates;
        Gs{t} = G;
    end

end
