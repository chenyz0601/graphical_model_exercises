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
itermax = 10;
K = 5;

%% foreground
img_fg = img(x1:x2,y1:y2,:);
img_fg = reshape(img_fg,(x2+1-x1)*(y2+1-y1), 3);
<<<<<<< HEAD
[mu_fg, sigma_fg, pi_fg] = multi_gaussian(K, itermax, img_fg);
=======
[m, n] = size(img_fg);
gama_fg = zeros(m,5);
pi_fg = 0.2*ones(5,1);
mu_ulti = sum(img_fg)./m;
mu_fg = repmat(mu_ulti, 5, 1);
sigma_fg = zeros(3,3,5);
for i = 1:5
    sigma_fg(:,:,i) = eye(3); 
end

for iter = 1:itermax
    prob = prob_eval(img_fg, mu_fg, sigma_fg, pi_fg, 0);
    for k = 1:5
        % update gama
        gama_fg(:,k) = prob_eval(img_fg, mu_fg, sigma_fg, pi_fg, k)./prob;
        % gama_ulti is redundant
        gama_ulti = repmat(gama_fg(:,k),1,3);
        mu_fg(k,:) = sum(gama_ulti.*img_fg, 1)./sum(gama_fg(:,k));
        temp = img_fg-repmat(mu_fg(k,:), m, 1);
        temp1 = temp.*gama_ulti;
        sigma_fg(:,:,k) = temp1'*temp./sum(gama_fg(:,k));
    end
    for k = 1:5
        pi_fg(k) = sum(gama_fg(:,k))/sum(sum(gama_fg));
    end
end
>>>>>>> 295127549ee31a4d5d35d1371da9acb20dc30c27

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
