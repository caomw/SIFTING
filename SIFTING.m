function  SIFTING
close all
Image_00a = imread('Image_base_050.jpg');
%cropping original image
IM = Image_00a(2200:(2200+500-1),1800:(1800+750-1),1:3);
imwrite(IM,'SEQUENCE3\Image_00a.png');
middleP_Y = 1800+(750/2);
middleP_X = 2200+(500/2);
Image4rotation = Image_00a(middleP_X-1500:middleP_X+1500,middleP_Y-1500:middleP_Y+1500,1:3);
%create cell array to store rotated planes
rotatedIM = cell(1,18);
field = 'H';
value = {};
for i = -45:5:45 
    ind = (i/5)+10;
    rotatedIM{ind} = imrotate(Image4rotation,i);
    middleP = 0.5*size(rotatedIM{ind});
    rotatedIM{ind} = rotatedIM{ind}(middleP(2)-250:middleP(2)+249,middleP(1)-375:middleP(1)+374,1:3);
    %now we have rotated image: rotatedIM{ind}. lets add noise and save 4 versions
    noiseLevels = [0 3 6 18];
    noiseLabels = ['a' ,'b', 'c', 'd'];
    for noise = 1:4
        NoisyIm = AddNoise(rotatedIM{ind},noiseLevels(noise));
        if (ind-1) < 10
            name = strcat('SEQUENCE3\','Image_','0',num2str(ind-1),noiseLabels(noise),'.png');
        else
            name = strcat('SEQUENCE3\','Image_',num2str(ind-1),noiseLabels(noise),'.png');
        end
        imwrite(NoisyIm,name);
    end
    %now we can compute homography matrix
    value = [value; computeHomo(i)];
end
%creating&saving struct with homographies
Sequence3Homographies = struct(field,value);
save SEQUENCE3\Sequence3Homographies.mat Sequence3Homographies