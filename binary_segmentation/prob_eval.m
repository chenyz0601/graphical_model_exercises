function out = prob_eval(X, mu, sigma, pi, k)
    if k == 0
        [m , n] = size(X);
        out = zeros(m,1); 
        for i = 1:5
            out = out + pi(i).*mvnpdf(X, mu(i,:),sigma(:,:,i));
        end
    else
        out = pi(k).*mvnpdf(X, mu(k,:),sigma(:,:,k));
    end
end
