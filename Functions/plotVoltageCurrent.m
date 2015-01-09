% function [h] = plotVoltageCurrent(voltageWav, currentWav, dt, tEnd, changeAxisLimits)
function [h] = plotVoltageCurrent(voltageWav, currentWav, dt, tEnd, axisLimits)

% tempFields = fieldnames(data.Waveforms);
% figure
% for dum = 1:5
%                         subplot(2,3,dum)
%     subplot(2,3,dum)
%     dt = data.Waveforms.(tempFields{2+dum}).Props.wf_increment;
t = 0:dt:1-dt;
%     tEnd = 0.025;
section = length(t)*tEnd;
dum=1;
h(dum,:) = plotyy(t(1:section), voltageWav(1:section), t(1:section), currentWav(1:section));
%     h(dum,:) = plotyy(t(1:section), data.Waveforms.(tempFields{2+dum}).data(1:section), t(1:section), data.Waveforms.(tempFields{7+dum}).data(1:section));
% if changeAxisLimits == 1
%     %     tempYlim1 = [0 10]; %ylim(h(dum,1));
%     %     tempYlim2 = [0 1];%ylim(h(dum,2));
%     %     tempYtick1 = [0 2.5 5 7.5 10];%get(h(dum,1),'YTick');
%     %     tempYtick2 = tempYtick1/10;%get(h(dum,2),'YTick');
%     %%%%%%%%%%%
%     tempYlim1 = ylim(h(dum,1));
%     tempYlim2 = ylim(h(dum,2));
% %     tempYtick1 = ceil(get(h(dum,1),'YTick')/2)*2;   %round up to closet even number
% %     tempYtick2 = ceil(get(h(dum,2),'YTick')/2)*2;
% %      tempYtick1 = get(h(dum,1),'YTick');   %round up to closet even number
% %     tempYtick2 = get(h(dum,2),'YTick');
%       tempYtick1 = max(voltageWav);   %round up to closet even number
%     tempYtick2 = max(currentWav);   
%     
% %     tempYtick1 = tempYtick1(end);
%     exponent1 = floor(log10(tempYtick1));
%     tempYtick1 = (ceil((tempYtick1/1*10^(-exponent1))/2)*2)^(exponent1+1);
% %         tempYtick2 = tempYtick2(end);
%     exponent2 = floor(log10(tempYtick2));
%     tempYtick2 = (ceil((tempYtick2/1*10^(-exponent2))/2)*2)^(exponent2+1);
%     set(h(dum,1), 'XLim', [0 tEnd],'YLim',[0 tempYtick1], 'YTick', linspace(0,tempYtick1,5));
%     set(h(dum,2), 'XLim', [0 tEnd],'YLim',[0 tempYtick2], 'YTick', linspace(0,tempYtick2,5));
%     
%     %                             axis(h(dum,1),([0 tEnd 0 tempYlim1(2)]))
%     %                             axis(h(dum,2),([0 tEnd 0 tempYlim2(2)]))
% else
%     axis(h(dum,1),([0 tEnd ylim(h(dum,1))]))
%     axis(h(dum,2),([0 tEnd ylim(h(dum,2))]))
% end
set(h(dum,1), 'XLim', [0 tEnd],'YLim',[0 axisLimits(1)], 'YTick', linspace(0,axisLimits(1),5))
set(h(dum,2), 'XLim', [0 tEnd],'YLim',[0 axisLimits(2)], 'YTick', linspace(0,axisLimits(2),5))

grid on
xlabel('time (s)')
ylabel(h(dum,1),'Potential (Volts)')
ylabel(h(dum,2),'Current (Amps)')
%                         title(tempFields{2+dum}(1:end-8))
% end

% set(gcf,'NextPlot','add');
% axes;
% h2 = title(strrep(['Lamp: ' lamp ', Transformer: ' transformer ', Dimmer: ' dimmer ', Dim level: ' dim_level ', Lamp number: ' lamp_number],'_',' '));
% set(gca,'Visible','off');
% set(h2,'Visible','on');
