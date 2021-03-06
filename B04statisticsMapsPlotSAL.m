%% Prepocet dat pro spline, V�po�et map pro jednotliv� m��en�.
% ===========================================================
% vstup:    statistick� mapa pro absolute power 1Hz bands, saline (soubor: RB03statisticsMapsTreatSAL.mat)
% v�stup:   v�sledn� mapy, slo�ka MAPS
% ===========================================================
%%

%% Inicializace
clc; clear all; close all;

load('RB03statisticsMapsTreatSAL.mat');                                 % statistika map: tableAnova, tableAnovaDirr, tableAnovaF, tableAnovaP
electrodesSTAT = load('RB01ElectrodeStatisticSAL.mat');     % statistika elektrod: tableAnovaP


% Na�ten� modelu
[v, f, n, c, stltitle] = stlread('Isocortex/Isocortex_LOWres.stl');
brain.POS1 = v;
brain.TRI1 = f;

POS1 = v;
TRI1 = f;

numOfPoints = size(POS1,1);
% Na�ten� elektrod
load('RATModel_12electrodes.mat')   % electrodes (variable)

electrodeNames = {'F4';'F3';'C4';'C3';'T4';'T3';'P4';'P3';'P6';'P5';'T6';'T5'};
frequencyBands = 1 : 1 : 50;

path01 = 'D:/users/sedlmajerova/Documents/MATLAB/BRAINBOX_SPMFilip/MAPS/SAL/2030minutes/';
path02 = 'D:/users/sedlmajerova/Documents/MATLAB/BRAINBOX_SPMFilip/MAPS/SAL/5060minutes/';
path03 = 'D:/users/sedlmajerova/Documents/MATLAB/BRAINBOX_SPMFilip/MAPS/SAL/8090minutes/';

% Barvy - definice
% Zv��en�
colour_peach = [251 111 66] ./ 255;
colour_red = [1 0 0];
colour_darkred = [0.8078 0.0627 0.0627];
colour_elecs_POS = [255, 192, 0] ./ 255;

% Sn�en�
colour_lightblue = [8 180 238] ./ 255;
colour_teal = [18 150 155] ./ 255;
colour_darkblue = [1 17 181] ./ 255;
colour_elecs_NEG = [0, 176, 240] ./ 255;
% Standard
colour_standard = [0.5 0.5 0.5];

numOfFreq= size(frequencyBands,2);

% Vytvo�en� map - ur�en� zm�ny
% -1 * .. kv�li prohozen� polarity. Filip cht�l saline vs. psilocin
mapa01 = tableAnova.time01time02<0.05 .* tableAnovaDirr.time01time02;
mapa02 = tableAnova.time01time03<0.05 .* tableAnovaDirr.time01time03;
mapa03 = tableAnova.time01time04<0.05 .* tableAnovaDirr.time01time04;

mapa01 = -1*mapa01;
mapa02 = -1*mapa02;
mapa03 = -1*mapa03;

%% Mapov�n� v �ase 20-30 min vs. BASELINE
for NOF = 1 : 1 : numOfFreq
    

    color01= zeros(numOfPoints,3);
    ind = mapa01(NOF,:) == 0;
    color01(ind,1) = colour_standard(1,1);
    color01(ind,2) = colour_standard(1,2);
    color01(ind,3) = colour_standard(1,3);
    
    ind = mapa01(NOF,:) == 1;
    color01(ind,1) = colour_peach(1,1);
    color01(ind,2) = colour_peach(1,2);
    color01(ind,3) = colour_peach(1,3);
    
    ind = mapa01(NOF,:) == -1;
    color01(ind,1) = colour_lightblue(1,1);
    color01(ind,2) = colour_lightblue(1,2);
    color01(ind,3) = colour_lightblue(1,3);
    
    figure('Color','white','Name','H: significant maps')
    patch('vertices', POS1, 'faces', TRI1, 'FaceVertexCData', color01, 'FaceColor','interp', 'EdgeColor', 'none')
    camlight('headlight');
    material('dull');
    hold on;
    
    for i = 1 : 1 : 12
        if (electrodesSTAT.resultTableAnovaP.time01time02(NOF,i)==-1)
            scatter3(electrodes(i,1),electrodes(i,2),electrodes(i,3),'MarkerEdgeColor','k','MarkerFaceColor',colour_elecs_POS)
        elseif (electrodesSTAT.resultTableAnovaP.time01time02(NOF,i)==1)
            scatter3(electrodes(i,1),electrodes(i,2),electrodes(i,3),'MarkerEdgeColor','k','MarkerFaceColor',colour_elecs_NEG)
        else
            scatter3(electrodes(i,1),electrodes(i,2),electrodes(i,3),'MarkerEdgeColor','k','MarkerFaceColor',[0 0 0])
        end
    end
    hold on;
    for i=1:1:12
        text(electrodes(i,1),(electrodes(i,2)+0.5),(electrodes(i,3)+0.5),electrodeNames{i},'FontSize',12,'FontWeight','bold')
        hold on;
    end
    str=sprintf('H, Frequency band %s Hz, saline, 20-30 min. vs. baseline.',num2str(frequencyBands(1,NOF)));
    title(str)
    
    axis('image'); axis off;
    
    fileSave = strcat(path01,str,'png');
    saveas(NOF,fileSave);
    close(figure(NOF))
    
    %% Mapov�n� v �ase 50-60 min vs. BASELINE
    color02= zeros(numOfPoints,3);
    ind = mapa02(NOF,:) == 0;
    color02(ind,1) = colour_standard(1,1);
    color02(ind,2) = colour_standard(1,2);
    color02(ind,3) = colour_standard(1,3);
    
    ind = mapa02(NOF,:) == 1;
    color02(ind,1) = colour_peach(1,1);
    color02(ind,2) = colour_peach(1,2);
    color02(ind,3) = colour_peach(1,3);
    
    ind = mapa02(NOF,:) == -1;
    color02(ind,1) = colour_lightblue(1,1);
    color02(ind,2) = colour_lightblue(1,2);
    color02(ind,3) = colour_lightblue(1,3);
    
    figure('Color','white','Name','H: significant maps')
    
    patch('vertices', POS1, 'faces', TRI1, 'FaceVertexCData', color02, 'FaceColor','interp', 'EdgeColor', 'none')
    camlight('headlight');
    material('dull');
    hold on;
    
    for i = 1 : 1 : 12
        if (electrodesSTAT.resultTableAnovaP.time01time03(NOF,i)==-1)
            scatter3(electrodes(i,1),electrodes(i,2),electrodes(i,3),'MarkerEdgeColor','k','MarkerFaceColor',colour_elecs_POS)
        elseif (electrodesSTAT.resultTableAnovaP.time01time03(NOF,i)==1)
            scatter3(electrodes(i,1),electrodes(i,2),electrodes(i,3),'MarkerEdgeColor','k','MarkerFaceColor',colour_elecs_NEG)
        else
            scatter3(electrodes(i,1),electrodes(i,2),electrodes(i,3),'MarkerEdgeColor','k','MarkerFaceColor',[0 0 0])
        end
    end
    hold on;
    for i=1:1:12
        text(electrodes(i,1),(electrodes(i,2)+0.5),(electrodes(i,3)+0.5),electrodeNames{i},'FontSize',12,'FontWeight','bold')
        hold on;
    end
    str=sprintf('H, Frequency band %s Hz, saline, 50-60 min. vs. baseline.',num2str(frequencyBands(1,NOF)));
    title(str)
    
    axis('image'); axis off;
    
    fileSave = strcat(path02,str,'png');
    saveas(NOF,fileSave);
    close(figure(NOF))
    
    % Mapov�n� v �ase 50-60 min
    color03= zeros(numOfPoints,3);
    ind = mapa03(NOF,:) == 0;
    color03(ind,1) = colour_standard(1,1);
    color03(ind,2) = colour_standard(1,2);
    color03(ind,3) = colour_standard(1,3);
    
    ind = mapa03(NOF,:) == 1;
    color03(ind,1) = colour_peach(1,1);
    color03(ind,2) = colour_peach(1,2);
    color03(ind,3) = colour_peach(1,3);
    
    ind = mapa03(NOF,:) == -1;
    color03(ind,1) = colour_lightblue(1,1);
    color03(ind,2) = colour_lightblue(1,2);
    color03(ind,3) = colour_lightblue(1,3);
    
    figure('Color','white','Name','H: significant maps')
    patch('vertices', POS1, 'faces', TRI1, 'FaceVertexCData', color03, 'FaceColor','interp', 'EdgeColor', 'none')
    camlight('headlight');
    material('dull');
    hold on;
    
    for i = 1 : 1 : 12
        if (electrodesSTAT.resultTableAnovaP.time01time04(NOF,i)==-1)
            scatter3(electrodes(i,1),electrodes(i,2),electrodes(i,3),'MarkerEdgeColor','k','MarkerFaceColor',colour_elecs_POS)
        elseif (electrodesSTAT.resultTableAnovaP.time01time04(NOF,i)==1)
            scatter3(electrodes(i,1),electrodes(i,2),electrodes(i,3),'MarkerEdgeColor','k','MarkerFaceColor',colour_elecs_NEG)
        else
            scatter3(electrodes(i,1),electrodes(i,2),electrodes(i,3),'MarkerEdgeColor','k','MarkerFaceColor',[0 0 0])
        end
    end
    hold on;
    for i=1:1:12
        text(electrodes(i,1),(electrodes(i,2)+0.5),(electrodes(i,3)+0.5),electrodeNames{i},'FontSize',12,'FontWeight','bold')
        hold on;
    end
    str=sprintf('H, Frequency band %s Hz, saline, 80-90 min. vs. baseline.',num2str(frequencyBands(1,NOF)));
    title(str)
    
    axis('image'); axis off;
    
    fileSave = strcat(path03,str,'png');
    saveas(NOF,fileSave);
end

close all;