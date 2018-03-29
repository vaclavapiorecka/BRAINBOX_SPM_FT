%% Prepocet dat pro spline, Výpoèet map pro jednotlivá mìøení.
% ===========================================================
% vstup:    absolute power 1Hz bandsmapované na mozek, psilocin (soubor: RA02mapsPSI.mat)
% výstup:   statistika map, (soubor: RA03statisticsMapsTreatPSI.mat)
% ===========================================================
%%

%% Inicializace
clc; clear all; close all;

load('RA02mapsPSI.mat')        % load maps01-maps04
[ numberOfMeasurments, numberOfFrequency, numberOfPoints ] = size(maps01);

tableAnovaF = zeros(numberOfFrequency, numberOfPoints);
tableAnovaP = zeros(numberOfFrequency, numberOfPoints);

MeasOfData = dataset([1 2 3 4]','VarNames',{'Time'});
namesToMatrix = ['psilocin'; 'psilocin'; 'psilocin'; 'psilocin'; 'psilocin'; 'psilocin'; 'psilocin'; 'psilocin'];

steps = numberOfFrequency*numberOfPoints;
h = waitbar(0,'statistic computation...');

%% Statistika
for NOP = 1 : 1 : numberOfPoints
    for NOF = 1 : 1 : numberOfFrequency
        
        dataToMatrix(1:numberOfMeasurments,1) = maps01(:,NOF,NOP);
        dataToMatrix(1:numberOfMeasurments,2) = maps02(:,NOF,NOP);
        dataToMatrix(1:numberOfMeasurments,3) = maps03(:,NOF,NOP);
        dataToMatrix(1:numberOfMeasurments,4) = maps04(:,NOF,NOP);
        

        tableMeasurment = table(namesToMatrix,dataToMatrix(:,1),dataToMatrix(:,2),dataToMatrix(:,3),dataToMatrix(:,4),...
            'VariableNames',{'Subject','cas01','cas02','cas03','cas04'});
        
        dataForRanova = fitrm(tableMeasurment,'cas01-cas04~1','WithinDesign',MeasOfData);
        ranovaTableFinal = ranova(dataForRanova);
        
        tableAnovaF(NOF,NOP) = ranovaTableFinal.F(1);
        tableAnovaP(NOF,NOP) = ranovaTableFinal.pValueGG(1);
        
        tableMultcompare = multcompare(dataForRanova,'Time');
        
        tableAnova.time01time02(NOF,NOP) = tableMultcompare.pValue(1);
        tableAnova.time01time03(NOF,NOP) = tableMultcompare.pValue(2);
        tableAnova.time01time04(NOF,NOP) = tableMultcompare.pValue(3);
        
        if (tableMultcompare.Difference(1)>0)
            tableAnovaDirr.time01time02(NOF,NOP) = 1;
        else
            tableAnovaDirr.time01time02(NOF,NOP) = -1;
        end
        if (tableMultcompare.Difference(2)>0)
            tableAnovaDirr.time01time03(NOF,NOP) = 1;
        else
            tableAnovaDirr.time01time03(NOF,NOP) = -1;
        end
        if (tableMultcompare.Difference(3)>0)
            tableAnovaDirr.time01time04(NOF,NOP) = 1;
        else
            tableAnovaDirr.time01time04(NOF,NOP) = -1;
        end
                
        clear dataToMatrix
    end
    
    stat = ((NOP-1)*numberOfFrequency+NOF) / steps;
    waitbar(stat)

end
