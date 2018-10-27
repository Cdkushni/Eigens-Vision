% Larger Y values cause a heavier normal mapping effect, highlighting
% the edges and lighting of the image. This is due to the range moving
% the image's shift to the extreme of the gradient right away like Fx or Fy
% This procedure would thus work best for images with well defined edges
% and clear specular lighting on objects so that the image gradient can
% highlight these with the normal mapping edge shifts.
% When it doesn't work on an image then the image likely doesn't have
% well defined edges and specular reflections so based on a Taylor
% expansion the shifts are approximated with only the largest elements.
% As with exercise two, higher shift sizes applied to the Y frequency
% causes a shorter sine period allowing for more shifts quicker.

load('immotion_basis.mat')

I = imread('Lenna_baseimage.png');
% To gray double image for gradient
I = double(rgb2gray(I));
[Ix,Iy] = gradient(I);
% Combine the returned basis in flattened columns
B_img = [I(:) Ix(:) Iy(:)];
   
set(gcf, 'Position', get(0, 'Screensize'));
for i=1:size(Y,2)
   % Base image basis and Y, seems to alternate between normal magnitudes
   I1_b = renderim(Y(:,i),B,imsize); subplot(2,3,1), imshow(I1_b,[]);
   drawnow;
   % Small Y range -3 to 3. Low step has long sine periods
   t = -3:0.2:3;
   y_n = genYMatr(t,100,200);
   I1_s = renderim(y_n(:,i),B,imsize); subplot(2,3,2), imshow(I1_s,[]);
   drawnow;
   % With a higher step gives a shorter period and more shifts.
   t = -3:2:3;
   y_n = genYMatr(t,50,10);
   I1_l = renderim(y_n(:,i),B,imsize); subplot(2,3,3), imshow(I1_l,[]);
   drawnow;
   % Base custom image in grayscale, shifts happen between the Fx-Fy
   % gradient.
   I1_i = renderim(Y(:,i),B_img,size(I)); subplot(2,3,4), imshow(I1_i,[]);
   drawnow;
   % Larger range t values 5 to 10.
   t = 5:10;
   y_n = genYMatr(t,100,500);
   I1_il = renderim(y_n(:,i),B_img,size(I)); subplot(2,3,5), imshow(I1_il,[]);
   drawnow;
   % Larger range t values 20 to 50
   t = 20:5:50;
   y_n = genYMatr(t,100,500);
   I1_ilf = renderim(y_n(:,i),B_img,size(I)); subplot(2,3,6), imshow(I1_ilf,[]);
   drawnow;
   pause(0.1);
end

function Y_new = genYMatr(t, x_shift, y_shift)
% Ic = I0 + t*dI;
% Three basis images: I, Ix, Iy
% Each coefficient vector has three entries: 1, dx, dy
% dx, dy: shift along x and y respectively by number of pixels
% First fill matrix with 3 rows of 1s, first row corresponds to
% the 1 coefficient row.
% Second row shift: dx: horizontal shift, t, 0 for t range,
% t again.
% Third row shift: dy: vertical shift, 0 for t range, t range twice

% lower steps will slow down the frequency of the shifts
%     Y_new = [ones(1,3*size(t,2) + 1);
%            x_shift t zeros(1,size(t,2)) t;
%            y_shift zeros(1,size(t,2)) t t];
  
    Y_new = [ones(1,3*size(t,2) + 1);
           x_shift t t t;
           y_shift t t t];
end
