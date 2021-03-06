global nu mu lamb1 lamb2 M N;
nu = 0.1;
mu = 1;
lamb1 = 0.0001;
lamb2 = 0.0001;

domain_f = [79,83];
domain_b = [166,169];
img = imread('garden.png');
img_gray = rgb2gray(img);
[M,N] = size(img_gray);
img = 255*im2double(img_gray);
img_util = img(:);
[F,B] = get_aggragated_energy(img_util,domain_f,domain_b);
[value,~] = do_mincut(F,B);

priority_queue = PQ2;
priority_queue.push([domain_f,domain_b],value);

while 1
    temp = priority_queue.pop
    cur_domain_f = temp(1:2);
    cur_domain_b = temp(3:4);
    if abs(cur_domain_f(1)-cur_domain_f(2))<=1 && abs(cur_domain_b(1)-cur_domain_b(2))<=1
        break;
    end
    mid_f = floor((cur_domain_f(1)+cur_domain_f(2))/2);
    mid_b = floor((cur_domain_b(1)+cur_domain_b(2))/2);
    domain_util = [cur_domain_f(1),mid_f,cur_domain_b(1),mid_b;
        cur_domain_f(1),mid_f,mid_b,cur_domain_b(2);
        mid_f,cur_domain_f(2),cur_domain_b(1),mid_b;
        mid_f,cur_domain_f(2),mid_b,cur_domain_b(2)];
    for i = 1:4
        [F,B] = get_aggragated_energy(img_util,domain_util(i,1:2),domain_util(i,3:4));
        [value,~] = do_mincut(F,B);
        priority_queue.push(domain_util(i,:),value);
    end
end
[F,B] = get_aggragated_energy(img_util,cur_domain_f,cur_domain_b);
[~,cut_s] = do_mincut(F,B);
show_img(cut_s);


