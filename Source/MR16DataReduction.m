%v2 emphasize only saving LED data

% a = TDMS_readTDMSFile('C:\Users\dhstuart\Dropbox\CLTC\MR 16 teardown\test stand software\development\Test Data\GE Energy Smart_Hatch RA12-60M-LED_Lutron DVELV-300P_100_4.tdms');

clc
% clear all
% close all
format compact
cd ..
p = genpath(pwd);
addpath(p);

% filePath = 'C:\Users\dhstuart\Dropbox\CLTC\MR 16 teardown\data reduction\';
% cd(filePath)

% loadData = 1;
load('C:\Users\dhstuart\Documents\MR16 teardown\allLampData_test.mat')
% load('C:\Users\dhstuart\Documents\MR16 teardown\allLampData3.mat')

[~,txt,~] = xlsread('\Config\test matrix.xlsx','lamps');
testMatrix.ledDrivers = txt(:,7);
testMatrix.driverTopology = txt(:,8);
testMatrix.lampName = snake_case(txt(:,1));

% [C,ia,ic] = unique(testMatrix.driverTopology);
% [B, ib]= sort(testMatrix.driverTopology);
% temp_lamp_number = 1:11;%[1:9];
% lampNames = fieldnames(b);
% for i=1:length(lampNames)
%    dum = strfind(testMatrix.lampName,lampNames{i});
%    matrixIndex(i) = find(not(cellfun('isempty', dum)));
%    driverTopology(i,:) = testMatrix.driverTopology(matrixIndex(i));
% end
% [sortedTopologies, lampOrder]= sort(driverTopology);
%
% [C,ia,ic] = unique(sortedTopologies);
% color1 = {
%  'red'
%  'green'
%  'blue'
% };
% colors = [];
% for i = 1:length(C)
%     colorTemp = generateMonoColorPalette(color1{i},sum(ic==i));
%     colors = [colors; colorTemp];
% end


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
%% plot all driver waveforms for each lamp (either 1 or 4 lamps)
temp_lamp_number = 3;
lampNames = fieldnames(b);
tEnd = .25;%%.025
axisLimits = [
    10 1 %Acculamp
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
for i = [17]%1:length(lampNames)
    lamp = snake_case(lampNames{i});
    MR16DataReduction_plotAllDriverWavPerLamp(b, axisLimits(i,:), lamp,1, tEnd)
    MR16DataReduction_plotAllDriverWavPerLamp(b, axisLimits(i,:), lamp,4, tEnd)

end
% % save('allLampData.mat','b')



%% plot all lamps flicker metrics for varying test variations
groupDrivers = 0;
% parameter = 'percentFlicker';
parameter = 'fundamentalFrequency';
% [lampOffOrLowFund, lampNames] = MR16DataReduction_SingleParameterAllConditions(parameter,testMatrix, groupDrivers, [0.025 100]);

% [lampOffOrFlickering2, variation] = MR16DataReduction_makeMalfunctionTable(lampOffOrLowFund);
% [lampOffOrFlickering2, variation, malfunction] = MR16DataReduction_makeMalfunctionTable(1);

% flickerSeverity = lampOffOrFlickering2~=0;
% disagreement = find(flickerSeverity~=lampOffOrLowFund);

%% plot all the waveforms for single lamp and test condition at each measurement location

% MR16DataReduction_waveformsAllLocations(data,tEnd)        %doesn't currently work


%% plot EFFICIENCIES of different lamps
% groupDrivers = 0;
% out = MR16DataReduction_componentEfficiencies(b, testMatrix, groupDrivers);


%% compare power draw from deconstructed lamp with average of other lamps
% for i = temp_lamp_number;lamp = snake_case(lampNames{i});
%     dum = 0;
%     for l = 1:length(dim_levels);dim_level = dim_levels{l};
%         for j = 1:length(transformers);transformer = transformers{j};
%             for k = 1:length(dimmers);dimmer = dimmers{k};
%                 for m = [2];lamp_number = lamp_numbers{m};
%                     if k == 3 && l == 2
%                     else
%                         dum = dum+1;
%                         data = b.(lamp).(transformer).(dimmer).(dim_level).(lamp_number);
%                         power4 = data.Eprops.Transformer.Power;
%                         power1 = data.Eprops.Single_Lamp.Power;
%                         powerRatio(i,dum) = (power4/4)/power1;
%
%                     end
%                 end
%             end
%         end
%     end
% end
%
% figure
% for i= 1:size(powerRatio,1)
%     plot(powerRatio(:,i))
%     hold all
% end
% ylim([.5 1.5])
% title('power draw from other lamps over deconstruted lamp')










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


