%% Prepocet dat pro spline, Výpoèet map pro jednotlivá mìøení.
% ===========================================================
% vstup:    absolute power 1Hz bands, saline (soubor: saline.mat)
% výstup:   absolute power 1Hz bands mapované na mozek, (soubor: RA02mapsPSI.mat)
% ===========================================================
%%

%% Inicializace
clc; clear all; close all;

% Naètení dat
load('saline.mat')    % saline (variable)

% Naètení modelu
[v, f, n, c, stltitle] = stlread('Isocortex/Isocortex_LOWres.stl');
brain.POS1 = v;
brain.TRI1 = f;

% Naètení elektrod
load('RATModel_12electrodes.mat')   % electrodes (variable)

[ numberOfMeasurments, numberOfFrequency, numberOfElectrodes ] = size(saline.data);
numberOfFrequency = numberOfFrequency/4;

[ center, radius ] = fitOnSphere( brain.POS1 );
[ projectedPoints ] = projectionOnSphere( brain.POS1, center, radius);
[ projectedElectrodes ] = projectionOnSphere( electrodes, center, radius);

%% Úprava dat podle poøadí elektrod pro spline mapování, Rozdìlení dat na jednotlivé èasy
saline.redata(:,:,1) = saline.data(:,:,1);
saline.redata(:,:,2) = saline.data(:,:,7);
saline.redata(:,:,3) = saline.data(:,:,2);
saline.redata(:,:,4) = saline.data(:,:,8);
saline.redata(:,:,5) = saline.data(:,:,5);
saline.redata(:,:,6) = saline.data(:,:,11);
saline.redata(:,:,7) = saline.data(:,:,3);
saline.redata(:,:,8) = saline.data(:,:,9);
saline.redata(:,:,9) = saline.data(:,:,4);
saline.redata(:,:,10) = saline.data(:,:,10);
saline.redata(:,:,11) = saline.data(:,:,6);
saline.redata(:,:,12) = saline.data(:,:,12);

time01 = saline.redata(:,1:50,:);
time02 = saline.redata(:,51:100,:);
time03 = saline.redata(:,101:150,:);
time04 = saline.redata(:,151:200,:);

%% Výpoèet jednotlivých map
% Alokace promìných
numberOfPoints = size(brain.POS1,1);
maps01 = zeros(numberOfMeasurments, numberOfFrequency, numberOfPoints);
maps02 = zeros(numberOfMeasurments, numberOfFrequency, numberOfPoints);
maps03 = zeros(numberOfMeasurments, numberOfFrequency, numberOfPoints);
maps04 = zeros(numberOfMeasurments, numberOfFrequency, numberOfPoints);

% Výpoèet map
for NOF = 1 : 1 : numberOfFrequency
    for NOM = 1 : 1 : numberOfMeasurments
        
        maps01(NOM,NOF,:) = splineInt_threeD( projectedPoints, projectedElectrodes, squeeze(time01(NOM,NOF,:))' ); 
        maps02(NOM,NOF,:) = splineInt_threeD( projectedPoints, projectedElectrodes, squeeze(time02(NOM,NOF,:))' );
        maps03(NOM,NOF,:) = splineInt_threeD( projectedPoints, projectedElectrodes, squeeze(time03(NOM,NOF,:))' );
        maps04(NOM,NOF,:) = splineInt_threeD( projectedPoints, projectedElectrodes, squeeze(time04(NOM,NOF,:))' );
        
    end
end

save RB02mapsSAL.mat maps01 maps02 maps03 maps04