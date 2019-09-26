%% Creates an image from 4 tiles
%
% Type CreateTerrainClose for a demo.

%% Input

%% Output
% None

function CreateTerrainClose

% Generate the file names
imageSet  = {'grid1x1+3400-11800','grid1x1+3400-11900',...
             'grid1x1+3500-11800','grid1x1+3500-11900'};
p         = [2 1 4 3 ];
% Assuming we are one directory above
cd terrainclose

im    = cell(1,4);
for k = 1:4
	im{k} = flipud(imread([imageSet{k},'.jpg']));
end

del   = size(im{1},1);

% Draw the images
x     = 0;
y     = 0;
i     = 0;
for k = 1:2
  for j = 1:2
    i = i + 1;
    image('xdata',[x;x+del],'ydata',[y;y+del],'cdata', im{p(i)} );
    hold on
    x = x + del;
  end
  x = 0;
  y = y + del;
end
axis off
axis image

cd ..
