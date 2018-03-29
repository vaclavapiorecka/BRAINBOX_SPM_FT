%% Statistika na elektrodách
% ===========================================================
% vstup:    absolute power 1Hz bands, saline (soubor: statdataPSISAL.mat)
% výstup:   statistika elektrod, (RC01ElectrodeStatisticPSISAL.mat)
% POROVNÁNÍ PSILOCIN VS. SALINE
% ===========================================================
%%

clc; clear all; close all;

load('statdataPSISAL.mat')

namesOfMeasurments = fieldnames(statdata);
numberOfMeasurments = size(namesOfMeasurments);
[numOfMeas, numOfFreq, numOfEl] = size(statdata.(namesOfMeasurments{1}).data);
numberOfAllData = 0;

h = waitbar(0,'Please wait...');
steps = numOfEl*numOfFreq/4;

resultOfTestingCorrTime.time01time02 = zeros(numOfFreq/4,numOfEl);
resultOfTestingCorrTime.time01time03 = zeros(numOfFreq/4,numOfEl);
resultOfTestingCorrTime.time01time04 = zeros(numOfFreq/4,numOfEl);

resultOfTestingCorrTreat.time01 = zeros(numOfFreq/4,numOfEl);
resultOfTestingCorrTreat.time02 = zeros(numOfFreq/4,numOfEl);
resultOfTestingCorrTreat.time03 = zeros(numOfFreq/4,numOfEl);
resultOfTestingCorrTreat.time04 = zeros(numOfFreq/4,numOfEl);

hypothesisTable = zeros(numOfFreq/4,numOfEl);

for NOE = 1 : 1 : numOfEl
    for NOF = 1 : 1 : (numOfFreq/4)
        for NUM = 1 : 1 : numberOfMeasurments(1)
            
            numOfMeas = size(statdata.(namesOfMeasurments{NUM}).data,1);
            
            dataToMatrix((numberOfAllData+1):(numberOfAllData + numOfMeas),1) = statdata.(namesOfMeasurments{NUM}).data(:,NOF,NOE);
            dataToMatrix((numberOfAllData+1):(numberOfAllData + numOfMeas),2) = statdata.(namesOfMeasurments{NUM}).data(:,NOF+50,NOE);
            dataToMatrix((numberOfAllData+1):(numberOfAllData + numOfMeas),3) = statdata.(namesOfMeasurments{NUM}).data(:,NOF+100,NOE);
            dataToMatrix((numberOfAllData+1):(numberOfAllData + numOfMeas),4) = statdata.(namesOfMeasurments{NUM}).data(:,NOF+150,NOE);
            
            position = find(cellfun(@isempty,statdata.(namesOfMeasurments{NUM}).nameOfTreatment));
            
            helpNamesToMatrix = statdata.(namesOfMeasurments{NUM}).nameOfTreatment;
            helpNamesToMatrix(position) = [];
            
            namesToMatrix((numberOfAllData+1):(numberOfAllData + numOfMeas),1) = helpNamesToMatrix;
            
            numberOfAllData = numberOfAllData + numOfMeas;
            
        end
        numberOfAllData = 0;
        tableMeasurment = table(namesToMatrix,dataToMatrix(:,1),dataToMatrix(:,2),dataToMatrix(:,3),dataToMatrix(:,4),...
            'VariableNames',{'Treatment','cas01','cas02','cas03','cas04'});
        
        MeasOfData = dataset([1 2 3 4]','VarNames',{'Times'});
        
        dataForRanova = fitrm(tableMeasurment,'cas01-cas04~Treatment','WithinDesign',MeasOfData);
        [ranovaTableFinal] = ranova(dataForRanova);
        
        hypothesisTable(NOF,NOE) = ranovaTableFinal.pValueGG(1)<0.05;
        
        resultsTimes = multcompare(dataForRanova,'Times','By','Treatment','ComparisonType','bonferroni');
        resultOfTestingCorrTime.time01time02(NOF,NOE) = resultsTimes.pValue(1)<0.05;
        resultOfTestingCorrTime.time01time03(NOF,NOE) = resultsTimes.pValue(2)<0.05;
        resultOfTestingCorrTime.time01time04(NOF,NOE) = resultsTimes.pValue(3)<0.05;
        
        resultsTreatment = multcompare(dataForRanova,'Treatment','By','Times','ComparisonType','bonferroni');
        resultOfTestingCorrTreat.time01(NOF,NOE) = resultsTreatment.pValue(1)<0.05;
        resultOfTestingCorrTreat.time02(NOF,NOE) = resultsTreatment.pValue(3)<0.05;
        resultOfTestingCorrTreat.time03(NOF,NOE) = resultsTreatment.pValue(5)<0.05;
        resultOfTestingCorrTreat.time04(NOF,NOE) = resultsTreatment.pValue(7)<0.05;
        
        
        if resultsTreatment.Difference(1)<0
            dirre.time01(NOF,NOE) = -1;
        else
            dirre.time01(NOF,NOE) = 1;
        end
        
        if resultsTreatment.Difference(3)<0
            dirre.time02(NOF,NOE) = -1;
        else
            dirre.time02(NOF,NOE) = 1;
        end
        
        if resultsTreatment.Difference(5)<0
            dirre.time03(NOF,NOE) = -1;
        else
            dirre.time03(NOF,NOE) = 1;
        end
        
        if resultsTreatment.Difference(7)<0
            dirre.time04(NOF,NOE) = -1;
        else
            dirre.time04(NOF,NOE) = 1;
        end
    end
    
    waitbar(((NOE-1)*NOF+NOF) / steps)
end

resultTableAnovaP.time01 = resultOfTestingCorrTreat.time01.*dirre.time01;
resultTableAnovaP.time02 = resultOfTestingCorrTreat.time02.*dirre.time02;
resultTableAnovaP.time03 = resultOfTestingCorrTreat.time03.*dirre.time03;
resultTableAnovaP.time04 = resultOfTestingCorrTreat.time04.*dirre.time04;
% Výsledek pro hladinu významnosti 0,05 - matice obsahuje -1 (snížení
% aktivity),0 (bez signifikantních zmìn),1 (zvýšení aktivity)


save RC01ElectrodeStatisticPSISAL.mat resultTableAnovaP dirre resultOfTestingCorrTreat

%% Výstupy
% resultTableAnovaP - finální tabulka s vyznaèením smìru signifikatní zmìny 
% dirre             - smìr signifikantní zmìny
% resultOfTestingCorrTreat     - test RANOVA po multcompare - rozlišení jednotlivých èasù
%%