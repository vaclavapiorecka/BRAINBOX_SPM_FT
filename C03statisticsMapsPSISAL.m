%% Prepocet dat pro spline, Výpoèet map pro jednotlivá mìøení.
% ===========================================================
% vstup:    absolute power 1Hz bandsmapované na mozek, psilocin (soubor: RC02mapsPSISAL.mat)
% výstup:   statistika map, (soubor: RC03statisticsMapsTreatPSI.mat)
% POROVNÁNÍ PSILOCIN VS. SALINE
% ===========================================================
%%

%% Inicializace
clc; clear all; close all;

load('RC02mapsPSISAL.mat')        % load maps. (saline, psilocin - maps01-maps04)
load('statdataPSISAL.mat')

namesOfMeasurments = fieldnames(maps);
numberOfMeasurments = size(namesOfMeasurments);
[numOfMeasPSI, numOfFreq, numOfEl] = size(maps.psilocin.maps01);
[numOfMeasSAL] = size(maps.saline.maps01,1);

numberOfAllData = 0;

h = waitbar(0,'Please wait...');
steps = numOfEl*numOfFreq/4;

resultOfTestingCorrTime.time01time02 = zeros(numOfFreq,numOfEl);
resultOfTestingCorrTime.time01time03 = zeros(numOfFreq,numOfEl);
resultOfTestingCorrTime.time01time04 = zeros(numOfFreq,numOfEl);

resultOfTestingCorrTreat.time01 = zeros(numOfFreq,numOfEl);
resultOfTestingCorrTreat.time02 = zeros(numOfFreq,numOfEl);
resultOfTestingCorrTreat.time03 = zeros(numOfFreq,numOfEl);
resultOfTestingCorrTreat.time04 = zeros(numOfFreq,numOfEl);

hypothesisTable = zeros(numOfFreq,numOfEl);

for NOE = 1 : 1 : numOfEl
    for NOF = 1 : 1 : numOfFreq
        for NUM = 1 : 1 : numberOfMeasurments(1)
            
            numOfMeas = size(maps.(namesOfMeasurments{NUM}).maps01,1);
            
            dataToMatrix((numberOfAllData+1):(numberOfAllData + numOfMeas),1) = maps.(namesOfMeasurments{NUM}).maps01(:,NOF,NOE);
            dataToMatrix((numberOfAllData+1):(numberOfAllData + numOfMeas),2) = maps.(namesOfMeasurments{NUM}).maps02(:,NOF,NOE);
            dataToMatrix((numberOfAllData+1):(numberOfAllData + numOfMeas),3) = maps.(namesOfMeasurments{NUM}).maps03(:,NOF,NOE);
            dataToMatrix((numberOfAllData+1):(numberOfAllData + numOfMeas),4) = maps.(namesOfMeasurments{NUM}).maps04(:,NOF,NOE);
            
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

resultTableAnovaP.time01 = resultOfTestingCorrTreat.time01<0.05.*dirre.time01;
resultTableAnovaP.time02 = resultOfTestingCorrTreat.time02<0.05.*dirre.time02;
resultTableAnovaP.time03 = resultOfTestingCorrTreat.time03<0.05.*dirre.time03;
resultTableAnovaP.time04 = resultOfTestingCorrTreat.time04<0.05.*dirre.time04;