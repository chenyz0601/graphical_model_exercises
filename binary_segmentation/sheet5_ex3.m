img = imread('banana3.png');
% box_bound_x = [x1, x2];
% box_bound_y = [y1, y2];
img = im2double(img);
[M,N, C] = size(img);
figure(1);
imshow(img);
x1 = 218;
x2 = 475;
y1 = 278;
y2 = 358;
itermax = 30;
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
img_binary = prob_bg<prob_fg;
img_result = reshape(img_binary, 480, 640);
figure(2);
imshow(img_result);

%% maxflow
% construct graph
M=3;
N=3;
mask = 2:M*N+1;
mask = reshape(mask, M, N);
in_mask = zeros(M-2, N-2, 5);
in_mask(:,:,1) = mask(1:M-2,2:N-1);
in_mask(:,:,2) = mask(3:M,2:N-1);
in_mask(:,:,3) = mask(2:M-1,1:N-2);
in_mask(:,:,4) = mask(2:M-1,3:N);
in_mask(:,:,5) = (M*N+2)*ones(M-2,N-2);
in_mask_util = reshape(in_mask,[(M-2)*(N-2),5]);
in_mask_util = in_mask_util';
t2 = in_mask_util(:);
crop_mask = mask(2:M-1,2:N-1);
t1 = crop_mask(:);
s2_util = repmat(t1,1,5);
s2_util = s2_util';
s2 = s2_util(:);
s1 = ones(M*N,1);
boundary = [mask(1,:) mask(M,:) mask(2:M-1,1)' mask(2:M-1,N)'];
s = [s1; s2; boundary'];
t = [t1; boundary'; t2; (M*N+2)*ones(size(boundary))'];
weights = rand(size(t));
G = digraph(s,t,weights);
plot(G,'EdgeLabel',G.Edges.Weight,'Layout','layered');