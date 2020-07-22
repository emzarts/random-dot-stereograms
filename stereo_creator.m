function stereo_creator()

    im = rgb2gray(imread('box.jpg'));
    factor = 5;
    rds = generate_random_dot_stereogram(im, factor);
    
    map = generate_disparity_map(im);
    imshow(map);
    
    im_binary = imbinarize(im);
    seg_size = size(im_binary,2)/factor;
    srds = rds;
    for idx = 1:factor 
        segment = im_binary(:, (seg_size*(idx-1))+1:seg_size*idx);
        shifted = shift_section(rds, segment);
        tile = imtile({segment, shifted});
        imshow(tile);
        srds = cat(2, srds, shifted);
    end
    imshow(srds);

    
    % create a binary image 
    stereo_bin = (im_binary & rds) * 100;
    moved_bin = imtranslate(im_binary,[-100, 0]);
    moved_s = imtranslate(stereo_bin,[-100, 0]);
    % generate the stereogram with the hidden image
    combined = (rds - moved_bin) + moved_s;
    tile = imtile({combined, rds, im_binary, stereo_bin, moved_bin, moved_s});
    imshow(tile)
    
    % find the edges of the image and generate a stereogram
    im_pic_blur = imdilate(im, strel('disk', 5));
    edges = imdilate(imbinarize(im_pic_blur - im), strel('disk',10));
    stereo_edges = (edges & rds) * 100;
    moved_edges = imtranslate(stereo_edges,[-100, 0]);
    moved_edges_solid = imtranslate(edges,[-100, 0]);
    combined_stereo = (rds - moved_edges_solid) + moved_edges;
    tile = imtile({rds, combined_stereo},'BorderSize', 20, 'BackgroundColor', 'w');
    imshow(tile);

end 

function rds = generate_random_dot_stereogram(im_pic, factor) 
    im = zeros([size(im_pic,1) size(im_pic,2)/factor]) + 255;
    im = imbinarize(imnoise(im,'salt & pepper',.1));
    rds = imerode(im, strel('disk', 3));
end

function map = generate_disparity_map(im)
    map = ind2rgb(histeq(im),gray(100));
end

function shifted = shift_section(rds, map_section) 
    stereo_bin = (map_section & rds) * 100;
    moved_bin = imtranslate(map_section,[-100, 0]);
    moved_s = imtranslate(stereo_bin,[-100, 0]);
    % generate the stereogram with the hidden image
    combined = (rds - moved_bin) + moved_s;
    shifted = combined;
    tile = imtile({rds, combined, rds, map_section, stereo_bin, moved_bin, moved_s});
    imshow(tile)
end 