function stereo_creator

    % generate a random dot stereogram
    im = rgb2gray(imread('white2.jpeg'));
    im_pic = rgb2gray(imread('pepe.jpg'));
    im = imresize(im, size(im_pic));
    im = imbinarize(imnoise(im,'salt & pepper',.1));
    im = imerode(im, strel('disk', 3));
    imshow(im);

    % create a binary image 
    im_binary = imbinarize(im_pic);
    stereo_bin = (im_binary & im) * 100;
    moved_bin = imtranslate(im_binary,[-100, 0]);
    moved_s = imtranslate(stereo_bin,[-100, 0]);
    % generate the stereogram with the hidden image
    combined = (im - moved_bin) + moved_s;
    tile = imtile({combined, im, im_binary, stereo_bin, moved_bin, moved_s});
    imshow(tile)
    
    % find the edges of the image and generate a stereogram
    im_pic_blur = imdilate(im_pic, strel('disk', 5));
    edges = imdilate(imbinarize(im_pic_blur - im_pic), strel('disk',10));
    stereo_edges = (edges & im) * 100;
    moved_edges = imtranslate(stereo_edges,[-100, 0]);
    moved_edges_solid = imtranslate(edges,[-100, 0]);
    combined_stereo = (im - moved_edges_solid) + moved_edges;
    tile = imtile({im, combined_stereo},'BorderSize', 20, 'BackgroundColor', 'w');
    imshow(tile);

end 