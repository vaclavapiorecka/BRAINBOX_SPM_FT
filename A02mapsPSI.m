%% Prepocet dat pro spline, Výpoèet map pro jednotlivá mìøení.
% ===========================================================
% vstup:    absolute power 1Hz bands, psilocin (soubor: psilocin.mat)
% výstup:   absolute power 1Hz bands mapované na mozek, (soubor: RA02mapsPSI.mat)
% ===========================================================
%%

%% Inicializace
clc; clear all; close all;

% Naètení dat
load('psilocin.mat')    % psilocin (variable)

% Naètení modelu
[v, f, n, c, stltitle] = stlread('Isocortex/Isocortex_LOWres.stl');
brain.POS1 = v;
brain.TRI1 = f;

% Naètení elektrod
load('RATModel_12electrodes.mat')   % electrodes (variable)

[ numberOfMeasurments, numberOfFrequency, numberOfElectrodes ] = size(psilocin.data);
numberOfFrequency = numberOfFrequency/4;

[ center, radius ] = fitOnSphere( brain.POS1 );
[ projectedPoints ] = projectionOnSphere( brain.POS1, center, radius);
[ projectedElectrodes ] = projectionOnSphere( electrodes, center, radius);

%% Úprava dat podle poøadí elektrod pro spline mapování, Rozdìlení dat na jednotlivé èasy
psilocin.redata(:,:,1) = psilocin.data(:,:,1);
psilocin.redata(:,:,2) = psilocin.data(:,:,7);
psilocin.redata(:,:,3) = psilocin.data(:,:,2);
psilocin.redata(:,:,4) = psilocin.data(:,:,8);
psilocin.redata(:,:,5) = psilocin.data(:,:,5);
psilocin.redata(:,:,6) = psilocin.data(:,:,11);
psilocin.redata(:,:,7) = psilocin.data(:,:,3);
psilocin.redata(:,:,8) = psilocin.data(:,:,9);
psilocin.redata(:,:,9) = psilocin.data(:,:,4);
psilocin.redata(:,:,10) = psilocin.data(:,:,10);
psilocin.redata(:,:,11) = psilocin.data(:,:,6);
psilocin.redata(:,:,12) = psilocin.data(:,:,12);

time01 = psilocin.redata(:,1:50,:);
time02 = psilocin.redata(:,51:100,:);
time03 = psilocin.redata(:,101:150,:);
time04 = psilocin.redata(:,151:200,:);

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

save RA02mapsPSI.mat maps01 maps02 maps03 maps04