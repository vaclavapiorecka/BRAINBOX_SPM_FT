%% Statistika na elektrodách
% ===========================================================
% vstup:    absolute power 1Hz bands, psilocin (soubor: psilocin.mat)
% výstup:   standard deviation, (soubor: RA01SDPSI.mat)
%           mean, (soubor: RA01MeanPSI.mat)
%           statistika elektrod, (RA01ElectrodeStatisticPSI.mat)
% ===========================================================
%%

clc; clear all; close all;

load('psilocin.mat')

time01 = psilocin.data(:,1:50,:);
time02 = psilocin.data(:,51:100,:);
time03 = psilocin.data(:,101:150,:);
time04 = psilocin.data(:,151:200,:);

SD.time01 = squeeze(std(time01,0,1));
SD.time02 = squeeze(std(time02,0,1));
SD.time03 = squeeze(std(time03,0,1));
SD.time04 = squeeze(std(time04,0,1));

save RA01SDPSI.mat SD

MEAN.time01 = squeeze(mean(time01,1));
MEAN.time02 = squeeze(mean(time02,1));
MEAN.time03 = squeeze(mean(time03,1));
MEAN.time04 = squeeze(mean(time04,1));

save RA01MeanPSI.mat MEAN

% Statistika samotná
[numOfMeas, numOfFreq, numOfEl] = size(time01);
namesToMatrix = ['psilocin'; 'psilocin'; 'psilocin'; 'psilocin'; 'psilocin'; 'psilocin'; 'psilocin'; 'psilocin'];
tableAnovaP01 = zeros(numOfEl,numOfFreq);   %
  

for NOE = 1 : 1 : numOfEl
    for NOF = 1 : 1 : numOfFreq
        
        dataToMatrix(1:numOfMeas,1) = time01(:,NOF,NOE);
        dataToMatrix(1:numOfMeas,2) = time02(:,NOF,NOE);
        dataToMatrix(1:numOfMeas,3) = time03(:,NOF,NOE);
        dataToMatrix(1:numOfMeas,4) = time04(:,NOF,NOE);
        
        tableMeasurment = table(namesToMatrix,dataToMatrix(:,1),dataToMatrix(:,2),dataToMatrix(:,3),dataToMatrix(:,4),...
            'VariableNames',{'Treatment','cas01','cas02','cas03','cas04'});
        
        MeasOfData = dataset([1 2 3 4]','VarNames',{'Times'});
        
        dataForRanova = fitrm(tableMeasurment,'cas01-cas04~1','WithinDesign',MeasOfData);
        ranovaTableFinal = ranova(dataForRanova);
        tableAnovaP01(NOF, NOE) = ranovaTableFinal.pValueGG(1);
        resultsTimes = multcompare(dataForRanova,'Times','ComparisonType','bonferroni');
        
        % Tabulka pro jednotlivé èasy, tímto beru hodnoty pro èas 2 vs.
        % èas 1, èas 3 vs. èas 1 a èas 4 vs. èas 1
        tableAnovaP.time01time02(NOF,NOE) = resultsTimes.pValue(4);
        tableAnovaP.time01time03(NOF,NOE) = resultsTimes.pValue(7);
        tableAnovaP.time01time04(NOF,NOE) = resultsTimes.pValue(10);
        
        % dirre - smìr zmìny, opìt pro jednotlivé èasy
        if resultsTimes.Difference(4)<0
            dirre.time01time02(NOF,NOE) = -1;
        else
            dirre.time01time02(NOF,NOE) = 1;
        end
        
        if resultsTimes.Difference(7)<0
            dirre.time01time03(NOF,NOE) = -1;
        else
            dirre.time01time03(NOF,NOE) = 1;
        end
        
        if resultsTimes.Difference(10)<0
            dirre.time01time04(NOF,NOE) = -1;
        else
            dirre.time01time04(NOF,NOE) = 1;
        end
        
    end
end

% Výsledek pro hladinu významnosti 0,05 - matice obsahuje -1 (snížení
% aktivity),0 (bez signifikantních zmìn),1 (zvýšení aktivity)
resultTableAnovaP.time01time02 = double(tableAnovaP.time01time02<0.05).*dirre.time01time02;
resultTableAnovaP.time01time03 = double(tableAnovaP.time01time03<0.05).*dirre.time01time03;
resultTableAnovaP.time01time04 = double(tableAnovaP.time01time04<0.05).*dirre.time01time04;

save RA01ElectrodeStatisticPSI.mat resultTableAnovaP dirre tableAnovaP tableAnovaP01

%% Výstupy
% resultTableAnovaP - finální tabulka s vyznaèením smìru signifikatní zmìny 
% dirre             - smìr signifikantní zmìny
% tableAnovaP       - originální test RANOVA 
% tableAnovaP01     - test RANOVA po multcompare - rozlišení jednotlivých èasù
%%