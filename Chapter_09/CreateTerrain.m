%% Finds 9 folders given a latitude and longitude
% The range is -60 to +60 in latitude. Draws a 3x3 tile map. 
% You should call NewFigure first. 
% You must be one directory above terrain for this to work.
%
% Type CreateTerrain for a demo.

%% Input
% lat (1,1) Latitude (deg)
% lon (1,1) Longitude (deg)

%% Output
% None

function CreateTerrain( lat, lon, scale )

% Demo
if( nargin < 1 )
  Demo;
  return
end

d           = dir('terrain');
latA        = zeros(1,468);
lonA        = zeros(1,468);
folderName  = cell(1,468);
for k = 1:468
  q               = d(k).name;
  folderName{k}   = q;
  if( q(2) == '0' )
    latA(k) = str2double(q(1:2));
    lonA(k) = str2double(q(3:end));
  else
    latA(k) = str2double(q(1:3));
    lonA(k) = str2double(q(4:end));
  end
end

% Center lower left corner is start
latF	= floor(lat);
lonF	= floor(lon);
latI	= zeros(1,9);
lonI	= zeros(1,9);
lon0  = lonF - 10;
latJK = latF - 10;
lonJK = lon0;
i     = 1;
for j = 1:3
  for k = 1:3
    lonI(i) = lonJK;
    latI(i) = latJK;
    lonJK   = lonJK + 10;
    i       = i + 1;
  end
  lonJK = lon0;
  latJK = latJK + 10;
end

fldr = zeros(1,9);
for k = 1:9
  j       = find(latI(k)==latA);
  i       = lonI(k)==lonA(j);
  fldr(k) = j(i);
end

% Generate the file names
imageSet  = cell(1,9);
for k = 1:9
  j = fldr(k);
  if( latA(j) >= 0  )
    if( lonA(j) >= 0 )
      imageSet{k} = sprintf('grid10x10+%d+%d',latA(j)*100,lonA(j)*100);
    else
      imageSet{k} = sprintf('grid10x10+%d-%d',latA(j)*100,lonA(j)*100);
    end
  else
    if( lonA(j) >= 0 )
      imageSet{k} = sprintf('grid10x10-%d+%d',latA(j)*100,lonA(j)*100);
    else
      imageSet{k} = sprintf('grid10x10-%d-%d',latA(j)*100,lonA(j)*100);
    end
  end
end

% Assuming we are one directory above
cd terrain

im    = cell(1,9);
for k = 1:9
	j = fldr(k);
  cd(folderName{j})
	im{k} = ScaleImage(flipud(imread([imageSet{k},'.jpg'])),scale);
  cd ..
end

del   = size(im{1},1);
lX    = 3*del;

% Draw the images
x     = 0;
y     = 0;
for k = 1:9
  image('xdata',[x;x+del],'ydata',[y;y+del],'cdata', im{k} );
  hold on
  x = x + del;
  if ( x == lX )
    x = 0;
    y = y + del;
  end
end
axis off
axis image

cd ..

%% CreateTerrain>ScaleImage
function s2 = ScaleImage( s1, q )

n = 2^q;

[mR,~,mD] = size(s1);

m = mR/n;

s2 = zeros(m,m,mD,'uint8');

for i = 1:mD
  for j = 1:m
    r = (j-1)*n+1:j*n;
    for k = 1:m
      c         = (k-1)*n+1:k*n;
      s2(j,k,i) = mean(mean(s1(r,c,i)));
    end
  end
end

%% CreateTerrain>Demo
function Demo

NewFigure('EarthSegment');
CreateTerrain( 30,60,1 )

