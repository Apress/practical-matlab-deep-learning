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
k     = 1913;
rI    = load('Loc');

rr    = rI.r(:,k)
im    = TerrainCamera(rI.r(:,k), h, 16 );
iD    = rI.id(k)
nN    = load('TerrainNet');
l     = classify(nN.terrainNet,im.p)