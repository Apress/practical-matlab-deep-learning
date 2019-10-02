%% Test the terrain camera
cd TerrainImages
label = load('Label');
cd ..

t	= categorical(label.t);

%% Get the main image
h = NewFigure('Earth Segment');
i = flipud(imread('TerrainClose64.jpg'));
image(i)

%% Get the camera image
k     = 34;
rI    = load('Loc');
im    = TerrainCamera(rI.r(:,k), h, 32 );
iD    = rI.iD(k)
nN    = load('TerrainNet');
l     = classify(nN.terrainNet,im.p)