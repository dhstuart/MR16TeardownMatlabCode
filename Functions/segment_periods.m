function variation = segment_periods(data,dt)
tEnd = 1;
t = 0:dt:tEnd-dt;
% [d,initcross,finalcross,nextcross,midlev] = dutycycle(data,1/dt,'Polarity', 'positive');
% 
% 
% %% find period indices
% for i = 1:length(initcross)
%     segment = t>finalcross(i) &t<nextcross(i);
%     %     [~,endIndex(i)] = min(data(segment));
%     [minLevel(i),index] = min(data(segment));
%     endIndex(i) = index*dt+finalcross(i);
% end
% 
% 
% 
% %% Calc area under curve
% for i = 1:length(endIndex)-1
%     segBool = t>=endIndex(i) & t<endIndex(i+1);
%     areaPerPeriod(i) = trapz(t(segBool),data(segBool));
% end
% 
% %%
% figure;
% plot(0:1/50000:1-1/50000,data);
% hold all;
% for i = 1:length(initcross)
%     plot(initcross(i),midlev,'Color','r','Marker','x','MarkerSize',10,'LineStyle','none')
%     plot(finalcross(i),midlev,'Color','g','Marker','x','MarkerSize',10,'LineStyle','none')
%     plot(nextcross(i),midlev,'Color','b','Marker','x','MarkerSize',10,'LineStyle','none')
%     plot(endIndex(i),minLevel(i),'Color','k','Marker','x','MarkerSize',10,'LineStyle','none')
% end
% figure;
% plot(areaPerPeriod)


%%
y = fft(data);
[fundFreqValue, fundFreqIndex] = max(y(2:end/2)); %find largest component after DC
phase = unwrap(angle(y(fundFreqIndex)));
phaseTime = (phase+pi)/(2*pi*fundFreqIndex);

cross = (0:1/fundFreqIndex:1-(1/fundFreqIndex))+phaseTime;
% figure
% plot(t,data)
% hold all
for i = 1:length(cross)-1
    segment = t>cross(i) &t<cross(i+1);
    areaPerPeriod(i) = trapz(t(segment),data(segment));
%     plot(cross(i),(max(data)+min(data))/2,'Color','r','Marker','x','MarkerSize',10,'LineStyle','none','LineWidth', 2)
end
% figure
% plot(areaPerPeriod)
% ylimit = ylim;
% ylim([0 ylimit(2)])
% figure;
% periodogram(areaPerPeriod,hamming(length(areaPerPeriod)),[],120)
% figure
% periodogram(data,hamming(length(data)),[],50000);xlim([0,.060]);
if exist('areaPerPeriod')
variation = (max(areaPerPeriod)-min(areaPerPeriod))/((max(areaPerPeriod)+min(areaPerPeriod))/2);
else
    variation = 0;
end
end