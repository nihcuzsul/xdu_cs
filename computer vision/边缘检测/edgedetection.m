
pic = imread('R.jpg');
pic_gray = double(rgb2gray(pic));
figure(1);
subplot(1,3,1);
imshow(uint8(pic_gray));
title('原始图像')
H = gaussian_filter(5, 0.8);
pic_filter = imfilter(pic_gray, H, 'replicate');
[grad, grad_direction] = compute_grad(pic_filter);
subplot(1,3,2);
imshow(uint8(grad));
title('sobel算子')
canny1 = non_maximum_restrain(grad, grad_direction);
canny11 = dual_threshold_detection(canny1, 50, 100);
subplot(1,3,3);
imshow(uint8(canny11));
title('canny算子')
function gaussian_matrix = gaussian_filter(size, sigma)
gaussian_matrix = zeros(size, size);
coef = 1 / (2 * 3.14159265 * sigma * sigma);
total_sum = 0;
for i = 1:size
    for j = 1:size
        x2 = (j - (size + 1)  / 2)^2;
        y2 = (i - (size + 1)  / 2)^2;
        gaussian_matrix(i, j) = coef * exp(-(x2 + y2) / (2 * sigma * sigma));
        total_sum = total_sum + gaussian_matrix(i, j);
    end
end
gaussian_matrix = gaussian_matrix / total_sum;
end
function [grad, grad_direction] = compute_grad(img_filter)
sobel = [-1.0 0.0 1.0;-2.0 0.0 2.0;-1.0 0.0 1.0];
gradx=conv2(img_filter, sobel, 'same');
grady=conv2(img_filter, sobel', 'same');
grad=sqrt(gradx.^2+grady.^2);
grad_direction = atan(grady./gradx);
end
function canny = non_maximum_restrain(grad, grad_direction)
[m, n] = size(grad_direction);
sec = zeros(m, n);
canny = zeros(m, n);
for i=1:m
    for j=1:n
        angle = grad_direction(i, j);
        if (angle < 3*pi/4) && (angle >= pi/4)
            sec(i, j) = 0;
        elseif (angle < pi/4) && (angle >= -pi/4)
            sec(i, j) = 3;
        elseif (angle < -pi/4) && (angle >= -3*pi/4)
            sec(i, j) = 2;
        else
            sec(i, j) = 1;
        end
    end
end
for i=2:m-1
    for j=2:n-1
        if (sec(i, j) == 0)
            if ((grad(i, j) > grad(i - 1, j + 1) && grad(i, j) > grad(i + 1, j - 1)) || (grad(i, j) > grad(i, j + 1) && grad(i, j) > grad(i, j - 1)) || (grad(i, j) > grad(i - 1, j) && grad(i, j) > grad(i + 1, j)))
                canny(i,j) = grad(i, j);
            else
                canny(i, j) = 0;
            end
        end
        if (sec(i, j) == 1)
            if (grad(i, j) > grad(i - 1, j) && grad(i, j) > grad(i + 1, j))
                canny(i,j) = grad(i, j);
            else
                canny(i, j) = 0;
            end
        end
        if (sec(i, j) == 2)
            if ((grad(i, j) > grad(i - 1, j - 1) && grad(i, j) > grad(i + 1, j + 1))|| (grad(i, j) > grad(i, j + 1) && grad(i, j) > grad(i, j - 1)) || (grad(i, j) > grad(i - 1, j) && grad(i, j) > grad(i + 1, j)))
                canny(i,j) = grad(i, j);
            else
                canny(i, j) = 0;
            end
        end
        if (sec(i, j) == 3)
            if (grad(i, j) > grad(i, j + 1) && grad(i, j) > grad(i, j - 1))
                canny(i,j) = grad(i, j);
            else
                canny(i, j) = 0;
            end
        end
    end
end
end

function canny2 = dual_threshold_detection(canny, low_th, high_th)
[m, n] = size(canny);
canny2 = zeros(m, n);
for i=2:m-1
    for j=2:n-1
        if (canny(i, j) < low_th)
            canny2(i,j) = 0;
        elseif (canny(i, j) > high_th)
            canny2(i, j) = canny(i, j);
        else
            neighbor_matrix = [canny(i-1, j-1), canny(i, j-1), canny(i+1, j-1);...
                canny(i-1, j), canny(i, j), canny(i+1, j);...
                canny(i-1, j+1), canny(i, j+1), canny(i+1, j+1);];
            max_neighbour = max(neighbor_matrix);
            if (max_neighbour > high_th)
                canny2(i, j) = canny(i, j);
            else
                canny2(i,j) = 0;
            end
        end
    end
end
end