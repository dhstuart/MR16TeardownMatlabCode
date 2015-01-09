%v2 emphasize only saving LED data

% a = TDMS_readTDMSFile('C:\Users\dhstuart\Dropbox\CLTC\MR 16 teardown\test stand software\development\Test Data\GE Energy Smart_Hatch RA12-60M-LED_Lutron DVELV-300P_100_4.tdms');
%% --------'
clc
clear all
close all
format compact

filePath1 = 'C:\Users\dhstuart\Documents\MR16 teardown\Test Data\';
filePath2 = 'C:\Users\dhstuart\Documents\MR16 teardown\mr16 flick observations round 2\Test Data\';

cd(filePath1)

loadData = 1;


tic
files = dir('*.tdms');
fileListAll = {files.name}';

% 1:30 not 23 24 27 28
index = [];
for i = [1 8 11 17]
    index = [index [1:22 25 26 29 30]+30*(i-1)];
end

index = [index [1:6 9:30]+30*(7-1)];

for i = [4 12:14]
    index = [index [1:30]+30*(i-1)];
end

%% --------------- find all files for a specific lamp name ---------------------
for i = 1:length(fileListAll)
    %     [~,metaStruct] = TDMS_readTDMSFile([filePath fileList{1}],'GET_DATA_OPTION','getnone');
    %     lamp_names{i} = metaStruct.rawDataInfo(1).propValues{2};
    
    temp = strsplit(fileListAll{i},'_');
    lampNamesAll{i} = temp{1};
end
lampNames = unique(lampNamesAll);

fileList = fileListAll(index);
temp_lamp_number = [1:18];
%% -------------------Load Metadata--------------
tab = readtable('C:\Users\dhstuart\Dropbox\CLTC\MR 16 teardown\MR16 flicker notes.xlsx');
fNames = fieldnames(tab);
% for i= 1:8
% tab.(fNames{i}) = categorical(tab.(fNames{i}));
% end



%% -------------------loop over all lamps-----------------------------
dum=0;
for i1 = 1:length(lampNames)
    clear a
    %     files = dir([filePath '*' lampNames{i1} '*.tdms']);
    %     fileList = {files.name}';
    %---------------stabilized data
    
    ix=~cellfun(@isempty,regexp(fileList,lampNames{i1}));
    fileList1 = fileList(ix);
    fullFilePath1 = strcat(filePath1, fileList1);
    %---------------observation data
    files = dir([filePath2 '*' lampNames{i1} '*.tdms']);
    fileList2 = {files.name}';
    fullFilePath2 = strcat(filePath2, fileList2);
    fullFilePath = [fullFilePath1; fullFilePath2];
    %-----------------------loop over specific lamp----------------------------
    if loadData == 1
        for j2 = 1:length(fullFilePath)
            tic
            dum=dum+1;
            disp(fullFilePath{j2})
            %             temp = TDMS_readTDMSFile([filePath fileList{j2}]);
            temp = TDMS_readTDMSFile(fullFilePath{j2});
            temp2 = TDMS_dataToGroupChanStruct_v4(temp);
            lamp = snake_case(temp2.Props.Lamp);
            transformer = snake_case(temp2.Props.Transformer);
            dimmer = snake_case(temp2.Props.Dimmer);
            dim_level = ['dim' temp2.Props.Dim_Level];
            lamp_number = ['lamp' temp2.Props.Lamp_Number];
            
            a.(lamp).(transformer).(dimmer).(dim_level).(lamp_number).Props = temp2.Props;
            if isfield(temp2,'Stabilization')
                a.(lamp).(transformer).(dimmer).(dim_level).(lamp_number).Stabilization = temp2.Stabilization;
            end
            a.(lamp).(transformer).(dimmer).(dim_level).(lamp_number).Waveforms = temp2.Waveforms;
            elapsedTime = toc;
            itterationsLeft = 540-dum;
            timeLeft = itterationsLeft*toc/60;
            disp(['time left is ' num2str(timeLeft) ' minutes'])
        end
    else
        load([filePath lampNames{i1} '.mat'])
    end
    
    %%
    
    % temp = regexp(fileList,'\w+Currents');
    % index.current = find(~cellfun(@isempty,temp));
    
    % fileName = 'GE Energy Smart_Hatch RA12-60M-LED_none_100_4.tdms';
    
    % rate = 1000000;
    % x = 0:1/rate:1-1/rate;
    % figure
    % plotyy(x,a.data{6},x,a.data{11})
    
    % power = mean(a.data{3}.*a.data{8});
    % v4=TDMS_dataToGroupChanStruct_v4(temp);
    %%
    % stab = v4.Stabilization.Stabilization_Waveform.data;
    % minuteSpacing = 15*60/5;
    % for i = 1:(length(stab)-2*minuteSpacing)
    %     temp = [stab(i) stab(minuteSpacing+i) stab(2*minuteSpacing+i)];
    %     difference(i) = max(temp) - min(temp);
    %     tollerance(i) = 0.005*mean(temp);
    %     flag(i) = difference(i)<tollerance(i);
    % end
    % find(flag)
    % figure;plot(difference)
    % hold on
    % plot(tollerance)
    %% Rename Variables
    
    
    transformers = {
        'Hatch_RA12_60M_LED'
        'Juno_TL576_60_BL'
        'Lighttech_LET_60'
        };
    dimmers = {
        'Lutron_DVELV_300P'
        'Lutron_MACL_153M'
        'none'
        };
    dim_levels = {
        'dim100'
        'dim50'
        };
    lamp_numbers = {
        'lamp4'
        'lamp1'
        
        };
    cd('C:\Users\dhstuart\Dropbox\CLTC\MR 16 teardown\data reduction')
    
    
    plotOrder = [1 4 7 10 13 2 5 8 11 14 3 6 9 12 15];
    
    %     for i = temp_lamp_number%:length(lampNames)
    lamp = snake_case(lampNames{i1});
    %     figure('name',lamp,'NumberTitle', 'off')
    dum2 = 0;
    for j = 1:length(transformers)
        transformer = transformers{j};
        for k = 1:length(dimmers)
            dimmer = dimmers{k};
            for l = 1:length(dim_levels)
                if k == 3 && l == 2
                    break
                end
                dim_level = dim_levels{l};
                for m = 1:length(lamp_numbers)
                    lamp_number = lamp_numbers{m};
                    data = a.(lamp).(transformer).(dimmer).(dim_level).(lamp_number);
                    
                    
                    %                     SupplyVoltage = data.Waveforms.Supply_Voltage.data;
                    %                     SupplyCurrent = data.Waveforms.Supply_Current.data;
                    %
                    %                     DimmerVoltage = data.Waveforms.Dimmer_Voltage.data;
                    %                     DimmerCurrent = data.Waveforms.Dimmer_Current.data;
                    %
                    %                     TransformerVoltage = data.Waveforms.Transformer_Voltage.data;
                    %                     TransformerCurrent = data.Waveforms.Transformer_Current.data;
                    %
                    %                     Single_LampVoltage = data.Waveforms.Single_Lamp_Voltage.data;
                    %                     Single_LampCurrent = data.Waveforms.Single_Lamp_Current.data;
                    
                    DriverVoltage = data.Waveforms.Driver_Voltage.data;
                    DriverCurrent = data.Waveforms.Driver_Current.data;
                    dt = data.Waveforms.Driver_Current.Props.wf_increment;
                    t = 0:dt:length(DriverCurrent)*dt-dt;
                    %                     dt2 = 1/1000000;
                    %                     t2 = 0:dt2:length(TransformerCurrent)*dt2-dt2;
                    if mean(DriverVoltage)<0
                        DriverVoltage = -DriverVoltage;
                        DriverCurrent = -DriverCurrent;
                    end
                    
                    %% -------------------- Data Reduction----------------------------
                    %                     Eprops.Supply.Power = trapz(t,SupplyVoltage.*SupplyCurrent);
                    %                     Eprops.Dimmer.Power = trapz(t,DimmerVoltage.*DimmerCurrent);
                    %                     Eprops.Transformer.Power = trapz(t2,TransformerVoltage.*TransformerCurrent);
                    %                     Eprops.Single_Lamp.Power = trapz(t2,Single_LampVoltage.*Single_LampCurrent);
                    %                     Eprops.Driver.Power = trapz(t,DriverVoltage.*DriverCurrent);
                    %
                    %                     Eprops.Dimmer.Efficiency = Eprops.Dimmer.Power/Eprops.Supply.Power;
                    %                     Eprops.Transformer.Efficiency = Eprops.Transformer.Power/Eprops.Dimmer.Power;
                    %                     Eprops.Driver.Efficiency = Eprops.Driver.Power/Eprops.Single_Lamp.Power;
                    %                     if m == 1
                    %                         Eprops.System.Efficiency = Eprops.Driver.Power/Eprops.Supply.Power;
                    %                     else
                    %                         Eprops.System.Efficiency = Eprops.Transformer.Power/Eprops.Supply.Power*Eprops.Driver.Efficiency;   %can't calculate this directly, need to use roundabout approx.
                    %                     end
                    %
                    %                     if Eprops.Driver.Efficiency < 0
                    %                         Eprops.Driver.Efficiency = 0;
                    %                         Eprops.System.Efficiency = 0;
                    %                     end
                    %
                    %                     Eprops.Supply.ITHD = thd(SupplyCurrent);
                    %                     Eprops.Dimmer.ITHD = thd(DimmerCurrent);
                    %                     Eprops.Transformer.ITHD = thd(TransformerCurrent);
                    %                     Eprops.Single_Lamp.ITHD = thd(Single_LampCurrent);
                    %                     Eprops.Driver.ITHD = thd(DriverCurrent);
                    %
                    %                     Eprops.Supply.VTHD = thd(SupplyVoltage);
                    %                     Eprops.Dimmer.VTHD = thd(DimmerVoltage);
                    %                     Eprops.Transformer.VTHD = thd(TransformerVoltage);
                    %                     Eprops.Single_Lamp.VTHD = thd(Single_LampVoltage);
                    %                     Eprops.Driver.VTHD = thd(DriverVoltage);
                    %
                    %% ------------- frequency based analysis ---------------------
                    
                    %                     DriverCurrent2 = DriverCurrent;
                    %                     DriverCurrent2(DriverCurrent2<0)=0;
                    [filtered_data, fund_freq, amp_mod SNR] = fft_cutoff_analysis(DriverCurrent', dt, 50000, 0); %diver current needs to be transposed, or this function will crash
                    [average_level, flicker_index, percent_flicker] = flicker_metrics(t, filtered_data);
                    
                    %% ---------------populate structure------------------
                    %                     b.(lamp).(transformer).(dimmer).(dim_level).(lamp_number).Eprops = Eprops;
                    b.(lamp).(transformer).(dimmer).(dim_level).(lamp_number).DriverVoltage = DriverVoltage;
                    b.(lamp).(transformer).(dimmer).(dim_level).(lamp_number).DriverCurrent = DriverCurrent;
                    b.(lamp).(transformer).(dimmer).(dim_level).(lamp_number).dt = dt;
                    b.(lamp).(transformer).(dimmer).(dim_level).(lamp_number).fundamentalFrequency = fund_freq;
                    b.(lamp).(transformer).(dimmer).(dim_level).(lamp_number).percentFlicker = percent_flicker;
                    b.(lamp).(transformer).(dimmer).(dim_level).(lamp_number).name = data.Props.name;
                    %                     b.(lamp).(transformer).(dimmer).(dim_level).(lamp_number).operator = data.Props.Operator;
                    tempIndex = strcmp(snake_case(tab.lamp),lamp) &...
                        strcmp(snake_case(tab.transformer),transformer) &...
                        strcmp(snake_case(tab.dimmer),dimmer) &...
                        tab.dimLevel==str2num(dim_level(4:end)) &...
                        tab.numLamps==str2num(lamp_number(end));
                    %                     b.(lamp).(transformer).(dimmer).(dim_level).(lamp_number).malfunctioning = str2num(tab.flicker_{find(tempIndex)});
                    
                    %%
                    %                     MR16DataReduction_waveformsAllLocations(data)
                    
                    %                     tempFields = fieldnames(data.Waveforms);
                    %                     figure
                    %                     for dum = 1:5
                    %                         %                         subplot(2,3,dum)
                    %                         subplot(2,3,dum)
                    %                         dt = data.Waveforms.(tempFields{2+dum}).Props.wf_increment;
                    %                         t = 0:dt:1-dt;
                    %                         tEnd = 0.025;
                    %                         section = length(t)*tEnd;
                    %                         h(dum,:) = plotyy(t(1:section), data.Waveforms.(tempFields{2+dum}).data(1:section), t(1:section), data.Waveforms.(tempFields{7+dum}).data(1:section));
                    %                         if dum ==5
                    %                             tempYlim1 = ylim(h(dum,1));
                    %                             tempYlim2 = ylim(h(dum,2));
                    %                             tempYtick1 = get(h(dum,1),'YTick');
                    %                             tempYtick2 = get(h(dum,2),'YTick');
                    %                             set(h(dum,1), 'XLim', [0 tEnd],'YLim',[0 tempYlim1(2)], 'YTick', linspace(0,tempYtick1(end),5));
                    %                             set(h(dum,2), 'XLim', [0 tEnd],'YLim',[0 tempYlim2(2)], 'YTick', linspace(0,tempYtick2(end),5));
                    %
                    %                             %                             axis(h(dum,1),([0 tEnd 0 tempYlim1(2)]))
                    %                             %                             axis(h(dum,2),([0 tEnd 0 tempYlim2(2)]))
                    %                         else
                    %                             axis(h(dum,1),([0 tEnd ylim(h(dum,1))]))
                    %                             axis(h(dum,2),([0 tEnd ylim(h(dum,2))]))
                    %                         end
                    %                         grid on
                    %                         xlabel('time (s)')
                    %                         ylabel(h(dum,1),'Potential (Volts)')
                    %                         ylabel(h(dum,2),'Current (Amps)')
                    %                         %                         title(tempFields{2+dum}(1:end-8))
                    %                     end
                    %
                    %                     set(gcf,'NextPlot','add');
                    %                     axes;
                    %                     h2 = title(strrep(['Lamp: ' lamp ', Transformer: ' transformer ', Dimmer: ' dimmer ', Dim level: ' dim_level ', Lamp number: ' lamp_number],'_',' '));
                    %                     set(gca,'Visible','off');
                    %                     set(h2,'Visible','on');
                    
                    %%
                    %                     tempFields = fieldnames(data.Waveforms);
                    %                     figure
                    %                     for dum = 1:5
                    %                         subplot(2,3,dum)
                    %                         dt = data.Waveforms.(tempFields{2+dum}).Props.wf_increment;
                    %                         voltageWav = data.Waveforms.(tempFields{2+dum}).data;
                    %                         currentWav = data.Waveforms.(tempFields{7+dum}).data;
                    %                         plotVoltageCurrent(voltageWav,currentWav,dt,0.025,0)
                    %                     end
                    %
                    
                    %% ----- plot LED waveforms for all test variations per product ---------
                    %                     dum2 = dum2+1;
                    %                     dum=5;
                    %                     tempFields = fieldnames(data.Waveforms);
                    %                     subplot(5,3,plotOrder(dum2))
                    %                     dt = data.Waveforms.(tempFields{2+dum}).Props.wf_increment;
                    %                     voltageWav = data.Waveforms.(tempFields{2+dum}).data;
                    %                     currentWav = data.Waveforms.(tempFields{7+dum}).data;
                    %                     if mean(voltageWav)<0
                    %                         voltageWav = -voltageWav;
                    %                         currentWav = -currentWav;
                    %                     end
                    %                     h = plotVoltageCurrent(voltageWav,currentWav,dt,0.025,axisLimits(i1,:));
                    %                     %                     reduced.(lamp).(transformer).(dimmer).(dim_level).(lamp_number).Driver_Voltage = data.Waveforms.Driver_Voltage;
                    %                     %                     reduced.(lamp).(transformer).(dimmer).(dim_level).(lamp_number).Driver_Current = data.Waveforms.Driver_Current;
                    %
                    %                     titleText = strrep({['Transformer: ' transformer];
                    %                         ['Dimmer: ' dimmer ];
                    %                         ['Dim level: ' dim_level];
                    %                         ['Lamp number: ' lamp_number];},'_',' ');
                    %                     title(titleText)
                    %                     %                     h2 = title(strrep(['Transformer: ' transformer ', Dimmer: ' dimmer ', Dim level: ' dim_level ', Lamp number: ' lamp_number],'_',' '));
                    %
                    %                     %% FFT of driver current to identify flicker
                    %
                    %
                    %                     %                     [filtered_data, fund_freq, amp_mod SNR] = fft_cutoff_analysis(y, dt, cut_off, use_low_pass_filter);
                    %                     t = 0:dt:length(currentWav)*dt-dt;
                    %                     currentWav2 = currentWav;
                    %                     currentWav2(currentWav2<0)=0;
                    %                     [average_level, flicker_index, percent_flicker] = flicker_metrics(t, currentWav2);
                    %                     a.(lamp).(transformer).(dimmer).(dim_level).(lamp_number).percentFlicker = percent_flicker;
                    %                     %                     annotation(h,'textbox',[.1 .1 .1 .1],'String',num2str(percent_flicker));
                    %                     hold all
                    %                     % fill([0 0 0.026 0.026],[1.05 1.35 1.35 1.05], 'w')% %use this for original flicker data
                    %                     text(0.0003,1.20,sprintf('percent flicker %0.2f',percent_flicker), 'FontSize', 12) % original flicker data
                    %                     %                     axis([0, .04, 0, 1.35]);
                end
                
            end
        end
    end
    %     end
end
save('C:\Users\dhstuart\Documents\MR16 teardown\allLampData3.mat','b')


% save('MR16_reduced.mat','reduced')


%%

%build new structures with just LED wave data
%     *LED currentwave
%     LED voltage wave
%     fund freq
%     percent flicker
%     is lamp on
%     circuit type
%     lamp wattage
%     efficiency of various systems (maybe)


% calc power at each location
% calc efficiency of each system
%
% produce representative plots for each test condition
% maybe only plot the LED response because in the end that's what we care about. Makes comparison between test conditions easier
%
% calc flicker metrics in LED
%     *percent flicker
%     *frequency
% compare flicker metrics across test conditions and lamps
% *note within lamp if the behavior changes across test conditions


