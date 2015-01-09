% legend_shadow.m
clear all
close all
clc

figure
Width = 15 %rewrite this part. a little kludgy
Height = 15 
5
x = [0 1];
y = [0 1];
ax11 = plot(x,y);

[legend_h,object_h,plot_h,text_strings] = legend(ax11, 'x', 'y');
LegendPos = get(legend_h,'Position');
ShadowPos = [(LegendPos(1)+ 0.15/Width), (LegendPos(2)-0.15/Height), LegendPos(3), LegendPos(4)];
LegendShadow = annotation('textbox');
set(LegendShadow, 'Position', ShadowPos, 'BackgroundColor', 'k');

set(get(LegendShadow,'parent'),'handlevisibility','on') %make the axes handle visible
ch=get(gcf,'ch');
set(gcf,'ch',ch([2 1 3])) %change the stacking order