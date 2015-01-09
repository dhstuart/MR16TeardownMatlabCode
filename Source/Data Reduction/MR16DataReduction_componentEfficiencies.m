function out = MR16DataReduction_componentEfficiencies(b, testMatrix, groupDrivers)

% temp_lamp_number = [1:11];
lampNames = fieldnames(b);

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
locations = {
    'Dimmer'
    'Transformer'
    'Driver'
    'System'
    };
xTickLabels = {
    'Dimmer '
    'Transformer '
    'Driver '
    };
prettyName.transformer = {
    'good electronic'
    'magnetic'
    'bad electronic'
    };
prettyName.dimmer = {
    'none'
    'reverse phase'
    'forward phase'
    };
prettyName.dimLevel = {
    '100%'
    '50%'
    };
prettyName.lampNumber = {
    '4'
    '1'
    };

property = 'Efficiency';
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

%% Plot efficiencies for each test condition and location
dum = 0;
for l = 1:length(dim_levels);dim_level = dim_levels{l};
    for j = 1:length(transformers);transformer = transformers{j};
        for k = 1:length(dimmers);dimmer = dimmers{k};
            for m = 1:length(lamp_numbers);lamp_number = lamp_numbers{m};
                if k == 1 && l == 2
                else
                    dum = dum+1;
                    figure1 = figure('Position',[1 1 1010 400]);
                    
                    axes1 = axes('Parent', figure1,'XTickLabel', xTickLabels,'XTick',1:3);
                    %                     rotateXLabels(gca,90)
                    hold all
                    for i = 1:length(lampNames);lamp = snake_case(lampNames{i});
                        for n = 1:length(locations)
                            Eprops(i,n) = b.(lamp).(transformer).(dimmer).(dim_level).(lamp_number).Eprops.(locations{n}).(property);
                        end
                        %                         plot(Eprops, 'Parent',axes1,'Color',colorList(i,:),'LineWidth',3)
                        
                        
                    end
                    out.Dimmer(:,dum) = Eprops(:,1);
                    out.Transformer(:,dum) = Eprops(:,2);
                    out.Driver(:,dum) = Eprops(:,3);
                    out.System(:,dum) = Eprops(:,4);
                    bar_child = bar(Eprops','Parent',axes1);%,'FaceColor',colorList,'LineWidth',3)
                    colormap(colorList)
                    set(bar_child,'CDataMapping','direct');
                    %                     set(bar_child,'CData',1:length(lampNames));
                    titleText = strrep({['Transformer: ' prettyName.transformer{j}];
                        ['Dimmer: ' prettyName.dimmer{k}];
                        ['Dim level: ' prettyName.dimLevel{l}];
                        ['Number of Lamps: ' prettyName.lampNumber{m}];},'_',' ');
                    title(titleText)
                    
                    %----------legend---------------
                    if groupDrivers == 1
                        separator = repmat({' - '},length(sortedTopologies),1);
                        legend(strcat(sortedTopologies, separator, strrep(lampNames, '_', ' ')),'Location','SouthEastOutside')
                    else
                        legend(strrep(lampNames, '_', ' '),'Location','SouthEastOutside')
                    end
                    %                     legend(strrep(lampNames, '_', ' '),'Location','southEastOutside')
                    grid on
                    %                     ylim([0 1])
                    ylabel('Efficiency')
                    xlabel('Lamp Components')
                end
            end
        end
    end
end
out.lampOrder = lampNames;