function [mu, sigma , pi]= multi_gaussian(K, itermax, X)
[m, n] = size(X);
gama = zeros(m,K);
pi = 0.2*ones(K,1);
mu_ulti = sum(X)./m;
mu = repmat(mu_ulti, K, 1);
sigma = zeros(3,3,K);
for i = 1:K
    sigma(:,:,i) = eye(3); 
end

for iter = 1:itermax
    prob = prob_eval(X, mu, sigma, pi, 0);
    for k = 1:K
        gama(:,k) = prob_eval(X, mu, sigma, pi, k)./prob;
        mu(k,:) = gama(:,k)'*X./sum(gama(:,k));
        sigma(:,:,k) = X'*spdiags(gama(:,k),0,m,m)*X./sum(gama(:,k));
    end
    for k = 1:K
        pi(k) = sum(gama(:,k))/sum(sum(gama));
    end
end
end