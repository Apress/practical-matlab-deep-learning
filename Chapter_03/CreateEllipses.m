%% Create ellipses to train and test the deep learning algorithm

% Parameters
nEllipses = 100;
nCircles  = 100;
nBits     = 32;
maxAngle  = pi/4;
rangeA    = [0.5 1];
rangeB    = [1 2];
maxThick  = 1.0;
[s, t]    = GenerateEllipses(rangeA,rangeB,maxAngle,maxThick,nEllipses,nCircles,nBits);
cd Ellipses
for k = 1:length(s)
  imwrite(s{k,2},sprintf('Ellipse%d.jpg',k));
end

% Save the labels
save('Type','t');
cd ..




