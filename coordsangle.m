
% [NewCoords] = coordsangle(theta,h,yCenter,xCenter,texsize)
%calculate the coordinates for a set of stimuli drawn at certain visual angles
% theta = angles in degrees; can be a vector
%h distance of stimulus from center (in pixels)
%yCenter - y coordinate of centre of screen
%xCenter - x coordinate of centre of screen
%texsize - size of stimulus

function  [NewCoords] = coordsangle(theta,h,yCenter,xCenter,texsize)

for u=1:length(theta)
angle=theta(u)*pi/180;%transform the angles to radians

x(u)=round(h*cos(angle)); %calculate x coordinates centred to 0,0

y(u)=round(h*sin(angle));
end

%move the center of the new coordinates to the coordinates space of the
%psychtoolbox screen

y=y+yCenter;
x=x+xCenter;

%those coordinates are the centre of where the texture will be drawn
% we need to calculate the top left coordinate of the rectangle (rx1, ry1), 
% and the bottom right coordinate of the rectangle (rx2, ry2)
% so that we can use [rx1 ry1 rx2 ry2] for dstRect

for d=1:length(x)
 
  NewCoords(d,:)=round([x(d)-texsize y(d)-texsize x(d)+texsize y(d)+texsize]);


end



end