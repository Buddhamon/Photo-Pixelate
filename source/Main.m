%% Initialization

clc;
close all;
clear;

%% Input Parameters *EDIT HERE*
input_width = 50;
input_height = 50;
replace_width = 50;
replace_height = 50;

%% Input Parameters Prompt

out_w = input_width * replace_width;
out_h = input_height * replace_height;
fprintf('The output image will have a height of %d and a width of %d pixels\n', out_h, out_w);

%% Load Image

target_image = imread('../input/gorl.jpg');
target_image = imresize(target_image,[input_width input_height]);
imshow(target_image);

%% Load Replacement Images

image_files = dir('../replacement');
global replacement_images;
replacement_images = [];

for count = 4:length(image_files)
    image_file = image_files(count, :);
    file_location = strcat('../replacement/', image_file.name);
    
    img = Image_Object(file_location);
    img = img.resize(replace_width, replace_height);           
    img = img.average_pixel();
    replacement_images = [replacement_images, img];
end

%% Builds New Image

image_vector = [];
image_array = [];

for row = 1:size(target_image, 1)
    for col = 1:size(target_image, 2)
        r = target_image(row, col, 1);
        g = target_image(row, col, 2);
        b = target_image(row, col, 3);
        
        pixel = [r,g,b];
        img = get_closest_image(pixel);
        
        image_vector = [image_vector, img]; % Builds each pixel row of image
    
    end
    image_array = [image_array; image_vector]; % Concatenates vector to bottom new image
    image_vector = [];
end

%% Print New Image

figure;
imshow(image_array);

format shortg
t = clock;
t(6) = floor(t(6));
time_vector_string = strcat( num2str(t(1)), '-', num2str(t(2)), '-', num2str(t(3)) );
time_vector_string = strcat( time_vector_string, '_at_', num2str(t(4)), '.', num2str(t(5)) );
time_vector_string = strcat( time_vector_string, '.', num2str(t(6)) );

imwrite(image_array, strcat('../output/', time_vector_string, '.png'))

%% Functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [img] = get_closest_image(pixel)
    global replacement_images;
    
    index = 0;
    distance = sqrt(256^3);
    for count = 1:length(replacement_images)
        avg_pixel = replacement_images(count).avg_pixel;
        
        r_dist = ( cast(pixel(1),'double') - cast(avg_pixel(1),'double') ) ^ 2;
        g_dist = ( cast(pixel(2),'double') - cast(avg_pixel(2),'double') ) ^ 2;
        b_dist = ( cast(pixel(3),'double') - cast(avg_pixel(3),'double') ) ^ 2;
        temp_distance = sqrt(r_dist + g_dist + b_dist);
        if(temp_distance <= distance)
            index = count;
            distance = temp_distance;
        end
        
    end
    
    img = replacement_images(index).img;
    
end













