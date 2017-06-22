function out = pair_energy(yi,yj,xi,xj)
    if yi == yj
        out = 0;
    else
        out = exp(-0.5*norm(xi-xj)^2);
    end
end