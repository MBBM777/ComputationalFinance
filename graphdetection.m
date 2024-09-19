clc
clear

img = imread('graph.bmp');
image(img)
[x, y, z] = size(img);

pixely_x = [];
pixely_y = [];

for i = 1:x
    for j = 1:y
        if img(i, j, 1) == 0 && img(i, j, 2) == 0 && img(i, j, 3) == 0
            pixely_x = [pixely_x; i];
            pixely_y = [pixely_y; j];
        end
    end
end

figure;
plot(y - pixely_y + 1, x - pixely_x + 1, 'k.');
axis ij;
title('Graph');
xlabel('x');
ylabel('y');
grid("on")
