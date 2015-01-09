% mr16_investigate_flicker


clc
clear all
% close all
format compact

% filePath = 'C:\Users\dhstuart\Dropbox\CLTC\MR 16 teardown\data reduction\';
filePath = 'C:\Users\dhstuart\Documents\MR16 teardown\Test Data\';
% cd(filePath)

% loadData = 1;
% load allLampData.mat


% lamp = {
%     'Acculamp S-Series'
%     'Collection LED'
%     'Cree'
%     'Feit'
%     'GE Energy Smart'
%     'Great Eagle Lighting Corporation'
%     'Green Creative'
%     'Ikea'
%     'LEDnovation EnhanceLite'
%     'Lighting Science DFN'
%     'Msi - iMR16'
%     'Msi - xMR16'
%     'Soraa - Premium'
%     'Sylvania - Ultra LED'
%     'TCP'
%     'TerraLUX TLL-R16A'
%     'Toshiba - 450 Series'
%     'Zenaro'
% };
lamp = {
    'Cree'
    'Feit'
    'Green Creative'
    'Msi - xMR16'
    'Soraa - Premium'
    'Sylvania - Ultra LED'
    
    'Acculamp S-Series'
    'Collection LED'
    'GE Energy Smart'
    'Great Eagle Lighting Corporation'
    'Ikea'
    'LEDnovation EnhanceLite'
    'Lighting Science DFN'
    'Msi - iMR16'
    'TCP'
    'TerraLUX TLL-R16A'
    'Toshiba - 450 Series'
    'Zenaro'
    };

transformer = {
%     'Lighttech LET-60';
        'Hatch RA12-60M-LED';
%         'Juno TL576-60-BL'
    };

dimmer = {
%     'Lutron MACL-153M';
    % 'Lutron DVELV-300P';
        'none'
    };
dim_level = {
%     '50';
        '100';
    };



lamp_number = {
        '4';
%     '1'
    };



for i = 1:length(lamp)
    %     files = dir([filePath [lamp '_' transformer '_' dimmer '_' dim_level '_' lamp_number] '.tdms']);
    files = [filePath [lamp{i} '_' transformer{1} '_' dimmer{1} '_' dim_level{1} '_' lamp_number{1}] '.tdms'];
    
    %     fileList = {files.name}';
    %-----------------------loop over specific lamp----------------------------
    %     if loadData == 1
    %         for j2 = 1:length(fileList)
    %             disp(fileList{j2})
    temp = TDMS_readTDMSFile(files);
    temp2 = TDMS_dataToGroupChanStruct_v4(temp);
    %             lamp = snake_case(temp2.Props.Lamp);
    %             transformer = snake_case(temp2.Props.Transformer);
    %             dimmer = snake_case(temp2.Props.Dimmer);
    %             dim_level = ['dim' temp2.Props.Dim_Level];
    %             lamp_number = ['lamp' temp2.Props.Lamp_Number];
    %
    %             a.(lamp).(transformer).(dimmer).(dim_level).(lamp_number).Props = temp2.Props;
    %             if isfield(temp2,'Stabilization')
    %                 a.(lamp).(transformer).(dimmer).(dim_level).(lamp_number).Stabilization = temp2.Stabilization;
    %             end
    %             a.(lamp).(transformer).(dimmer).(dim_level).(lamp_number).Waveforms = temp2.Waveforms;
    %
    %         end
    %     else
    
    data = temp2;
    
%     tEnd = 1;
%     % figure('name',lamp,'NumberTitle', 'off')
% %     MR16DataReduction_waveformsAllLocations(data,tEnd)
%     
%     data2 = data.Waveforms.Dimmer_Voltage.data;
%     data3 = data.Waveforms.Dimmer_Current.data;
% %         data2 = data.Waveforms.Driver_Voltage.data;
% %     data3 = data.Waveforms.Driver_Current.data;
% %         data2 = data.Waveforms.Transformer_Voltage.data;
% %     data3 = data.Waveforms.Transformer_Current.data;
%     dt = 1/50000;
%     t = 0:dt:1-dt;
%     %
%     c = crossing2(t,data2,0);
%     figure
%     tseg = t(c(1):c(3));
%     dataSeg = data3(c(1):c(3));
%     lenDataSeg = length(dataSeg);
%     threshold = 0.02;
%     phases = whenOnInCycle(dataSeg,threshold);
%     lengths(i,:) = [phases(2)-phases(1) phases(4)-phases(3)];
%     plotyy(tseg,data2(c(1):c(3)),tseg,data3(c(1):c(3)))
%     hold all
%     plot(t(round(phases*lenDataSeg))+t(c(1)),zeros(size(phases)),'rx','MarkerSize',12)
%     title([data.Props.name ' - ' sprintf('%0.2f',lengths(i,1)) ' - ' sprintf('%0.2f',lengths(i,2))],'interpreter','none')

    figure
plot(temp2.Waveforms.Driver_Voltage.data)
xlim([0 1000])
title(data.Props.name,'interpreter','none')
end

%
% % variation = segment_periods(data.Waveforms.Driver_Current.data)
%
% variation = segment_periods(data.Waveforms.Dimmer_Voltage.data,dt)
%%
% dt = 1/50000;
% % data = b.TCP.Lighttech_LET_60.Lutron_MACL_153M.dim100.lamp4.DriverCurrent;
% % data = b.Acculamp_S_Series.Hatch_RA12_60M_LED.Lutron_MACL_153M.dim50.lamp4.DriverCurrent;
% % data = b.Collection_LED.Lighttech_LET_60.Lutron_MACL_153M.dim50.lamp4.DriverCurrent;
% data = data.Waveforms.Driver_Current.data;
% y = fft(data);
% figure;
% periodogram(data,hann(length(data)),[],1/dt);
% % periodogram(data,[],[],1/dt);
%
% mag = abs(y(1:length(y)/2));
% [fundFreqValue, fundFreqIndex] = max(y(2:length(y)/2)); %find largest component after DC
% phase = unwrap(angle(y(fundFreqIndex)));
% figure

% t = 0:dt:1-dt;
% y2 = sin(2*pi*fundFreqIndex*t+phase)+1;
% h = plotyy(t,data,t,y2);
% ylim(h(1),[0 max(data)])

% for i = 1:fundFreqIndex
% wavelength = 1/fundFreqIndex;
%     x = wavelength(i+phase/(2*pi));
