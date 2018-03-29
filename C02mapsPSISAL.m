%% Prepocet dat pro spline, Výpoèet map pro jednotlivá mìøení.
% ===========================================================
% vstup:    absolute power 1Hz bands, psilocin a saline (soubor: statdataPSISAL.mat)
% výstup:   absolute power 1Hz bands mapované na mozek, (soubor: RC02mapsPSISAL.mat)
% POROVNÁNÍ PSILOCIN VS. SALINE
% ===========================================================
%%

%% Inicializace
clc; clear all; close all;

load('statdataPSISAL.mat')

% Naètení modelu
[v, f, n, c, stltitle] = stlread('Isocortex/Isocortex_LOWres.stl');
brain.POS1 = v;
brain.TRI1 = f;

% Naètení elektrod
load('RATModel_12electrodes.mat')   % electrodes (variable)

[ numberOfMeasurmentsPSI, numberOfFrequency, numberOfElectrodes ] = size(statdata.psilocin.data);
[ numberOfMeasurmentsSAL ] = size(statdata.saline.data,1);
numberOfFrequency = numberOfFrequency/4;

[ center, radius ] = fitOnSphere( brain.POS1 );
[ projectedPoints ] = projectionOnSphere( brain.POS1, center, radius);
[ projectedElectrodes ] = projectionOnSphere( electrodes, center, radius);

%% Úprava dat podle poøadí elektrod pro spline mapování, Rozdìlení dat na jednotlivé èasy
statdata.psilocin.redata(:,:,1) = statdata.psilocin.data(:,:,1);
statdata.psilocin.redata(:,:,2) = statdata.psilocin.data(:,:,7);
statdata.psilocin.redata(:,:,3) = statdata.psilocin.data(:,:,2);
statdata.psilocin.redata(:,:,4) = statdata.psilocin.data(:,:,8);
statdata.psilocin.redata(:,:,5) = statdata.psilocin.data(:,:,5);
statdata.psilocin.redata(:,:,6) = statdata.psilocin.data(:,:,11);
statdata.psilocin.redata(:,:,7) = statdata.psilocin.data(:,:,3);
statdata.psilocin.redata(:,:,8) = statdata.psilocin.data(:,:,9);
statdata.psilocin.redata(:,:,9) = statdata.psilocin.data(:,:,4);
statdata.psilocin.redata(:,:,10) = statdata.psilocin.data(:,:,10);
statdata.psilocin.redata(:,:,11) = statdata.psilocin.data(:,:,6);
statdata.psilocin.redata(:,:,12) = statdata.psilocin.data(:,:,12);

times.psilocin.time01 = statdata.psilocin.redata(:,1:50,:);
times.psilocin.time02 = statdata.psilocin.redata(:,51:100,:);
times.psilocin.time03 = statdata.psilocin.redata(:,101:150,:);
times.psilocin.time04 = statdata.psilocin.redata(:,151:200,:);


statdata.saline.redata(:,:,1) = statdata.saline.data(:,:,1);
statdata.saline.redata(:,:,2) = statdata.saline.data(:,:,7);
statdata.saline.redata(:,:,3) = statdata.saline.data(:,:,2);
statdata.saline.redata(:,:,4) = statdata.saline.data(:,:,8);
statdata.saline.redata(:,:,5) = statdata.saline.data(:,:,5);
statdata.saline.redata(:,:,6) = statdata.saline.data(:,:,11);
statdata.saline.redata(:,:,7) = statdata.saline.data(:,:,3);
statdata.saline.redata(:,:,8) = statdata.saline.data(:,:,9);
statdata.saline.redata(:,:,9) = statdata.saline.data(:,:,4);
statdata.saline.redata(:,:,10) = statdata.saline.data(:,:,10);
statdata.saline.redata(:,:,11) = statdata.saline.data(:,:,6);
statdata.saline.redata(:,:,12) = statdata.saline.data(:,:,12);

times.saline.time01 = statdata.saline.redata(:,1:50,:);
times.saline.time02 = statdata.saline.redata(:,51:100,:);
times.saline.time03 = statdata.saline.redata(:,101:150,:);
times.saline.time04 = statdata.saline.redata(:,151:200,:);

%% Výpoèet jednotlivých map
% Alokace promìných
numberOfPoints = size(brain.POS1,1);
maps.psilocin.maps01 = zeros(numberOfMeasurmentsPSI, numberOfFrequency, numberOfPoints);
maps.psilocin.maps02 = zeros(numberOfMeasurmentsPSI, numberOfFrequency, numberOfPoints);
maps.psilocin.maps03 = zeros(numberOfMeasurmentsPSI, numberOfFrequency, numberOfPoints);
maps.psilocin.maps04 = zeros(numberOfMeasurmentsPSI, numberOfFrequency, numberOfPoints);

maps.saline.maps01 = zeros(numberOfMeasurmentsSAL, numberOfFrequency, numberOfPoints);
maps.saline.maps02 = zeros(numberOfMeasurmentsSAL, numberOfFrequency, numberOfPoints);
maps.saline.maps03 = zeros(numberOfMeasurmentsSAL, numberOfFrequency, numberOfPoints);
maps.saline.maps04 = zeros(numberOfMeasurmentsSAL, numberOfFrequency, numberOfPoints);

% Výpoèet map
for NOF = 1 : 1 : numberOfFrequency
    for NOM = 1 : 1 : numberOfMeasurmentsPSI
        
        maps.psilocin.maps01(NOM,NOF,:) = splineInt_threeD( projectedPoints, projectedElectrodes, squeeze(times.psilocin.time01(NOM,NOF,:))' ); 
        maps.psilocin.maps02(NOM,NOF,:) = splineInt_threeD( projectedPoints, projectedElectrodes, squeeze(times.psilocin.time02(NOM,NOF,:))' );
        maps.psilocin.maps03(NOM,NOF,:) = splineInt_threeD( projectedPoints, projectedElectrodes, squeeze(times.psilocin.time03(NOM,NOF,:))' );
        maps.psilocin.maps04(NOM,NOF,:) = splineInt_threeD( projectedPoints, projectedElectrodes, squeeze(times.psilocin.time04(NOM,NOF,:))' );
        
    end
end

for NOF = 1 : 1 : numberOfFrequency
    for NOM = 1 : 1 : numberOfMeasurmentsSAL
        
        maps.saline.maps01(NOM,NOF,:) = splineInt_threeD( projectedPoints, projectedElectrodes, squeeze(times.saline.time01(NOM,NOF,:))' ); 
        maps.saline.maps02(NOM,NOF,:) = splineInt_threeD( projectedPoints, projectedElectrodes, squeeze(times.saline.time02(NOM,NOF,:))' );
        maps.saline.maps03(NOM,NOF,:) = splineInt_threeD( projectedPoints, projectedElectrodes, squeeze(times.saline.time03(NOM,NOF,:))' );
        maps.saline.maps04(NOM,NOF,:) = splineInt_threeD( projectedPoints, projectedElectrodes, squeeze(times.saline.time04(NOM,NOF,:))' );
        
    end
end

save RC02mapsPSISAL.mat maps
