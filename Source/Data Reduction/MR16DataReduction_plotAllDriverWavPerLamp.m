function MR16DataReduction_plotAllDriverWavPerLamp(b, axisLimits, lamp, numLamps, tEnd)

plotOrder = [1 4 7 10 13 2 5 8 11 14 3 6 9 12 15];
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

if numLamps == 1
    numLampsIndex = 1;
elseif numLamps == 4
    numLampsIndex = 2;
end

% for i = temp_lamp_number%:length(lampNames)
%     lamp = snake_case(lampNames{i});
figure('name',lamp,'NumberTitle', 'off')
subplotIndex = 0;
for j = 1:length(transformers)
    transformer = transformers{j};
    for k = 1:length(dimmers)
        dimmer = dimmers{k};
        for l = 1:length(dim_levels)
            if k == 3 && l == 2
                break
            end
            dim_level = dim_levels{l};
            for m = numLampsIndex%1:length(lamp_numbers)
                lamp_number = lamp_numbers{m};
                
                
                
                data = b.(lamp).(transformer).(dimmer).(dim_level).(lamp_number);
                %
                %% ----- plot LED waveforms for all test variations per product ---------
                subplotIndex = subplotIndex+1;  %subplot index
                %                     dum=5;
                %                     tempFields = fieldnames(data.Waveforms);
                subplot(5,3,plotOrder(subplotIndex))
                dt = data.dt;
                voltageWav = data.DriverVoltage;
                currentWav = data.DriverCurrent;
                if mean(voltageWav)<0
                    voltageWav = -voltageWav;
                    currentWav = -currentWav;
                end
                h = plotVoltageCurrent(voltageWav,currentWav,dt,tEnd,axisLimits);
                %                     reduced.(lamp).(transformer).(dimmer).(dim_level).(lamp_number).Driver_Voltage = data.Waveforms.Driver_Voltage;
                %                     reduced.(lamp).(transformer).(dimmer).(dim_level).(lamp_number).Driver_Current = data.Waveforms.Driver_Current;
                
                titleText = strrep({['Transformer: ' transformer];
                    ['Dimmer: ' dimmer ];
                    ['Dim level: ' dim_level];
                    ['Lamp number: ' lamp_number];},'_',' ');
                title(titleText)
                %                     h2 = title(strrep(['Transformer: ' transformer ', Dimmer: ' dimmer ', Dim level: ' dim_level ', Lamp number: ' lamp_number],'_',' '));
                
                %% FFT of driver current to identify flicker
                
                
                [filtered_data, fund_freq, amp_mod SNR] = fft_cutoff_analysis(currentWav', dt, 500, 0);
                t = 0:dt:length(currentWav)*dt-dt;
                %                     currentWav2 = currentWav;
                %                     currentWav2(currentWav2<0)=0;
                %                     [average_level, flicker_index, percent_flicker] = flicker_metrics(t, currentWav);
                %                     a.(lamp).(transformer).(dimmer).(dim_level).(lamp_number).percentFlicker = percent_flicker;
                %                     annotation(h,'textbox',[.1 .1 .1 .1],'String',num2str(percent_flicker));
                hold all
                % fill([0 0 0.026 0.026],[1.05 1.35 1.35 1.05], 'w')% %use this for original flicker data
                text(0.0003,1.20,{sprintf('percent flicker %0.2f',data.percentFlicker) sprintf('fund freq %0.2f',fund_freq)}, 'FontSize', 12) % original flicker data
                %                     axis([0, .04, 0, 1.35]);
            end
        end
    end
end
%     end
% end