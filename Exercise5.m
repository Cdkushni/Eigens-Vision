warning('off');
close all

% n = 6 seems to be the best degree fit overall
n = 6;
% generate dense sampling to X's range.
% X_new = linspace(-125,125,125);
% 
% 
% load('light_pca.mat')
% 
% for i=1:size(Y,2)
%     I_t = renderim(Y(:,i),B,imsize); imshow(I_t,[]);
%    drawnow;
%    pause(0.05);
% end
% 
% pause
% close all
% % Polynomial interp gives a very smooth fit curve which affects the 'video'
% % by making it into a smooth interpolation of just the light moving.
% Y_new = polynomial_interp(X,Y,X_new,n);
% set(gcf, 'Position', get(0, 'Screensize'));
% figure(1);
% for i = 1:size(Y,1)
%     subplot(4,4,i)
%     figure(1),plot(X,Y(i,:),'.'),axis([-125 125 -1.1 1.1]);
%     hold on
%     figure(1),plot(X_new,Y_new(i,:));
%     hold off
% end
% 
% figure(2);
% for c = 1:size(Y_new,2)
%     Ic = renderim(Y_new(:,c),B,imsize);
%     figure(2),imshow(Ic)
%     drawnow
% end
% 
% pause
% 
% % Linear Interpolation with splines gives lines that directly hit each
% % point making it so that the lines are not as smooth. This affects the
% % 'video' in that there is less actual interpolation of the images as you
% % can see Martin tilting his head from side to side.
% Y1_new = linear_interp(X,Y,X_new);
% close all
% 
% set(gcf, 'Position', get(0, 'Screensize'));
% figure(1);
% for i = 1:size(Y,1)
%     subplot(4,4,i)
%     figure(1),plot(X,Y(i,:),'.'),axis([-125 125 -1.1 1.1]);
%     hold on
%     figure(1),plot(X_new,Y1_new(i,:));
%     hold off
% end
% figure(2);
% for c = 1:size(Y1_new,2)
%     Ic = renderim(Y1_new(:,c),B,imsize);
%     figure(2),imshow(Ic)
%     drawnow
% end
% 
% pause
% 
% 
% close all
% load('obj_pca.mat')
% % Row to plot up to since eventually the plots are just slowly
% % convering to linear horizontal lines.
% end_row = 4;
% % Generate 4 times the original number of images
% X_new = linspace(0,X(size(X,2)),4*size(X,2));
% % Creates a extremely heavily motion blurred/interpolated sequence
% % Feels slow
% Y_new = polynomial_interp(X,Y,X_new,n);
% 
% figure(1);
% set(gcf, 'Position', get(0, 'Screensize'));
% for i = 1:(end_row*9)
%     subplot(end_row,9,i)
%     figure(1),plot(X,Y(i,:),'.'),axis([0 125 -1.1 1.1])
%     hold on
%     figure(1),plot(X_new,Y_new(i,:))
%     hold off
% end
% 
% figure(2);
% for c = 1:size(Y_new,2)
%     Ic = renderim(Y_new(:,c),B,imsize);
%     figure(2),imshow(Ic)
%     drawnow
% end
% 
% pause
% close all
% % Creates a only slightly motion blurred sequence.
% % Feels fast and very smooth.
% Y_new = linear_interp(X,Y,X_new);
% 
% figure(1);
% set(gcf, 'Position', get(0, 'Screensize'));
% for i = 1:(end_row*9)
%     subplot(end_row,9,i)
%     figure(1),plot(X,Y(i,:),'.'),axis([0 125 -1.1 1.1])
%     hold on
%     figure(1),plot(X_new,Y_new(i,:))
%     hold off
% end
% 
% figure(2);
% for c = 1:size(Y_new,2)
%     Ic = renderim(Y_new(:,c),B,imsize);
%     figure(2),imshow(Ic)
%     drawnow
% end
% 
% pause


% Using linear interp since it seems to give more detail and better movement
% Doesn't remove frames through interpolation.
%
% The interpolation correctly recovers Y,
% It does have some differences compared to the original sequence however:
% Light beam to the right fades in and out during the sequence.
% Bumps and edges on Martin's face are emphasized.
% Details seems sharper less smoothing
% Shadows also seem cleaner and more accurate overall
% The specular concentrations on Martin's skin and temples particularly
% are heavier making for less accurate reflections
close all
load('light_pca.mat')

% Keep the first n degree terms and the last size - 2n terms
X_I = [X(:,1:n) X(:,2*n:size(X,2))];
Y_I = [Y(:,1:n) Y(:,2*n:size(Y,2))];

X_new = linspace(-125,125,125);
% High sample amounts helps sharpen the image and remove graininess
X_new_highsamples = linspace(0,X(size(X,2)),4*size(X,2));
Y_new = linear_interp(X_I,Y_I,X_new_highsamples);
Y_pol_new = polynomial_interp(X_I,Y_I,X_new_highsamples,n);
Y_new_cuttoff = polynomial_interp_cuttoff(X_I,Y_I,X_new_highsamples,n,0.5);

figure(1);
set(gcf, 'Position', get(0, 'Screensize'));
for i = 1:size(Y,1)
    subplot(4,4,i)
    figure(1),plot(X_I,Y_I(i,:),'.'),axis([-125 125 -1.1 1.1])
    hold on
    figure(1),plot(X_new_highsamples,Y_new(i,:))
    hold off
end

Y_og = linear_interp(X,Y,X_new_highsamples);
figure(2);
set(gcf, 'Position', get(0, 'Screensize'));
for c = 1:size(Y_new,2)
    % Render the recovered sequence on the left
    Ic = renderim(Y_new(:,c),B,imsize);
    figure(2), subplot(2,2,1), imshow(Ic)
    % Render the recovered poly interp'd in the middle
    Ip = renderim(Y_pol_new(:,c),B,imsize);
    figure(2), subplot(2,2,2), imshow(Ip)
    % Render the original linear interp sequence on the right
    Io = renderim(Y_og(:,c),B,imsize);
    figure(2), subplot(2,2,3), imshow(Io)
    Icf = renderim(Y_new_cuttoff(:,c),B,imsize);
    figure(2), subplot(2,2,4), imshow(Icf)
    drawnow
    pause(0.1);
end


function Y_new = polynomial_interp(X,Y,X_new,n)
    % Fit a polynomial of degree n to Y=f(X)
    % Returns the values of the polynomial
    % for each element in the vector X_new
    Y_new = zeros(size(Y,1),size(X_new,2));
    x1 = linspace(X_new(1),X_new(end),size(X_new,2));
    for g = 1:size(Y,1)
        x_size = size(X);
        for i = 1:x_size(2)
            p = polyfit(X,Y(g,:),n);
            Y_new(g,:) = polyval(p,x1);
        end
    end
end

function Y_new = polynomial_interp_cuttoff(X,Y,X_new,n,cuttoff)
    % Fit a polynomial of degree n to Y=f(X)
    % Returns the values of the polynomial
    % for each element in the vector X_new
    Y_new = zeros(size(Y,1),size(X_new,2));
    x1 = linspace(X_new(1),X_new(end),size(X_new,2));
    for g = 1:size(Y,1)
        x_size = size(X);
        for i = 1:x_size(2)
            p = polyfit(X,Y(g,:),n);
            val = polyval(p,x1);
            if val > cuttoff
               Y_new(g,:) = 0;
            else
               Y_new(g,:) = val;
            end
        end
    end
end

function Y_new = linear_interp(X,Y,X_new)
    Y_new = spline(X,Y,X_new);
end
