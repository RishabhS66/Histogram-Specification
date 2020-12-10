% Histogram Matching

%% Reading input 
Im1 = imread('givenhist.jpg'); % Image whose histogram is to be changed
Im2 = imread('sphist.jpg'); % Image that will give the reference histogam

[N, M] = size(Im1); % Image size
L = 256; % Number of gray levels for grayscale images

%% Generating histogram from images
I1hist = imhist(Im1); % Histogram of original image
I2hist = imhist(Im2); % Histogram of target image

%% Histogram equalization
s = (L-1)*cumsum(I1hist)/(N*M); % Equalize histogram of original image
s = round(s); % Round values to nearest integer
Gz = (L-1)*cumsum(I2hist)/(N*M); % Equalize histgram of target image
Gz = round(Gz); % Round values to nearest integer

%% Inverse mapping
s2z = zeros(size(Gz)); % Vector that maps s to z, where s and z are random variables corresponding to original and target image respectively.

for i = 1:256
    [diff, closest] = min(abs(Gz-s(i))); % Find the required mapping
    s2z(i) = closest(1,1)-1; % Store the mapping. Indices range from 1 to 256 while the graylevels range from 0 to 255, so 1 is subtracted.
end

%% Obtaining histogram matched image
Im1_eq = Im1; % Will store the final desired image

for i = 1:N
    for j = 1:M
        Im1_eq(i,j) = s2z(Im1(i,j)+1); % Using the mapping obtained to get the pixel intensity
    end
end

I1_eq_hist = imhist(Im1_eq); % Histogram of histogram matched image

%% Plotting figures

% Plot the given input image
figure();
imshow(Im1);
title('\fontsize{16}Image "givenhist.jpg"');

% Plot the given target image
figure();
imshow(Im2);
title('\fontsize{16}Target Image "sphist.jpg"');

% Plot the final image obtained after histogram matching
figure();
imshow(Im1_eq);
title('\fontsize{16}Image "givenhist.jpg" after Histogram Matching');

% Plot the histogram of output image
figure();
plot(I1_eq_hist);
title('\fontsize{16}Histogram of Image After Histogram Equalization and Matching');

% Plot the histogram of target image
figure();
plot(I2hist);
title('\fontsize{16}Target Histogram');
