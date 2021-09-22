clear all
close all
tomoplan = tomo_read_RTplan('RP_P03_RS_1_Meso.dcm');

LPS = sum(tomoplan.sinogram,1)/tomoplan.TreatmentTime*tomoplan.ProjectionTime;
leafpos = [-32:-1 1:32];
ticks = -32:31;
toget = [1:4:64];
    
mAS = ticks*LPS'/sum(LPS);

close all
f = figure('Units', 'normalized', 'Position', [0.25, 0.1, 0.25, 0.8]);

ax1 = subplot(2,1,1);
imagesc(tomoplan.sinogram);
colormap(gray);
xticks([]);

subplot(2,1,2);
bar(ticks, LPS, 1);
xticks(ticks(toget));
% xticklabels(string(leafpos(toget)));
xticklabels([]);

pos = get(gca, 'Position');
new_pos = pos - [0 0.05 0 0.18];
set(gca, 'Position', new_pos);

hold on

plot([mAS mAS], [0 max(LPS(:))], 'Color', 1/255*[0 200 0], 'LineWidth', 2.0);
plot([-0.5 -0.5], [0 max(LPS(:))], 'Color', 1/255*[200 0 0], 'LineWidth', 2.0);

pos = get(ax1, 'Position');
new_pos = pos - [0 0.35 0 -0.4];
set(ax1, 'Position', new_pos);
set(ax1, 'YDir', 'normal');

% ylim(0, max(LPS(:)));



