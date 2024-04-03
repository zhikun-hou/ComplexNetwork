
function [Q] = ModularityQ(G,Community_idx)


    E = ModularityE(G,Community_idx);

    Q = trace(E) - sum(E*E,"all");

end

