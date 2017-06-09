img = imread('banana3.png');
% box_bound_x = [x1, x2];
% box_bound_y = [y1, y2];
img = im2double(img);
[M, N, C] = size(img);
figure(1);
imshow(img);
x1 = 218;
x2 = 475;
y1 = 278;
y2 = 358;
itermax = 200;
K = 5;

%% foreground
img_fg = img(x1:x2,y1:y2,:);
img_fg = reshape(img_fg,(x2+1-x1)*(y2+1-y1), 3);
[mu_fg, sigma_fg, pi_fg] = multi_gaussian(K, itermax, img_fg);
%% background
img_bg1 = img(:,1:x1-1,:);
img_bg1 = reshape(img_bg1,(x1-1)*480, 3);
img_bg2 = img(:,x2:end,:);
img_bg2 = reshape(img_bg2,(640-x2+1)*480, 3);
img_bg3 = img(1:y1,x1:x2,:);
img_bg3 = reshape(img_bg3,(x2+1-x1)*y1, 3);
img_bg4 = img(y2:end,x1:x2,:);
img_bg4 = reshape(img_bg4,(x2+1-x1)*(480-y2+1), 3);
img_bg = [img_bg1;img_bg2;img_bg3;img_bg4];
[mu_bg, sigma_bg, pi_bg] = multi_gaussian(K, itermax, img_bg);
 
%% seperate background
img_util = reshape(img, 480*640, 3);
prob_bg = prob_eval(img_util, mu_bg, sigma_bg, pi_bg, 0);
prob_fg = prob_eval(img_util, mu_fg, sigma_fg, pi_fg, 0);
prob_bg = prob_bg/max(prob_bg);
prob_fg = prob_fg/max(prob_fg);
img_binary = prob_bg<prob_fg;
img_result = reshape(img_binary, 480, 640);
figure(2);
imshow(img_result);

%% maxflow
% construct graph
for i = 1:10
    w = 0.01*i;
    mask = 2:M*N+1;
    mask = reshape(mask, M, N);
    t_mask = zeros(M, N, 5);
    t_mask(:,:,1) = circshift(mask,[1,0]);
    t_mask(:,:,2) = circshift(mask,[-1,0]);
    t_mask(:,:,3) = circshift(mask,[0,1]);
    t_mask(:,:,4) = circshift(mask,[0,-1]);
    t_mask(:,:,5) = (M*N+2)*ones(M,N);
    t_mask_util = reshape(t_mask,M*N,5);
    t_mask_util = t_mask_util';
    t2 = t_mask_util(:);
    t1 = mask(:);
    s1 = ones(M*N,1);
    s2_util = repmat(t1',5,1);
    s2 = s2_util(:);
    t = [t1;t2];
    s = [s1;s2];
    w1 = -log(prob_fg);
    mask_w = reshape(-log(prob_bg),M,N);
    in_w = w*ones(size(t_mask));
    in_w(:,:,5) = mask_w;
    in_w_util = reshape(in_w,M*N,5);
    in_w_util = in_w_util';
    w2 = in_w_util(:);
    weights = [w1;w2];
    G = digraph(s,t,weights);
    [~,~,cut_s,~] = maxflow(G,1,M*N+2);
    cut_s = cut_s(2:end);
    cut_s = cut_s-1;
    seg_mask = ones(M,N);
    seg_util = reshape(seg_mask,M*N,1);
    seg_util(cut_s)=0;
    seg_mask = reshape(seg_util,M,N);
    figure(i+2);
    imshow(seg_mask);
end

%% try with no pairing energy
% mmask = 2:M*N+1;
% tt = [ones(M*N,1);mmask'];
% ss = [mmask';(M*N+2)*ones(M*N,1)];
% ww = [-log(prob_bg);-log(prob_fg)];
% gg = digraph(tt,ss,ww);
% [mf,~,cut_s,cut_t] = maxflow(gg,1,M*N+2);
% cut_s = cut_s(2:end);
% cut_s = cut_s-1;e Boykov–
Kolmogorov
% seg_mask = ones(M,N);
% seg_util = reshape(seg_mask,M*N,1);
% seg_util(cut_s)=0;
% seg_mask = reshape(seg_util,M,N);
% figure(4);
% imshow(seg_mask);