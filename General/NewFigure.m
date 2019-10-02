%% NEWFIGURE Create a new named figure window
%% Form:
%   h = NewFigure( x, varargin )
%
%% Description
% Creates a new figure window and assigns it a name.
%
%% Inputs
%   x          (:)    Name for the figure
%   varargin   {}     Parameter pairs to pass to figure()
%
%% Outputs
%   h                 Handle to the figure

function h = NewFigure( x, varargin )

h = figure(varargin{:});
set(h,'Name',x);

%% Copyright
%   Copyright (c) 2019 Princeton Satellite Systems, Inc. 
%   All rights reserved.
