function show_img(cut_s)
    global M N;
    mask = zeros(M,N);
    mask = mask(:);
    mask(cut_s) = 1;
    mask = reshape(mask,[M,N]);
    imshow(mask);
end