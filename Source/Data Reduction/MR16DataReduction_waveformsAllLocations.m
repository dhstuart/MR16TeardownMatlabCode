function MR16DataReduction_waveformsAllLocations(data,tEnd)

tempFields = fieldnames(data.Waveforms);
figure('name',[data.Props.Lamp ' - ' data.Props.Transformer ' - ' data.Props.Dimmer ' - ' data.Props.Dim_Level ' - ' data.Props.Lamp_Number])

leadFactor = 0;%0.000793;

for dum = 1:5
    %                         subplot(2,3,dum)
    subplot(2,3,dum)
    dt = data.Waveforms.(tempFields{2+dum}).Props.wf_increment;
    if dum==3 || dum ==4    %fix the lead on the fast acquisition
        t = (0:dt:1-dt)-leadFactor;
    else
        t = 0:dt:1-dt;
    end
%     tEnd = 0.025;
    section = length(t)*tEnd;
    h(dum,:) = plotyy(t(1:section), data.Waveforms.(tempFields{2+dum}).data(1:section), t(1:section), data.Waveforms.(tempFields{7+dum}).data(1:section));
    if dum ==5
        tempYlim1 = ylim(h(dum,1));
        tempYlim2 = ylim(h(dum,2));
        tempYtick1 = get(h(dum,1),'YTick');
        tempYtick2 = get(h(dum,2),'YTick');
        set(h(dum,1), 'XLim', [0 tEnd],'YLim',[0 tempYlim1(2)], 'YTick', linspace(0,tempYtick1(end),5));
        set(h(dum,2), 'XLim', [0 tEnd],'YLim',[0 tempYlim2(2)], 'YTick', linspace(0,tempYtick2(end),5));
        
        %                             axis(h(dum,1),([0 tEnd 0 tempYlim1(2)]))
        %                             axis(h(dum,2),([0 tEnd 0 tempYlim2(2)]))
    else
        axis(h(dum,1),([0 tEnd ylim(h(dum,1))]))
        axis(h(dum,2),([0 tEnd ylim(h(dum,2))]))
    end
    grid on
    xlabel('time (s)')
    ylabel(h(dum,1),'Potential (Volts)')
    ylabel(h(dum,2),'Current (Amps)')
    title(tempFields{2+dum}(1:end-8),'Interpreter','none')
end
linkaxes(h,'x')

% set(gcf,'NextPlot','add');
% axes;
% h2 = title(strrep(['Lamp: ' lamp ', Transformer: ' transformer ', Dimmer: ' dimmer ', Dim level: ' dim_level ', Lamp number: ' lamp_number],'_',' '));
% set(gca,'Visible','off');
% set(h2,'Visible','on');