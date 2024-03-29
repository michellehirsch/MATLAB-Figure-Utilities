function figshift(scale)
%FIGSHIFT          Cascades current figure window away from previous figure
% 	Places figure window slightly offset from previous figure
%  	window, to allow for easy switching between windows.  This is similar
%  	to the old Windows "Cascade" feature.
%
% 	Optional scalar argument SCALE sets how far figure is offset from previous
%  	figure, as a percent of previous figure dimensions (0<SCALE<100)
%
%	Call FIGSHIFT after opening window
%
% Example: Shift one figure relative to another
%    figure
%    figure
%    figshift   % Offset figure 2 from figure 1
%
% Example: Shift figures as they are created.
%     for ii=1:10
%     figure(ii);figshift
%     end

% 	Michelle Hirsch
% 	mhirsch@mathworks.com
%   (c) 2002 The MathWorks, Inc.

if nargin==0
    scale=.05;	%Default, 5% of figure size
else
    scale=scale*.01;
end;

PrevHandle = getPreviousFigureHandle();

if isempty(PrevHandle)
    return
end

[NewPosition, Units] = getPosition(PrevHandle,scale);

% Update figure position
set(gcf,'Units',Units,'Position',NewPosition);
end

function PrevHandle = getPreviousFigureHandle
if verLessThan('matlab','8.4')
    thisfig = gcf;
    allfigs = sort(get(0,'Children'));      % handle is number
else
    thisfig = get(gcf,'Number');
    r = groot;
    allfigs = sort([r.Children.Number]);    % use handle to get to number
end

prevfignumber = find(thisfig==allfigs) - 1;
if prevfignumber==0, 
    PrevHandle =[];
    return
end  % First figure - can't shiftit

PrevHandle = allfigs(prevfignumber);
end


function [NewPosition, Units] = getPosition(PrevHandle,scale)
PrevPosition=get(PrevHandle,'Position');
Units=get(PrevHandle,'Units');
FigWidth=PrevPosition(3);
FigHeight=PrevPosition(4);
NewPosition=PrevPosition;
NewPosition(1)=PrevPosition(1)+FigWidth*scale;	    %Shift Over
NewPosition(2)=PrevPosition(2)-FigHeight*scale;		%Shift Down

%Check if the new position is off of the screen
%If it is, move figure to upper left corner of screen
scnsize=get(0,'ScreenSize');
ScnWidth=scnsize(3);
ScnHeight=scnsize(4);

if ((NewPosition(1)+FigWidth) > ScnWidth) || ((NewPosition(2)+FigHeight) > ScnHeight)
    NewPosition(1)=0;
    NewPosition(2)=ScnHeight*.95 - FigHeight;
end

end
