function [translation] = comparison(image, reference, threshold)
    score = -1;
    
    [h w] = size(image);
    h2 = round(h/2);
    w2 = round(w/2);
    
    for x = -threshold:threshold
        for y = -threshold:threshold
            temp_im = image(h2-threshold+y:h2+threshold+y, w2-threshold+x:w2+threshold+x);
            temp_score = sum(sum(temp_im(:,:).*reference(:,:)));
            if temp_score > score
                score = temp_score;
                translation = [y x];
            end
        end
    end
end