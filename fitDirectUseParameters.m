function [b,eSig] = fitDirectUseParameters(toReport,figureNumber,toSave)
% fitDirectUseParameters uses fossil fuel production and consumption data
% from 2015 through 2025 to fit a linear model of the year-over-year 
% percent change in domestic fossil fuel direct use vs. the year-over-year
% percent change in fossil fuel production.

arguments (Input)
    toReport % binary indicator of whether to issue text reports
    figureNumber % number of first figure to plot into (0 -> no plots)
    toSave % indicator of whether to save plot
end

arguments (Output)
    b % parameter estimates from least-squares fit
    eSig % standard error from least-squares fit, EJ
end

% production
year = 2015:2025; % years spanned by data
totalProduction = [... 
    70.174 65.460 68.519 75.824 81.449 76.209 78.019 82.296 86.174 86.544 89.732 ...
    ]'*1.055; % total production, EJ, https://www.eia.gov/totalenergy/data/monthly/pdf/sec12_7.pdf

% production report
if toReport
    fprintf('Production increased from %.3g EJ in %i to %.3g EJ in %i (%.3g%%).\n',...
        totalProduction(1),year(1),totalProduction(end),year(end),...
        100*(totalProduction(end)/totalProduction(1) - 1))
end

% overall consumption
coalConsumption = [...
    15.549 14.226 13.837 13.252 11.316 9.181 10.549 9.888 8.171 7.912 8.671 ...
    ]'*1.055; % coal consumption, EJ, https://www.eia.gov/totalenergy/data/monthly/pdf/sec12_8.pdf
gasConsumption = [...
    28.191 28.400 28.049 31.163 32.264 31.669 31.711 33.379 33.676 34.179 34.624 ...
    ]'*1.055; % gas consumption, EJ, https://www.eia.gov/totalenergy/data/monthly/pdf/sec12_8.pdf
oilConsumption = [...
    35.368 35.712 36.043 36.892 36.866 32.331 35.243 35.319 35.448 35.590 36.115 ...
    ]'*1.055; % oil consumption, EJ, https://www.eia.gov/totalenergy/data/monthly/pdf/sec12_8.pdf

% consumption for electricity
electricityCoalHeatContent = [...
    19.15 19.15 18.98 18.92 18.90 18.88 18.94 18.79 18.72 18.79 18.774 ...
    ]'; % heat content of coal consumed for electricity, billion Btu per thousand short tons, https://www.eia.gov/totalenergy/data/monthly/pdf/mer_A_FULL.pdf
electricityCoalConsumption = [...
    738444 678554 664993 637217 538606 435827 501435 472834 387205 373258 416995 ...
    ]'; % electricity coal consumption, thousand short tons, https://www.eia.gov/totalenergy/data/monthly/pdf/sec6_4.pdf
electricityCoalConsumption = electricityCoalConsumption.*electricityCoalHeatContent/947817; % 1 EJ = 947817 billion Btu
electricityOilHeatContent = 5.9; % billion Btu per thousand barrels, https://www.eia.gov/totalenergy/data/monthly/pdf/mer_A_FULL.pdf
electricityOilConsumption = [...
    128 113 101 121 88 86 95 113 81 76 93 ...
    ]'*365; % electricity oil consumption, thousand barrels, https://www.eia.gov/totalenergy/data/monthly/pdf/sec3_23.pdf
electricityOilConsumption = electricityOilConsumption*electricityOilHeatContent/947817; % 1 EJ = 947817 billion Btu
electricityGasHeatContent = 1034; % billion Btu per billion cubic feet, https://www.eia.gov/totalenergy/data/monthly/pdf/mer_A_FULL.pdf
electricityGasConsumption = [...
    9613 9985 9266 10599 11299 11632 11229 12092 12941 13476 13054 ...
    ]'; % electricity gas consumption, billion cubic feet, https://www.eia.gov/totalenergy/data/monthly/pdf/sec4_6.pdf
electricityGasConsumption = electricityGasConsumption*electricityGasHeatContent/947817; % 1 EJ = 947817 billion Btu

% direct consumption
coalDirectConsumption = coalConsumption - electricityCoalConsumption; % direct coal consumption, EJ
oilDirectConsumption = oilConsumption - electricityOilConsumption; % direct oil consumption, EJ
gasDirectConsumption = gasConsumption - electricityGasConsumption; % direct gas consumption, EJ
totalDirectConsumption = coalDirectConsumption + oilDirectConsumption + gasDirectConsumption; % total direct consumption, EJ

% relative changes in direct consumption vs. production
relativeProductionChange = diff(totalProduction)./totalProduction(1:end-1);
relativeDirectConsumptionChange = diff(totalDirectConsumption)./totalDirectConsumption(1:end-1);

% relative change fit
y = relativeDirectConsumptionChange; % target
n = length(y); % number of data points
x = relativeProductionChange; % feature
X = [ones(n,1), x]; % feature matrix
b = X\y; % least-squares parameter estimate
yh = X*b; % prediction
e = yh - y; % error
eSig = sqrt(sum(e.^2)/(n - size(X,2))); % standard error

% report fit statistics
if toReport
    fprintf('Fit RMSE: %.4g. R^2: %.4g.\n',sqrt(mean(e.^2)),1 - var(e)/var(y))
end

% relative change fit plot
if figureNumber > 0
    figure(figureNumber), clf
    xPoly = 100*[sort(x); sort(x,'descend')]; % x polygon
    yPoly = 100*[b(1) + b(2)*sort(x) - 1.96*eSig; b(1) + b(2)*sort(x,'descend') + 1.96*eSig]; % y polygon
    fill(xPoly,yPoly,[0.8500, 0.3250, 0.0980],'FaceAlpha',0.2,'EdgeColor', 'none'), grid on % confidence interval
    hold on, plot(100*x,100*y,'o') % data
    plot(100*sort(x),100*(b(1) + b(2)*sort(x))) % best-fit line
    xlim(100*[min(x), max(x)])
    ylim([-1,1]*ceil(max(abs(100*y))))
    xlabel('Percent change in fossil fuel production')
    ylabel('Percent change in fossil fuel direct use')
    textStr = ['$y = $', sprintf('%.3g',b(2))]; % string for text annotation
    if b(1) > 0
        textStr = [textStr, '$x +$', sprintf('%.3g',100*b(1))];
    else
        textStr = [textStr, '$x -$', sprintf('%.3g',-100*b(1))];
    end
    textStr = [textStr, '$+ e$, $\hat \sigma_e =$', sprintf('%.3g',100*eSig)];
    small = 0.5; % margin for locating text string
    text(min(xlim) + small,max(ylim) - small,textStr,'verticalalignment','top','color',[0.8500, 0.3250, 0.0980])
    if toSave
        exportgraphics(gcf,'fit.png','resolution',600);
    end
end

end