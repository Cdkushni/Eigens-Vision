load('sincos_basis.mat')

% For some Basis vector B and coefficient a.
% Since B(:,1) = sin(ax) => ax = asin(B(:,1)) => 2ax = 2*asin(B(:,1))
% => B_1(:,1) = sin(2ax) => B_1(:,1) = sin(2*asin(B(:,1)))
B_1 = [sin(2*asin(B(:,1))) cos(2*acos(B(:,2)))];
Y_1 = [sin(2*asin(Y(1,:)));
       cos(2*acos(Y(2,:)))];

gridfig = gcf;
for i=1:size(Y,2)
    % Base waveforms for reference.
    Ii_b = renderim(Y(:,i),B,imsize); subplot(1,3,1), imshow(Ii_b,[]);
    % Increasing the frequency by treating Y as the basis to be doubled
    % creates a modulation of the waveforms that speeds up their movement
    % and causes them to alternate directions with the modulation.
    Ii = renderim(Y_1(:,i),B,imsize); subplot(1,3,2), imshow(Ii,[]); 
    % Changing b creates a motion in both directions from the
    % sin and cos arcs as well as it becoming slower.
    Ii_c = renderim(Y(:,i),B_1,imsize); subplot(1,3,3), imshow(Ii_c,[]);
    drawnow; pause(0.05);
end

function im_new = renderim(Y_new,B,imsize,NrB)

if(nargin<4)
  NrB = size(B,2);
end
disp(size(B,1))
if imsize(1)*imsize(2)~=size(B,1)
  fprintf('Incompatible image size\n');
  return;
end

im_new = reshape(B(:,1:NrB)*Y_new(1:NrB),imsize(1),imsize(2));
end