clear
close all
clc

stimThreshold = 0.2;

gridLocation = 0.205
%fileWildCard = 'gentleConverging_v1_track_18Lps'; name = 'Converging 1.0D 18Lps'
%fileWildCard = 'gentleConverging_0.5D_track_18Lps'; name = 'Converging 0.5D 18Lps'
fileWildCard = 'converging_0.5DequalAngle_RevF_track_18Lps'; name = 'Converging 0.5D EqualAngle 18Lps'
%fileWildCard = 'staggered_track_18Lps'; name = 'Staggered 18Lps'
%fileWildCard = 'track_18Lps'; name = 'Hidex3 18Lps'

[fileNames, timeSeries] = processCSV(fileWildCard,gridLocation);

nParticles = size(timeSeries,1)
nTimeSteps = size(timeSeries,2);

%% Plot trajectories
figure; hold on; axis equal; xlabel('x'); ylabel('y'); zlabel('z'); grid on; view(3)
for ind = 1:size(timeSeries,1)
    plot3(timeSeries(ind,:,1),timeSeries(ind,:,2),timeSeries(ind,:,3))
end
title('Particle trajectories')

%%
tractionMatrix = timeSeries(:,:,5);

maxTractionPerParticle = max(tractionMatrix,[],2);
tractionBins = 0:0.25:4;
%tractionBins = 0:0.1:1;
% figure
% histogram(maxTractionPerParticle, tractionBins,'Normalization','cdf')
% xlabel('Max traction experienced by particle [Pa]')
% ylabel('CDF - Cumulative Distribution Function')
% title(name)
% ylim([0,1])
% grid on
% print(gcf, [fileWildCard,'_cdf.png'],'-dpng', '-r600')

figure
histogram(maxTractionPerParticle, tractionBins,'Normalization','probability')
xlabel('Max traction experienced by particle [Pa]')
ylabel('Probability')
ylim([0,0.6])
title(name)
grid on
print(gcf, [fileWildCard,'_prob.png'],'-dpng', '-r600')

figure
tractionBins = 0:0.1:1;
histogram(maxTractionPerParticle, tractionBins,'Normalization','probability')
xlabel('Max traction experienced by particle [Pa]')
ylabel('Probability')
ylim([0,0.3])
title(name)
grid on
print(gcf, [fileWildCard,'_prob_zoom.png'],'-dpng', '-r600')

%% Location of First Flash
xMatrix = timeSeries(:,:,1);
yMatrix = timeSeries(:,:,2);
zMatrix = timeSeries(:,:,3);

zStim = nan(1,nParticles);
xStim = zStim;
yStim = zStim;
stimID = 1:nParticles;

% Loop through particles one by one
for ind = 1:nParticles
    xParticle = xMatrix(ind,:);
    yParticle = yMatrix(ind,:);
    zParticle = zMatrix(ind,:);
    tractionParticle = tractionMatrix(ind,:);
    temp = find(tractionParticle>=stimThreshold);
    if(~isempty(temp))
        xStim(ind) = xParticle(temp(1));
        yStim(ind) = yParticle(temp(1));
        zStim(ind) = zParticle(temp(1));
    end
end

%%
M = 15.5/1e3 %15.5mm
figure;
plot(zStim/M, stimID,'ro')
hold on
plot(0*stimID, stimID,'kx')
xlim([-1,2])
title([num2str(100*round(sum(~isnan(zStim))/length(zStim),2)),'% of particles exceed threshold ',num2str(stimThreshold),' Pa eventually'])
xlabel(['Streamwise distance from stimulation grid for first flash (x/M, M=',num2str(M*1e3),'mm)'])
ylabel('Particle number')
ylim([0,nParticles])
print(gcf, ['firstFlash_',num2str(stimThreshold),'Pa_',fileWildCard,'.png'],'-dpng', '-r600')

%%

sizes = (zStim/M + 2)*30

figure;
scatter(xStim,yStim,sizes,'filled')
xlabel('x')
ylabel('y')
title(['Axial view of first Flash, ',fileWildCard(end-4:end),', ', num2str(stimThreshold),'Pa'])
axis equal
xlim([-0.06, 0.06])
ylim([-0.06, 0.06])
grid on
print(gcf, ['axialView_firstFlash_',num2str(stimThreshold),'Pa_',fileWildCard,'.png'],'-dpng', '-r600')

% xlabel('Time')
% ylabel('Percentage particles exceeded (%)')
% legend('0.1 Pa','0.2 Pa','0.5 Pa','location','northwest')
% grid on
% print(gcf, 'barGraphs.eps','-depsc')