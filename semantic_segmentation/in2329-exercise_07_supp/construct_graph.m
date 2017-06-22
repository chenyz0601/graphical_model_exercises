function alpha_graph = construct_graph(alpha,img,unary,labels)
    [N, ] = size(img);
    [m,n] = size(labels);
    neighbor_util = [1,1;1,-1;-1,1;-1,-1];
    alpha_graph = digraph();
    for node = 1:N
        current_node = node+1;
        i = 1+floor(node/n);
        j = node-n*floor(node/n);
        if labels(i,j) ~= alpha
            c_alpha_i = unary(node,labels(i,j));
            c_i_alpha = unary(node,alpha);
            for e = 1:4
                n_i = min(m,max(1,i+neighbor_util(e,1)));
                n_j = min(n,max(1,i+neighbor_util(e,1)));
                if n_i~=i || n_j~=j
                    if labels(n_i,n_j) ~= alpha
                        count_util = (n_i-1)*n+n_j;
                        c_alpha_i = c_alpha_i + pair_energy(labels(i,j),alpha,img(i,j),img(n_i,n_j));
                        c_i_alpha = c_i_alpha + pair_energy(labels(n_i,n_j),alpha,img(node),img(count_util))-pair_energy(labels(n_i,n_j),labels(i,j),img(count_util),img(node));
                        c_i_j = pair_energy(alpha,labels(count_util),img(node),img(count_util))+pair_energy(alpha,labels(node),img(node),img(count_util))-pair_energy(labels(count_util),labels(node),img(node),img(count_util));
                        alpha_graph = addedge(alpha_graph,1+node,1+count_util,c_i_j);
                    else
                        c_alpha_i = c_alpha_i + pair_energy(labels(i,j),alpha,img(node),img(count_util))+pair_energy(alpha,labels(i,j),img(count_util),img(node));
                    end
                end
            end
            alpha_graph = addedge(alpha_graph,1,current_node,c_alpha_i);
            alpha_graph = addedge(alpha_graph,current_node,N+1,c_i_alpha);
        end
    end
end