clear all
close all
tic
im = imread('01657a.tif');

[h, w] = size(im);
h3 = round(h/3); % the height of one image

b = im(1:h3, :);
g = im(h3+1:2*h3, :);
r = im(2*h3:h, :);

% scale down images for faster processing
scale = 0.125;
th = 50; % Half the size of the area thats being compared

% Other setting for larger images
if w < 1500
    scale = 1;
    th = 25; % Half the size of the area thats being compared
end

bs = imresize(b, scale);
gs = imresize(g, scale);
rs = imresize(r, scale);

% detects edges
edge_b = edge(bs, 'canny', 0.1);
edge_g = edge(gs, 'canny', 0.1);
edge_r = edge(rs, 'canny', 0.1);

% Preparing for exerpt
[h, w] = size(edge_g);
f_h = round(h/2);
f_w = round(w/2);
% th = 50; % Half the size of the area thats being compared

% Taking the center of the edge image
ex_b = edge_b(f_h-th:f_h+th, f_w-th:f_w+th);
ex_r = edge_r(f_h-th:f_h+th, f_w-th:f_w+th);

% How much the red and blue be translated
r_trans = comparison(edge_g, ex_r, th)/scale;
b_trans = comparison(edge_g, ex_b, th)/scale;

% Translate and resize the red and blue channel
r_t = imresize(circshift(r, r_trans),size(g));
b_t = imresize(circshift(b, b_trans),size(g));

% Crop the image
[w, h] = size(g);
ratio = w/h; % Keep the same ratio as the original image
if ratio > 1
    ratio = h/w;
end
% Find the the border to most far right
[x, y] = find(edge_g>mean(edge_g(:)), 1, 'last'); 
y = y/scale;
ys = 2*(h-y);
y=y-ys;
x=ratio*y;

% Crop off the unwanted parts
b_tc = b_t(ys:x, ys:y);
r_tc = r_t(ys:x, ys:y);
gc = g(ys:x, ys:y);

% Combine the three channels
cIm = cat(3, (r_tc), (gc), (b_tc));

%Color correct the image using gray world assumption
final=zeros(size(cIm));
for j=1:3;
    scalVal=sum(sum(cIm(:,:,j)))/numel(cIm(:,:,j));
    final(:,:,j)=cIm(:,:,j)*(127.5/scalVal);
end
final=uint8(final);

toc % pauses time here to only measure the calculations

figure
imshow(final)
