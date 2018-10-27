load('EllipsePoints.mat');

% Plot the given gaussian data spreads
plot(Y1(1,:),Y1(2,:),'.',Y2(1,:),Y2(2,:),'.',Y3(1,:),Y3(2,:),'.');
axis equal
Y_m = [Y1;
       Y2;
       Y3];
hold on
index_size = size(Y_m);
for i=1:2:index_size(1)
% Retrieve the current data spread
y = Y_m(i,:);
y = [y;
     Y_m(i+1,:)];

% Averaging y gives an estimate of t
t_est = mean(y,2);
% centering the data into y hat
y_h = y - (mean(y,2) * ones(1,size(y,2)));
% Compute the empirical covariance matrix
C = (y_h * transpose(y_h))/size(y,2);
% Eigen decompose C = USigmaUtranspose, u as the rotation
% diagonal of sigma is the scaling projected on u.
[X,D] = eig(C);
D = 2*sqrt(D);
% plotting
rx1 = D(1,1)*[0 X(1,1)];
ry1 = D(1,1)*[0 X(2,1)];
% Retranslate the green axis by the y mean
rx1 = rx1 + t_est(1);
ry1 = ry1 + t_est(2);

gx1 = D(2,2)*[0 X(1,2)];
gy1 = D(2,2)*[0 X(2,2)];
% Retranslate the red axis by the y mean
gx1 = gx1 + t_est(1);
gy1 = gy1 + t_est(2);

plot(rx1,ry1,'r')
plot(gx1,gy1,'g')
end
hold off
