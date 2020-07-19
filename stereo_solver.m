function stereo_solver() 
    im = im2double(imread('stereograms/peace.png'));
    % im_copy = imread('stereograms/peace.png');
    im_lab = rgb2lab(im);
    im_hsv = rgb2hsv(im);
    im_ycbcr = rgb2ycbcr(im);
    
    tile = imtile({im, im_hsv(:,:,3), im_ycbcr});
    imshow(tile);
end 