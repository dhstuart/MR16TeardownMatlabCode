%v2 emphasize only saving LED data

% a = TDMS_readTDMSFile('C:\Users\dhstuart\Dropbox\CLTC\MR 16 teardown\test stand software\development\Test Data\GE Energy Smart_Hatch RA12-60M-LED_Lutron DVELV-300P_100_4.tdms');
function [lampOffOrFlickering, lampNames] = MR16DataReduction_SingleParameterAllConditions(parameter,testMatrix, groupDrivers, tollerances)
% clc
% clear all
% % close all
% format compact

% filePath = 'C:\Users\dhstuart\Dropbox\CLTC\MR 16 teardown\data reduction\';
% cd(filePath)

% loadData = 1;
load('C:\Users\dhstuart\Documents\MR16 teardown\allLampData_test.mat')

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
    'lamp1'
    'lamp4'
    };
% cd('C:\Users\dhstuart\Dropbox\CLTC\MR 16 teardown\data reduction')

%% Reorder based on driver topology
% temp_lamp_number = 1:11;%[1:9];
lampNames = fieldnames(b);
if groupDrivers == 1
    % --------sort driver topologies----------
    for i=1:length(lampNames)
        dum = strfind(testMatrix.lampName,lampNames{i});
        matrixIndex(i) = find(not(cellfun('isempty', dum)));
        driverTopology(i,:) = testMatrix.driverTopology(matrixIndex(i));
    end
    [sortedTopologies, lampOrder]= sort(driverTopology);
    
    [C,~,ic] = unique(sortedTopologies);
    %---------apply colors to topologies-----------
    color1 = {
        'red'
        'green'
        'blue'
        };
    colorList = [];
    for i = 1:length(C)
        colorTemp = generateMonoColorPalette(color1{i},sum(ic==i));
        colorList = [colorList; colorTemp];
    end
    colorList = colorList/255;
    lampNames = lampNames(lampOrder);
else
    colorList = distinguishable_colors(length(lampNames));
end
%% plot all lamps flicker metrics for varying test variations
dimmerShort = {
    'none'
    'Reverse'
    'Forward'
    };
lampNumShort = {
    '1 '
    '4 '
    };



for i = 1:length(lampNames); lamp = snake_case(lampNames{i});
    dum=0;
    for l = 1:length(dim_levels);dim_level = dim_levels{l};
        for j = 1:length(transformers);transformer = transformers{j};
            for k = 1:length(dimmers);dimmer = dimmers{k};
                for m = [1 2];lamp_number = lamp_numbers{m};
                    
                    if k == 1 && l == 2
                    else
                        
                        data = b.(lamp).(transformer).(dimmer).(dim_level).(lamp_number);
                        dum=dum+1;
                        
                        %                         allFlickerMetrics(i,dum) = data.(parameter);
                        %                         allFlickerMetrics(i,dum) = data.Eprops.Driver.Efficiency;
                        
                        allFlickerMetrics(i,dum) = data.(parameter);
                        %                                                 allFlickerMetrics(i,dum) = data.fundamentalFrequency;
                        
                        
                        %                         lampOff(i,dum) =
%                         disp([num2str(data.fundamentalFrequency) ' ' num2str(mean(data.DriverCurrent))])
                        lampOffOrFlickering(i,dum) = mean(data.DriverCurrent)<tollerances(1) || data.fundamentalFrequency <tollerances(2);
                        
%                                                 lampOffOrFlickering(i,dum) = data.malfunctioning;
                        testConditionNames{dum,1} = [transformer ' ' dimmer ' ' dim_level ' ' lamp_number];
                        xTickLabels{dum} = [dimmerShort{k} ' - ' lampNumShort{m}];
                    end
                end
            end
        end
    end
end



h=figure('Position',[1 1 979 789]);

% axesPosition = [0.13 0.268 0.757 0.657];
axesPosition = [0.13 0.228 0.757 0.657];

axes1 = axes('Parent',h,'XTickLabel',xTickLabels,'XTick',1:30,...
    'Position',axesPosition);
rotateXLabels(gca,90)
for i = 1:size(allFlickerMetrics,1)
    hold all
    %     plot(allFlickerMetrics(i,:),'Parent',axes1,'Marker','o','LineWidth',3,'Color',colorList(i,:))
    plot(allFlickerMetrics(i,:),'Parent',axes1,'Marker','o','LineWidth',3,'Color',colorList(i,:))
    
end

%----------legend---------------
if groupDrivers == 1
    separator = repmat({' - '},length(sortedTopologies),1);
    legend(strcat(sortedTopologies, separator, strrep(lampNames, '_', ' ')),'Location','SouthEast')
else
    legend(strrep(lampNames, '_', ' '),'Location','SouthEast')
end


% ylabel('Percent Flicker')
ylabel(parameter)

%% ----------------Create plot dividing lines -----------------
lineColor = [.5 .5 .5];
lineCoord = [axesPosition(2) 0.925378151260504];

lineYCoords = ylim(gca); lineYCoords(1) = 10^0;
lineSpacing = axesPosition(3)/30;
omitLines = [7 13 19 23 27];
for i = 1:30
    if ~sum(i==omitLines)
        line([(i-1)+.5 (i-1)+.5],lineYCoords, 'LineStyle',':',...
            'Color',lineColor)
    elseif i == 19
        line([(i-1)+.5 (i-1)+.5],lineYCoords, 'LineStyle','--',...
            'Color',lineColor,'LineWidth', 3)
    elseif i == 7 ||i == 13||i == 23||i == 27
        line([(i-1)+.5 (i-1)+.5],lineYCoords, 'LineStyle','--',...
            'Color',lineColor, 'LineWidth', 2)
    end
end

if strcmp(parameter, 'percentFlicker')
    ylim([0 101])
elseif strcmp(parameter, 'fundamentalFrequency')
   ylim([0 150]) 
end


% ylim([0 1])
% ylim([10 1000])
xlim([.5 30.5])
% set(gca, 'YScale','log')
lowerLabelExtents = [.13 .888];

%% -------------- grouping boxes ----------upper layer 100%------------------
topLayer = .072;
numBox = 3;
boxSize = [axesPosition(3)/30*18/numBox 0.06];
for i = 1:numBox
    textBoxCoords(i,:) = [boxSize(1)*(i-1)+lowerLabelExtents(1) topLayer  boxSize];
end
textBoxLabels = {
    'Electronic - good'
    'Magnetic'
    'Electronic - bad'
    };
for i = 1:size(textBoxCoords,1)
    annotation(h,'textbox',...
        textBoxCoords(i,:),...
        'String',textBoxLabels{i},...
        'HorizontalAlignment','center',...
        'FitBoxToText','off');
end

%% -------------- grouping boxes --------------upper layer 50%

topLayer = .072;

numBox = 3;
boxSize = [axesPosition(3)/30*12/numBox 0.06];
for i = 1:numBox
    textBoxCoords(i,:) = [boxSize(1)*(i-1)+lowerLabelExtents(1)+axesPosition(3)/30*18 topLayer  boxSize];
end
textBoxLabels = {
    'Electronic - good'
    'Magnetic'
    'Electronic - bad'
    };
for i = 1:size(textBoxCoords,1)
    annotation(h,'textbox',...
        textBoxCoords(i,:),...
        'String',textBoxLabels{i},...
        'HorizontalAlignment','center',...
        'FitBoxToText','off');
end

%% -----------------grouping boxes-------------- lower layer text boxes
topLayer = .012;
numBox = 2;
boxSize = [diff(lowerLabelExtents)/numBox 0.06];

textBoxCoords2 = [
    lowerLabelExtents(1) topLayer  axesPosition(3)/30*18 0.06
    axesPosition(3)/30*18+lowerLabelExtents(1) topLayer  axesPosition(3)/30*12 0.06
    ];

textBoxLabels2 = {
    'Dim at 100%'
    'Dim at 50%'
    };
for i = 1:size(textBoxCoords2,1)
    annotation(h,'textbox',...
        textBoxCoords2(i,:),...
        'String',textBoxLabels2{i},...
        'HorizontalAlignment','center',...
        'FitBoxToText','off');
end


% save('MR16_reduced.mat','reduced')

%% -------------- Include failed lamp indicators --------------------
axes2Position = [axesPosition(1) .9 axesPosition(3) .08];
axes2 = axes('Position',axes2Position,...
    'XTickLabel', {},...
    'YTickLabel', {}...
    );    %create axes with same x dimensions and limits
% offMarkerLevel = .5;
% offMarkerLevel = 50;
offMarkerLevel = 0.5;
hold all
% for i = 1:size(allFlickerMetrics,1)
%     offInd = find(lampOffOrFlickering(i,:));
%     %     plot(axes2,offInd+(rand(1)-.5)*.5,...
%     %         ones(size(offInd))*(offMarkerLevel+(rand(1)-.5)*offMarkerLevel),...
% numOff = length(offInd);
%     plot(axes2,offInd,...
%         1/(numOff+1):1/(numOff+1):(numOff)/(numOff+1),...
%         'Marker','x','MarkerSize',20,...
%         'Color',colorList(i,:),'LineStyle','none',...
%         'LineWidth',3)
%     xlim(axes2, [0.5,30.5]);
% end

for i = 1:size(allFlickerMetrics,2) %loop over test conditions
    offInd = find(lampOffOrFlickering(:,i)); %all off lamps for that test condition
    numOff = length(offInd);
    for j = 1:numOff
        %     plot(axes2,offInd+(rand(1)-.5)*.5,...
        %         ones(size(offInd))*(offMarkerLevel+(rand(1)-.5)*offMarkerLevel),...
        
        plot(axes2,i, j/(numOff+1),...
            'Marker','x','MarkerSize',20,...
            'Color',colorList(offInd(j),:),'LineStyle','none',...
            'LineWidth',3)
        xlim(axes2, [0.5,30.5]);
    end
end

% lineCoord = [axes2Position(2) 0.925378151260504];
lineYCoords = [0 1];
lineSpacing = axesPosition(3)/30;
omitLines = [7 13 19 23 27];
for i = 1:30
    if ~sum(i==omitLines)
        line([(i-1)+.5 (i-1)+.5],lineYCoords, 'LineStyle',':',...
            'Color',lineColor)
    elseif i == 19
        line([(i-1)+.5 (i-1)+.5],lineYCoords, 'LineStyle','--',...
            'Color',lineColor,'LineWidth', 3)
    elseif i == 7 ||i == 13||i == 23||i == 27
        line([(i-1)+.5 (i-1)+.5],lineYCoords, 'LineStyle','--',...
            'Color',lineColor, 'LineWidth', 2)
    end
end

xlim(axes2, [0.5,30.5]);
% ylim(axes4, [0 1]);
ylabel('failed lamps')
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


