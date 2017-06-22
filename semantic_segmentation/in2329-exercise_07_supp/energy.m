function out = energy(img, unary, labels, w)
% img:N*3, unary:N*21, labels:m*n
% out:energy
    [M,N] = size(labels);
    util = [1,1;1,-1;-1,1;-1,-1];
    out = 0;
    idx = sub2ind(size(unary),(1:M*N),labels(:)');
    out = out + sum(unary(idx));
    for i = 1:M
        for j = 1:N
            for e = 1:4
                index = [min(M,max(1,i+util(e,1))),min(N,max(1,i+util(e,2)))];
                out = out + w*pair_energy(labels(i,j),labels(index),img((i-1)*N+j,:),img((index(1)-1)*N+index(2)));
            end
        end
    end
end