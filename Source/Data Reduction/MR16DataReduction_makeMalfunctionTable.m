% clear all
% close all
% clc
function [lampOffOrFlickering, variation, malfunction] = MR16DataReduction_makeMalfunctionTable(lampOffOrLowFund)
load('C:\Users\dhstuart\Documents\MR16 teardown\allLampData3.mat')

% tab = readtable('C:\Users\dhstuart\Dropbox\CLTC\MR 16 teardown\MR16 flicker notes3.xlsx');
tab = readtable('C:\Users\dhstuart\Documents\MR16 teardown\mr16 flick observations round 2\MR16 flicker observations round 2.xlsx');
fNames = fieldnames(tab);

% lampNames = {
%     'GE Energy Smart'
%     'LEDnovation EnhanceLite'
%     'Toshiba - 450 Series'
%     'Msi - i'
%     'Lighting Science DFN'
%     % 'Philips Endura LED'
%     'Sylvania - Ultra LED'
%     'Acculamp S-Series'
%     'Green Creative'
%     'Soraa - Premium'
%     'TerraLUX TLL-R16A'
%     'Msi - x'
%     'Collection LED'
%     % 'Satco'
%     'Zenaro'
%     'Great Eagle Lighting Corporation'
%     'TCP'
%     'Ikea'
%     'Feit'
%     'Cree'
%     };

lampNames = {
    'Acculamp S-Series'
    'Collection LED'
    'Cree'
    'Feit'
    'GE Energy Smart'
    'Great Eagle Lighting Corporation'
    'Green Creative'
    'Ikea'
    'LEDnovation EnhanceLite'
    'Lighting Science DFN'
    'Msi - iMR16'
    'Msi - xMR16'
    % 'Philips Endura LED'
    %     'Satco'
    'Soraa - Premium'
    'Sylvania - Ultra LED'
    'TCP'
    'TerraLUX TLL-R16A'
    'Toshiba - 450 Series'
    'Zenaro'
    };
transformers = {
    'Hatch_RA12_60M_LED'
    'Juno_TL576_60_BL'
    'Lighttech_LET_60'
    };
dimmers = {
    'none'
    'Lutron_DVELV_300P'
    'Lutron_MACL_153M'
    
    };
dim_levels = {
    'dim100'
    'dim50'
    };
lamp_numbers = {
    'lamp4'
    'lamp1'
    };

axisLimits = [
    8 1 %Acculamp
    8 1 %Collection LED
    40 .5 %Cree
    18 1 %Feit
    10 1 %GE
    10 .5 %great eagle
    20 1 %green creative
    8 1 %Ikea
    25 .8 %LEDnovation
    10 1 %lighting science
    12 0.5 %MSIi
    6 1.25 %MSIx
    40 .8 %sorra
    20 .8 %syvlania
    20 .5 %TCP
    12 .5 %terralux
    13 1 %Toshiba
    10 .8 %zenaro
    ];
% dum2=0;
for i = 1:length(lampNames); lamp = snake_case(lampNames{i});
    dum=0;
    for l = 1:length(dim_levels);dim_level = dim_levels{l};
        for j = 1:length(transformers);transformer = transformers{j};
            for k = 1:length(dimmers);dimmer = dimmers{k};
                for m = 1:length(lamp_numbers);lamp_number = lamp_numbers{m};
                    
                    if k == 1 && l == 2
                    else
                        %                         dum2 = dum2+1;
                        
                        dum=dum+1;
                        data = b.(lamp).(transformer).(dimmer).(dim_level).(lamp_number);
                        
                        tempIndex = strcmp(snake_case(tab.lamp),lamp) &...
                            strcmp(snake_case(tab.transformer),transformer) &...
                            strcmp(snake_case(tab.dimmer),dimmer) &...
                            tab.dimLevel==str2num(dim_level(4:end)) &...
                            tab.numLamps==str2num(lamp_number(end));
                        
                        
                        
                        %                         lampOffOrFlickering(i,dum) = str2num(tab.flicker_{find(tempIndex)});
                        lampOffOrFlickering(i,dum) = tab.flickerSeverity(find(tempIndex));
                        
                        
                        %                         if lampsToSkip(i,dum)
                        %                         if lampOffOrFlickering(i,dum) == 0
                        variation(i,dum) = segment_periods(data.DriverCurrent,1/50000);
                        %                         end
                        disp([num2str(data.fundamentalFrequency) ' ' num2str(variation(i,dum))])
                        if abs(mean(data.DriverCurrent))<0.020
                            malfunction(i,dum) = 4;
                        elseif data.fundamentalFrequency < 55
                            malfunction(i,dum) = 3;
                        elseif variation(i,dum) > 0.18
                            malfunction(i,dum) = 2;
                        else
                            malfunction(i,dum) = 0;
                        end
                        %                         if (lampOffOrFlickering(i,dum) ~= 0 & lampOffOrFlickering(i,dum) ~= 4) & (lampOffOrLowFund(i,dum)==0)
                        %                             y = fft(data.DriverCurrent);
                        %                             mag = abs(y(1:length(y)/2));
                        %                             fundMag = max(mag(2:end));
                        %                             [secondFundMag secondFundFreq] = max(mag(2:data.fundamentalFrequency-3))    %arbitrary "-3" to get rid of spectral leakage
                        %                             relativeMag = secondFundMag/fundMag
                        %
                        %                             figure('name', data.name)
                        %                             tEnd = 0.25;
                        %                             dt = data.dt;
                        %                             voltageWav = data.DriverVoltage;
                        %                             currentWav = data.DriverCurrent;
                        %                             if mean(voltageWav)<0
                        %                                 voltageWav = -voltageWav;
                        %                                 currentWav = -currentWav;
                        %                             end
                        %                             h = plotVoltageCurrent(voltageWav,currentWav,dt,tEnd,axisLimits(i,:));
                        %                             %                             plot(0:dt:1-dt,currentWav)
                        %                             %                     reduced.(lamp).(transformer).(dimmer).(dim_level).(lamp_number).Driver_Voltage = data.Waveforms.Driver_Voltage;
                        %                             %                     reduced.(lamp).(transformer).(dimmer).(dim_level).(lamp_number).Driver_Current = data.Waveforms.Driver_Current;
                        %
                        %                             titleText = strrep({['Transformer: ' transformer];
                        %                                 ['Dimmer: ' dimmer ];
                        %                                 ['Dim level: ' dim_level];
                        %                                 ['Lamp number: ' lamp_number];},'_',' ');
                        %                             title(titleText)
                        %                             %                             if lampsToSkip(i,dum)
                        %                             %                                 disp('skipped')
                        %                             %                             end
                        %                             %                             pause
                        %                         end
                        
                    end
                end
            end
        end
    end
end