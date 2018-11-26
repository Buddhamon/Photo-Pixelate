classdef Image_Object
    
    
    properties
      img
      avg_pixel
      filename
    end
   
    methods
        
        function obj = Image_Object(fn)
            obj.filename = fn;
            obj.img = imread(obj.filename);
        end
        
        function [obj] = resize(obj, rows, cols)
            obj.img = imresize(obj.img,[rows cols]);
        end
        
        function [obj] =  average_pixel(obj)
            red = 0;
            green = 0;
            blue = 0;
            for row = 1:size(obj.img, 1)
                for col = 1:size(obj.img, 2)
                    r = obj.img(row, col, 1);
                    g = obj.img(row, col, 2);
                    b = obj.img(row, col, 3);

                    red = red + cast(r,'double');
                    green = green + cast(g,'double');
                    blue = blue + cast(b,'double');
                    
                end
            end
            total_pixels = size(obj.img, 1) * size(obj.img, 2);
            red = red / total_pixels;
            green = green / total_pixels;
            blue = blue / total_pixels;
            obj.avg_pixel = [cast(red,'uint8'), cast(green,'uint8'), cast(blue,'uint8')];
        end
      
    end
   
end