%% Train the neural net

% Get the images
cd Ellipses
type = load('Type');
cd ..
imds = imageDatastore('Ellipses','labels',type.t);

% Display a few ellipses
NewFigure('Ellipses')
n = 4;
m = 5;
for i = 1:n*m
	subplot(n,m,i);
	imshow(imds.Files{i});
end

% We need the size of the images for the input layer
img     = readimage(imds,1);

% This gives the structure of the convolutional neural net
layers = [
    imageInputLayer(size(img))  
    
    convolution2dLayer(3,8,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)   
    
    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer    
    
    maxPooling2dLayer(2,'Stride',2)   
    
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer  
    
    fullyConnectedLayer(10)
    softmaxLayer
    classificationLayer
        ];