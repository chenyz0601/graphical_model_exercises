function [F,B] = get_aggragated_energy(I,domain_f,domain_b)
    global nu lamb1 lamb2;
    v_f = min(abs(I-domain_f(1)),abs(I-domain_f(2)));
    v_b = min(abs(I-domain_b(1)),abs(I-domain_b(2)));
    F = nu+lamb1*v_f.^2;
    B = lamb2*v_b.^2;
end
