%% Prepocet dat pro spline, Výpoèet map pro jednotlivá mìøení.
% ===========================================================
% vstup:    statistická mapa pro absolute power 1Hz bands, psilocin (soubor: RA03statisticsMapsTreatPSI.mat)
% výstup:   výsledné mapy, (soubor: RC03statisticsMapsTreatPSI.mat)
% POROVNÁNÍ PSILOCIN VS. SALINE
% ===========================================================
%%

%% Inicializace
% POROVNÁNÍ PSILOCIN VS. SALINE
clc; clear all; close all;

load('RC03statisticsMapsTreatPSISAL.mat');                                  % statistika map: tableAnova, tableAnovaDirr, tableAnovaF, tableAnovaP
electrodesSTAT = load('RC01ElectrodeStatisticPSISAL.mat');                  % statistika elektrod: tableAnovaP


% Naètení modelu
[v, f, n, c, stltitle] = stlread('Isocortex/Isocortex_LOWres.stl');
brain.POS1 = v;
brain.TRI1 = f;

POS1 = v;
TRI1 = f;

numOfPoints = size(POS1,1);
% Naètení elektrod
load('RATModel_12electrodes.mat')   % electrodes (variable)

electrodeNames = {'F4';'F3';'C4';'C3';'T4';'T3';'P4';'P3';'P6';'P5';'T6';'T5'};
frequencyBands = 1 : 1 : 50;


path01 = 'D:/users/sedlmajerova/Documents/MATLAB/BRAINBOX_SPMFilip/MAPS/PSISAL/baseline/';
path02 = 'D:/users/sedlmajerova/Documents/MATLAB/BRAINBOX_SPMFilip/MAPS/PSISAL/2030minutes/';
path03 = 'D:/users/sedlmajerova/Documents/MATLAB/BRAINBOX_SPMFilip/MAPS/PSISAL/5060minutes/';
path04 = 'D:/users/sedlmajerova/Documents/MATLAB/BRAINBOX_SPMFilip/MAPS/PSISAL/8090minutes/';

% Barvy - definice
% Zvýšení
colour_peach = [251 111 66] ./ 255;
colour_red = [1 0 0];
colour_darkred = [0.8078 0.0627 0.0627];
colour_elecs_POS = [255, 192, 0] ./ 255;

% Snížení
colour_lightblue = [8 180 238] ./ 255;
colour_teal = [18 150 155] ./ 255;
colour_darkblue = [1 17 181] ./ 255;
colour_elecs_NEG = [0, 176, 240] ./ 255;
% Standard
colour_standard = [0.5 0.5 0.5];

numOfFreq= size(frequencyBands,2);

mapa01 = resultOfTestingCorrTreat.time01 .* dirre.time01;
mapa02 = resultOfTestingCorrTreat.time02 .* dirre.time02;
mapa03 = resultOfTestingCorrTreat.time03 .* dirre.time03;
mapa04 = resultOfTestingCorrTreat.time04 .* dirre.time04;

for NOF = 1 : 1 : numOfFreq
    
    % Mapování v èase baseline
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
        if (electrodesSTAT.resultTableAnovaP.time01(NOF,i)==1)
            scatter3(electrodes(i,1),electrodes(i,2),electrodes(i,3),'MarkerEdgeColor','k','MarkerFaceColor',colour_elecs_POS)
        elseif (electrodesSTAT.resultTableAnovaP.time01(NOF,i)==-1)
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
    str=sprintf('H, Frequency band %s Hz, psilocin vs. saline, baseline.',num2str(frequencyBands(1,NOF)));
    title(str)
    
    axis('image'); axis off;
    
    fileSave = strcat(path01,str,'png');
    saveas(NOF,fileSave);
    close(figure(NOF))
    
    % Mapování v èase 20-30 min
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
        if (electrodesSTAT.resultTableAnovaP.time02(NOF,i)==1)
            scatter3(electrodes(i,1),electrodes(i,2),electrodes(i,3),'MarkerEdgeColor','k','MarkerFaceColor',colour_elecs_POS)
        elseif (electrodesSTAT.resultTableAnovaP.time02(NOF,i)==-1)
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
    str=sprintf('H, Frequency band %s Hz,  psilocin vs. saline, 20-30 min.',num2str(frequencyBands(1,NOF)));
    title(str)
    
    axis('image'); axis off;
    
    fileSave = strcat(path02,str,'png');
    saveas(NOF,fileSave);
    close(figure(NOF))
    
    % Mapování v èase 50-60 min
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
        if (electrodesSTAT.resultTableAnovaP.time03(NOF,i)==1)
            scatter3(electrodes(i,1),electrodes(i,2),electrodes(i,3),'MarkerEdgeColor','k','MarkerFaceColor',colour_elecs_POS)
        elseif (electrodesSTAT.resultTableAnovaP.time03(NOF,i)==-1)
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
    str=sprintf('H, Frequency band %s Hz,  psilocin vs. saline, 50-60 min.',num2str(frequencyBands(1,NOF)));
    title(str)
    
    axis('image'); axis off;
    
    fileSave = strcat(path03,str,'png');
    saveas(NOF,fileSave);
    close(figure(NOF))
    
    % Mapování v èase 80-90 min
    color04= zeros(numOfPoints,3);
    ind = mapa04(NOF,:) == 0;
    color04(ind,1) = colour_standard(1,1);
    color04(ind,2) = colour_standard(1,2);
    color04(ind,3) = colour_standard(1,3);
    
    ind = mapa04(NOF,:) == 1;
    color04(ind,1) = colour_peach(1,1);
    color04(ind,2) = colour_peach(1,2);
    color04(ind,3) = colour_peach(1,3);
    
    ind = mapa04(NOF,:) == -1;
    color04(ind,1) = colour_lightblue(1,1);
    color04(ind,2) = colour_lightblue(1,2);
    color04(ind,3) = colour_lightblue(1,3);
    
    figure('Color','white','Name','H: significant maps')
    patch('vertices', POS1, 'faces', TRI1, 'FaceVertexCData', color04, 'FaceColor','interp', 'EdgeColor', 'none')
    camlight('headlight');
    material('dull');
    hold on;
    
    for i = 1 : 1 : 12
        if (electrodesSTAT.resultTableAnovaP.time04(NOF,i)==1)
            scatter3(electrodes(i,1),electrodes(i,2),electrodes(i,3),'MarkerEdgeColor','k','MarkerFaceColor',colour_elecs_POS)
        elseif (electrodesSTAT.resultTableAnovaP.time04(NOF,i)==-1)
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
    str=sprintf('H, Frequency band %s Hz,  psilocin vs. saline, 80-90 min.',num2str(frequencyBands(1,NOF)));
    title(str)
    
    axis('image'); axis off;
    
    fileSave = strcat(path04,str,'png');
    saveas(NOF,fileSave);
end

close all;

%% Inicializace 
% % POROVNÁNÍ PSILOCIN VS. SALINE
% clc; clear all; close all;
% 
% load('RC03statisticsMapsTreatPSISAL.mat');                                 % statistika map: tableAnova, tableAnovaDirr, tableAnovaF, tableAnovaP
% electrodesSTAT = load('RC01ElectrodeStatisticPSISAL.mat');     % statistika elektrod: tableAnovaP
% 
% 
% % Naètení modelu
% [v, f, n, c, stltitle] = stlread('Isocortex/Isocortex_LOWres.stl');
% brain.POS1 = v;
% brain.TRI1 = f;
% 
% POS1 = v;
% TRI1 = f;
% 
% numOfPoints = size(POS1,1);
% % Naètení elektrod
% load('RATModel_12electrodes.mat')   % electrodes (variable)
% 
% electrodeNames = {'F4';'F3';'C4';'C3';'T4';'T3';'P4';'P3';'P6';'P5';'T6';'T5'};
% frequencyBands = 1 : 1 : 50;
% 
% 
% path01 = 'D:/users/sedlmajerova/Documents/MATLAB/BRAINBOX_SPMFilip/MAPS/PSISAL/baseline/';
% path02 = 'D:/users/sedlmajerova/Documents/MATLAB/BRAINBOX_SPMFilip/MAPS/PSISAL/2030minutes/';
% path03 = 'D:/users/sedlmajerova/Documents/MATLAB/BRAINBOX_SPMFilip/MAPS/PSISAL/5060minutes/';
% path04 = 'D:/users/sedlmajerova/Documents/MATLAB/BRAINBOX_SPMFilip/MAPS/PSISAL/8090minutes/';
% 
% % Barvy - definice
% % Zvýšení
% colour_peach = [251 111 66] ./ 255;
% colour_red = [1 0 0];
% colour_darkred = [0.8078 0.0627 0.0627];
% colour_elecs_POS = [255, 192, 0] ./ 255;
% 
% % Snížení
% colour_lightblue = [8 180 238] ./ 255;
% colour_teal = [18 150 155] ./ 255;
% colour_darkblue = [1 17 181] ./ 255;
% colour_elecs_NEG = [0, 176, 240] ./ 255;
% % Standard
% colour_standard = [0.5 0.5 0.5];
% 
% numOfFreq= size(frequencyBands,2);
% 
% mapa01 = resultTableAnovaP.time01<0.05 .* dirre.time01;
% mapa02 = resultTableAnovaP.time02<0.05 .* dirre.time02;
% mapa03 = resultTableAnovaP.time03<0.05 .* dirre.time03;
% mapa04 = resultTableAnovaP.time04<0.05 .* dirre.time04;
% 
% for NOF = 1 : 1 : numOfFreq
%     
%     % Mapování v èase baseline
%     color01= zeros(numOfPoints,3);
%     ind = mapa01(NOF,:) == 0;
%     color01(ind,1) = colour_standard(1,1);
%     color01(ind,2) = colour_standard(1,2);
%     color01(ind,3) = colour_standard(1,3);
%     
%     ind = mapa01(NOF,:) == 1;
%     color01(ind,1) = colour_peach(1,1);
%     color01(ind,2) = colour_peach(1,2);
%     color01(ind,3) = colour_peach(1,3);
%     
%     ind = mapa01(NOF,:) == -1;
%     color01(ind,1) = colour_lightblue(1,1);
%     color01(ind,2) = colour_lightblue(1,2);
%     color01(ind,3) = colour_lightblue(1,3);
%     
%     figure('Color','white','Name','H: significant maps')
%     patch('vertices', POS1, 'faces', TRI1, 'FaceVertexCData', color01, 'FaceColor','interp', 'EdgeColor', 'none')
%     camlight('headlight');
%     material('dull');
%     hold on;
%     
%     
%     for i = 1 : 1 : 12
%         if (electrodesSTAT.resultTableAnovaP.time01(NOF,i)==1)
%             scatter3(electrodes(i,1),electrodes(i,2),electrodes(i,3),'MarkerEdgeColor','k','MarkerFaceColor',colour_elecs_POS)
%         elseif (electrodesSTAT.resultTableAnovaP.time01(NOF,i)==-1)
%             scatter3(electrodes(i,1),electrodes(i,2),electrodes(i,3),'MarkerEdgeColor','k','MarkerFaceColor',colour_elecs_NEG)
%         else
%             scatter3(electrodes(i,1),electrodes(i,2),electrodes(i,3),'MarkerEdgeColor','k','MarkerFaceColor',[0 0 0])
%         end
%     end
%     hold on;
%     for i=1:1:12
%         text(electrodes(i,1),(electrodes(i,2)+0.5),(electrodes(i,3)+0.5),electrodeNames{i},'FontSize',12,'FontWeight','bold')
%         hold on;
%     end
%     str=sprintf('H, Frequency band %s Hz,  psilocin vs. saline, baseline.',num2str(frequencyBands(1,NOF)));
%     title(str)
%     
%     axis('image'); axis off;
%     
%     fileSave = strcat(path01,str,'png');
%     saveas(NOF,fileSave);
%     close(figure(NOF))
%     
%     % Mapování v èase 20-30 min
%     color02= zeros(numOfPoints,3);
%     ind = mapa02(NOF,:) == 0;
%     color02(ind,1) = colour_standard(1,1);
%     color02(ind,2) = colour_standard(1,2);
%     color02(ind,3) = colour_standard(1,3);
%     
%     ind = mapa02(NOF,:) == 1;
%     color02(ind,1) = colour_peach(1,1);
%     color02(ind,2) = colour_peach(1,2);
%     color02(ind,3) = colour_peach(1,3);
%     
%     ind = mapa02(NOF,:) == -1;
%     color02(ind,1) = colour_lightblue(1,1);
%     color02(ind,2) = colour_lightblue(1,2);
%     color02(ind,3) = colour_lightblue(1,3);
%     
%     figure('Color','white','Name','H: significant maps')
%     patch('vertices', POS1, 'faces', TRI1, 'FaceVertexCData', color02, 'FaceColor','interp', 'EdgeColor', 'none')
%     camlight('headlight');
%     material('dull');
%     hold on;
%     
%     for i = 1 : 1 : 12
%         if (electrodesSTAT.resultTableAnovaP.time02(NOF,i)==1)
%             scatter3(electrodes(i,1),electrodes(i,2),electrodes(i,3),'MarkerEdgeColor','k','MarkerFaceColor',colour_elecs_POS)
%         elseif (electrodesSTAT.resultTableAnovaP.time02(NOF,i)==-1)
%             scatter3(electrodes(i,1),electrodes(i,2),electrodes(i,3),'MarkerEdgeColor','k','MarkerFaceColor',colour_elecs_NEG)
%         else
%             scatter3(electrodes(i,1),electrodes(i,2),electrodes(i,3),'MarkerEdgeColor','k','MarkerFaceColor',[0 0 0])
%         end
%     end
%     hold on;
%     for i=1:1:12
%         text(electrodes(i,1),(electrodes(i,2)+0.5),(electrodes(i,3)+0.5),electrodeNames{i},'FontSize',12,'FontWeight','bold')
%         hold on;
%     end
%     str=sprintf('H, Frequency band %s Hz,  psilocin vs. saline, 20-30 min.',num2str(frequencyBands(1,NOF)));
%     title(str)
%     
%     axis('image'); axis off;
%     
%     fileSave = strcat(path02,str,'png');
%     saveas(NOF,fileSave);
%     close(figure(NOF))
%     
%     % Mapování v èase 50-60 min
%     color03= zeros(numOfPoints,3);
%     ind = mapa03(NOF,:) == 0;
%     color03(ind,1) = colour_standard(1,1);
%     color03(ind,2) = colour_standard(1,2);
%     color03(ind,3) = colour_standard(1,3);
%     
%     ind = mapa03(NOF,:) == 1;
%     color03(ind,1) = colour_peach(1,1);
%     color03(ind,2) = colour_peach(1,2);
%     color03(ind,3) = colour_peach(1,3);
%     
%     ind = mapa03(NOF,:) == -1;
%     color03(ind,1) = colour_lightblue(1,1);
%     color03(ind,2) = colour_lightblue(1,2);
%     color03(ind,3) = colour_lightblue(1,3);
%     
%     figure('Color','white','Name','H: significant maps')
%     patch('vertices', POS1, 'faces', TRI1, 'FaceVertexCData', color03, 'FaceColor','interp', 'EdgeColor', 'none')
%     camlight('headlight');
%     material('dull');
%     hold on;
%     
%     for i = 1 : 1 : 12
%         if (electrodesSTAT.resultTableAnovaP.time03(NOF,i)==1)
%             scatter3(electrodes(i,1),electrodes(i,2),electrodes(i,3),'MarkerEdgeColor','k','MarkerFaceColor',colour_elecs_POS)
%         elseif (electrodesSTAT.resultTableAnovaP.time03(NOF,i)==-1)
%             scatter3(electrodes(i,1),electrodes(i,2),electrodes(i,3),'MarkerEdgeColor','k','MarkerFaceColor',colour_elecs_NEG)
%         else
%             scatter3(electrodes(i,1),electrodes(i,2),electrodes(i,3),'MarkerEdgeColor','k','MarkerFaceColor',[0 0 0])
%         end
%     end
%     hold on;
%     for i=1:1:12
%         text(electrodes(i,1),(electrodes(i,2)+0.5),(electrodes(i,3)+0.5),electrodeNames{i},'FontSize',12,'FontWeight','bold')
%         hold on;
%     end
%     str=sprintf('H, Frequency band %s Hz,  psilocin vs. saline, 50-60 min.',num2str(frequencyBands(1,NOF)));
%     title(str)
%     
%     axis('image'); axis off;
%     
%     fileSave = strcat(path03,str,'png');
%     saveas(NOF,fileSave);
%     close(figure(NOF))
%     
%     % Mapování v èase 80-90 min
%     color04= zeros(numOfPoints,3);
%     ind = mapa04(NOF,:) == 0;
%     color04(ind,1) = colour_standard(1,1);
%     color04(ind,2) = colour_standard(1,2);
%     color04(ind,3) = colour_standard(1,3);
%     
%     ind = mapa04(NOF,:) == 1;
%     color04(ind,1) = colour_peach(1,1);
%     color04(ind,2) = colour_peach(1,2);
%     color04(ind,3) = colour_peach(1,3);
%     
%     ind = mapa04(NOF,:) == -1;
%     color04(ind,1) = colour_lightblue(1,1);
%     color04(ind,2) = colour_lightblue(1,2);
%     color04(ind,3) = colour_lightblue(1,3);
%     
%     figure('Color','white','Name','H: significant maps')
%     patch('vertices', POS1, 'faces', TRI1, 'FaceVertexCData', color04, 'FaceColor','interp', 'EdgeColor', 'none')
%     camlight('headlight');
%     material('dull');
%     hold on;
%     
%     for i = 1 : 1 : 12
%         if (electrodesSTAT.resultTableAnovaP.time04(NOF,i)==1)
%             scatter3(electrodes(i,1),electrodes(i,2),electrodes(i,3),'MarkerEdgeColor','k','MarkerFaceColor',colour_elecs_POS)
%         elseif (electrodesSTAT.resultTableAnovaP.time04(NOF,i)==-1)
%             scatter3(electrodes(i,1),electrodes(i,2),electrodes(i,3),'MarkerEdgeColor','k','MarkerFaceColor',colour_elecs_NEG)
%         else
%             scatter3(electrodes(i,1),electrodes(i,2),electrodes(i,3),'MarkerEdgeColor','k','MarkerFaceColor',[0 0 0])
%         end
%     end
%     hold on;
%     for i=1:1:12
%         text(electrodes(i,1),(electrodes(i,2)+0.5),(electrodes(i,3)+0.5),electrodeNames{i},'FontSize',12,'FontWeight','bold')
%         hold on;
%     end
%     str=sprintf('H, Frequency band %s Hz,  psilocin vs. saline, 80-90 min.',num2str(frequencyBands(1,NOF)));
%     title(str)
%     
%     axis('image'); axis off;
%     
%     fileSave = strcat(path04,str,'png');
%     saveas(NOF,fileSave);
% end
% 
% close all;