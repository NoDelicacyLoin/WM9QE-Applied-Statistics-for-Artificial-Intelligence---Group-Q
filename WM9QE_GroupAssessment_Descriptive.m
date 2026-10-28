% This script calculates descriptive statistics, flags potential outliers, and plots the data.

% Source 1: WM9QE_Week1_Descriptive_Statistics_New.mlx
% Source 2: WM9QE_Week1_Session1_Independent_Learning_Solution.mlx

%% Input: matched observations
clear; clc; close all;
Old = [11 15 19 22 24 27 28 30 31 33 35 36 37 38 39 42 43 46 49 64];
New = [16 21 25 27 32 34 35 36 40 41 43 44 47 48 49 50 52 54 55 61];
D = New - Old;

%% Section 1: Central Tendency Measures

%% The Mean
x=Old; %Array for testing purposes
fprintf('Old: mean = %.2f\n', mean(x)); %Display the mean() of array x.

x=New; %Array for testing purposes
fprintf('New: mean = %.2f\n', mean(x)); %Display the mean() of array x.

x=D; %Array for testing purposes
fprintf('D: mean = %.2f\n', mean(x)); %Display the mean() of array x.

%% The Median
% %odd number:
%event number:
n_even=Old; %Array for testing purposes
fprintf('Old: median = %.2f\n', median(n_even)); %Display the median() of array n.

% %odd number:
%event number:
n_even=New; %Array for testing purposes
fprintf('New: median = %.2f\n', median(n_even)); %Display the median() of array n.

% %odd number:
%event number:
n_even=D; %Array for testing purposes
fprintf('D: median = %.2f\n', median(n_even)); %Display the median() of array n.

%% Section 1 -> The Mode -> Example 1: Simple vector; Example 2: Matrix
% Example 1: Simple vector
x=D; %Array for testing purposes
fprintf('D: mode = %d\n', mode(x)); %Display the mode() of array n.

% Example 2: Matrix (Mode of each column)
data_matrix = [Old', New', D'];
fprintf('Modes of columns Old / New / D:\n');
M = mode(data_matrix);
disp(M);
% MATLAB calculates the mode for each column by default.

%% Section 2: Estimates of Variability

%% Variance
fprintf('\n--- Old: Variance ---\n');
x=Old;
fprintf('Variance of x: %.2f\n', var(x));

fprintf('\n--- New: Variance ---\n');
x=New;
fprintf('Variance of x: %.2f\n', var(x));

fprintf('\n--- D: Variance ---\n');
x=D;
fprintf('Variance of x: %.2f\n', var(x));

%% Standard deviation
fprintf('\n--- Old: Standard deviation ---\n');
x=Old;
fprintf('Standard Deviation of x: %.2f\n', std(x));

fprintf('\n--- New: Standard deviation ---\n');
x=New;
fprintf('Standard Deviation of x: %.2f\n', std(x));

fprintf('\n--- D: Standard deviation ---\n');
x=D;
fprintf('Standard Deviation of x: %.2f\n', std(x));

%% Range
fprintf('\n--- Old: Range ---\n');
x=Old;
fprintf('Range of x: %.2f\n', range(x));

fprintf('\n--- New: Range ---\n');
x=New;
fprintf('Range of x: %.2f\n', range(x));

fprintf('\n--- D: Range ---\n');
x=D;
fprintf('Range of x: %.2f\n', range(x));

%% Interquartile Range (IQR)
fprintf('\n--- Old: Interquartile Range (IQR) ---\n');
x=Old;
fprintf('Q1 of x: %.2f\n', quantile(x, 0.25));
fprintf('Q2 of x: %.2f\n', median(x));
fprintf('Q3 of x: %.2f\n', quantile(x, 0.75));
fprintf('IQR of x: %.2f\n', iqr(x)); %Q3-Q1

fprintf('\n--- New: Interquartile Range (IQR) ---\n');
x=New;
fprintf('Q1 of x: %.2f\n', quantile(x, 0.25));
fprintf('Q2 of x: %.2f\n', median(x));
fprintf('Q3 of x: %.2f\n', quantile(x, 0.75));
fprintf('IQR of x: %.2f\n', iqr(x)); %Q3-Q1

fprintf('\n--- D: Interquartile Range (IQR) ---\n');
x=D;
fprintf('Q1 of x: %.2f\n', quantile(x, 0.25));
fprintf('Q2 of x: %.2f\n', median(x));
fprintf('Q3 of x: %.2f\n', quantile(x, 0.75));
fprintf('IQR of x: %.2f\n', iqr(x)); %Q3-Q1

%% Interquartile Range — IQR outlier screening
fprintf('\n--- Old: IQR screening, all 20 retained ---\n');
% IQR-Based Outlier Detection
sample_h = Old;

Q1 = quantile(sample_h, 0.25);
Q3 = quantile(sample_h, 0.75);
IQR_val = Q3 - Q1;

lower_bound = Q1 - 1.5 * IQR_val;
upper_bound = Q3 + 1.5 * IQR_val;

outlier_mask = (sample_h < lower_bound) | (sample_h > upper_bound);
outliers = sample_h(outlier_mask);
pair_number = 1:numel(sample_h);
disp('Flagged matched pair numbers:'); disp(pair_number(outlier_mask));

fprintf('Outliers: [%s]\n', num2str(outliers));
fprintf('Bounds: [%.1f, %.1f]\n', lower_bound, upper_bound);

figure('Name','Box Plot Outliers','Position',[100 100 700 300],'WindowStyle','docked');
boxplot(sample_h, 'Orientation','horizontal'); hold on
xline(lower_bound, 'g--', sprintf('Q1-1.5*IQR\n%.2f', lower_bound));
xline(upper_bound, 'g--', sprintf('Q3+1.5*IQR\n%.2f', upper_bound));
xlabel('Old (hours)');
title('Old: Box Plot with Outlier Bounds');
xlim([min([sample_h lower_bound])-1, max([sample_h upper_bound])+1]);
 grid on
drawnow

fprintf('\n--- New: IQR screening, all 20 retained ---\n');
% IQR-Based Outlier Detection
sample_h = New;

Q1 = quantile(sample_h, 0.25);
Q3 = quantile(sample_h, 0.75);
IQR_val = Q3 - Q1;

lower_bound = Q1 - 1.5 * IQR_val;
upper_bound = Q3 + 1.5 * IQR_val;

outlier_mask = (sample_h < lower_bound) | (sample_h > upper_bound);
outliers = sample_h(outlier_mask);
pair_number = 1:numel(sample_h);
disp('Flagged matched pair numbers:'); disp(pair_number(outlier_mask));

fprintf('Outliers: [%s]\n', num2str(outliers));
fprintf('Bounds: [%.1f, %.1f]\n', lower_bound, upper_bound);

figure('Name','Box Plot Outliers','Position',[100 100 700 300],'WindowStyle','docked');
boxplot(sample_h, 'Orientation','horizontal'); hold on
xline(lower_bound, 'g--', sprintf('Q1-1.5*IQR\n%.2f', lower_bound));
xline(upper_bound, 'g--', sprintf('Q3+1.5*IQR\n%.2f', upper_bound));
xlabel('New (hours)');
title('New: Box Plot with Outlier Bounds');
xlim([min([sample_h lower_bound])-1, max([sample_h upper_bound])+1]);
 grid on
drawnow

fprintf('\n--- D: IQR screening, all 20 retained ---\n');
% IQR-Based Outlier Detection
sample_h = D;

Q1 = quantile(sample_h, 0.25);
Q3 = quantile(sample_h, 0.75);
IQR_val = Q3 - Q1;

lower_bound = Q1 - 1.5 * IQR_val;
upper_bound = Q3 + 1.5 * IQR_val;

outlier_mask = (sample_h < lower_bound) | (sample_h > upper_bound);
outliers = sample_h(outlier_mask);
pair_number = 1:numel(sample_h);
disp('Flagged matched pair numbers:'); disp(pair_number(outlier_mask));

fprintf('Outliers: [%s]\n', num2str(outliers));
fprintf('Bounds: [%.1f, %.1f]\n', lower_bound, upper_bound);

figure('Name','Box Plot Outliers','Position',[100 100 700 300],'WindowStyle','docked');
boxplot(sample_h, 'Orientation','horizontal'); hold on
xline(lower_bound, 'g--', sprintf('Q1-1.5*IQR\n%.2f', lower_bound));
xline(upper_bound, 'g--', sprintf('Q3+1.5*IQR\n%.2f', upper_bound));
xlabel('D (hours)');
title('D: Box Plot with Outlier Bounds');
xlim([min([sample_h lower_bound])-1, max([sample_h upper_bound])+1]);
 grid on
drawnow

%% Coefficient of Variance (CV)
fprintf('\n--- Old: CV ---\n');
x = Old;

% 1. Calculate the Mean (Average)
mu = mean(x);

% 2. Calculate the Standard Deviation (using the sample standard deviation, the default for std())
sigma = std(x);

% 3. Calculate the Coefficient of Variation (CV)
% Formula: CV = (Standard Deviation / Mean) * 100
CV_percentage = (sigma / mu) * 100;

% Display the results
fprintf('--- Statistical Metrics ---\n');
fprintf('Data Mean (mu):              %.2f\n', mu);
fprintf('Standard Deviation (sigma):  %.2f\n', sigma);
fprintf('---------------------------\n');
fprintf('Coefficient of Variation (CV): %.2f%%\n', CV_percentage);

% Display a final interpretation
fprintf('\nInterpretation:\n');
fprintf('The CV is %.2f%%. This means the standard deviation (spread) is %.2f%% of the mean value.\n', CV_percentage, CV_percentage);

fprintf('\n--- New: CV ---\n');
x = New;

% 1. Calculate the Mean (Average)
mu = mean(x);

% 2. Calculate the Standard Deviation (using the sample standard deviation, the default for std())
sigma = std(x);

% 3. Calculate the Coefficient of Variation (CV)
% Formula: CV = (Standard Deviation / Mean) * 100
CV_percentage = (sigma / mu) * 100;

% Display the results
fprintf('--- Statistical Metrics ---\n');
fprintf('Data Mean (mu):              %.2f\n', mu);
fprintf('Standard Deviation (sigma):  %.2f\n', sigma);
fprintf('---------------------------\n');
fprintf('Coefficient of Variation (CV): %.2f%%\n', CV_percentage);

% Display a final interpretation
fprintf('\nInterpretation:\n');
fprintf('The CV is %.2f%%. This means the standard deviation (spread) is %.2f%% of the mean value.\n', CV_percentage, CV_percentage);

%% Section 4: Applying Descriptive Statistics to MATLAB Datasets -> IRIS summary

disp('===== Old / New / D SUMMARY =====')
meas = [Old', New', D'];
assessmentTbl = array2table(meas, ...
    'VariableNames', {'Old','New','D'});

% Descriptive Statistics
assessmentDesc = describeTable(assessmentTbl);
disp(assessmentDesc)

% % Correlation (pairwise to be safe with NaNs; Iris has none)
% %% ---------- PLOTS ----------
% %% ---------- PLOTS ----------

%% Counts and Proportions
%% Exercise 16: Healthcare - Patient Vital Signs
% >>> Write your code here <<<

differences_h = D';

figure('WindowStyle','docked'); histogram(differences_h,15);
xlabel('Difference New - Old (hours)'); ylabel('Count');
title('All 20 paired differences');

pct_positive = mean(differences_h > 0)*100;

% Summary table
difference_summary = table(mean(differences_h), min(differences_h), max(differences_h), ...
    'VariableNames', {'MeanDifference_h','MinDifference_h','MaxDifference_h'});

% --- Solution interpretation:
disp(difference_summary)
fprintf('Percentage of pairs with D > 0: %.1f%%\n\n', pct_positive);
%% Extra Examples percentage expression repeated for zero and negative differences
pct_zero = mean(differences_h == 0)*100;
pct_negative = mean(differences_h < 0)*100;
fprintf('D = 0: %.1f%%; D < 0: %.1f%%\n', pct_zero, pct_negative);

%% Section 1 -> The Mode -> New: Mode for Class Imbalance Analysis
positive_count = sum(D > 0);
zero_count = sum(D == 0);
negative_count = sum(D < 0);
fprintf('Positive: %d; Zero: %d; Negative: %d\n', ...
    positive_count, zero_count, negative_count);
fprintf('Positive: %.1f%%; Zero: %.1f%%; Negative: %.1f%%\n', ...
    positive_count/length(D)*100, zero_count/length(D)*100, ...
    negative_count/length(D)*100);

%% Example A — Descriptive Statistics The Mean / IoT Temperature Sensor Data

% IoT Temperature Sensor Data - Anomaly Detection
sensor_temps = D;
% Calculate mean - affected by outlier!
mean_temp = mean(sensor_temps);
% Visualise the problem
figure('WindowStyle','docked');
plot(sensor_temps, 'bo-', 'LineWidth', 2, 'MarkerSize', 8);
hold on;
yline(mean_temp, 'r--', 'LineWidth', 2, ...
    'Label', sprintf('Mean = %.2f h', mean_temp));
xlabel('Pair ID (not stress intensity)');
ylabel('D = New - Old (hours)');
title('Paired differences with mean reference');
grid on;
% Display results
fprintf('Mean paired difference: %.2f h\n', mean_temp);

%% Example B — Descriptive Statistics AI Application Example / Step 4
accuracies = D(:);
% Calculate central tendency measures for accuracies
meanAccuracy = mean(accuracies);
medianAccuracy = median(accuracies);

% For mode analysis: bin accuracies into ranges
accuracyBins = min(accuracies):1:(max(accuracies)+1);
[counts, edges] = histcounts(accuracies, accuracyBins);
[maxCount, modeIdx] = max(counts);
modeAccuracyRange = [edges(modeIdx), edges(modeIdx+1)];

% Display results
fprintf('\n=== PAIRED DIFFERENCE STATISTICS ===\n');
fprintf('Mean difference: %.4f h\n', meanAccuracy);
fprintf('Median difference: %.4f h\n', medianAccuracy);
fprintf('Modal histogram bin (hours): [%.4f, %.4f)\n', ...
    modeAccuracyRange(1), modeAccuracyRange(2));
fprintf('Min difference: %.4f h\n', min(accuracies));
fprintf('Max difference: %.4f h\n', max(accuracies));

% % Analyze most common predictions for mode

%% Example B — Descriptive Statistics AI Application Example / Step 5 (all four panels)
% Fast Visualization (MATLAB Online–friendly)

% ---- precompute once ----
nBins = 15;
[binCounts, binEdges] = histcounts(accuracies, nBins);
binCenters = (binEdges(1:end-1) + binEdges(2:end)) / 2;

cBlue   = [0.2, 0.4, 0.8];
cMean   = [0.85, 0.33, 0.10]; % reddish
cMedian = [0.10, 0.60, 0.10]; % greenish

% If runs are massive, thin plotted markers for speed (keeps lines full res)
runsFull = 1:numel(accuracies);
accFull  = accuracies(:).';
runsPlot = runsFull;
accPlot  = accFull;
maxMarkers = 1e4; % adjust if needed
if numel(runsFull) > maxMarkers
    ix = round(linspace(1, numel(runsFull), maxMarkers));
    runsPlot = runsFull(ix);
    accPlot  = accFull(ix);
end

% ---- layout ----
fig = figure('Position',[100,100,1100,750],'Color','w','WindowStyle','docked');
t = tiledlayout(fig,2,2,'TileSpacing','compact','Padding','compact');

% ---- Subplot 1: Accuracy distribution (bar from histcounts) ----
ax1 = nexttile(t,1);
b = bar(ax1, binCenters, binCounts, 'BarWidth', 1.0, ...
    'FaceColor', cBlue, 'EdgeColor', 'k');
hold(ax1,'on');
yl1 = ylim(ax1);

% mean/median lines (use low-level 'line' for speed)
hMean1   = line(ax1, [meanAccuracy meanAccuracy], yl1, ...
    'LineStyle','--','Color',cMean,'LineWidth',1.5,'HitTest','off');
hMedian1 = line(ax1, [medianAccuracy medianAccuracy], yl1, ...
    'LineStyle','--','Color',cMedian,'LineWidth',1.5,'HitTest','off');

% lightweight text labels (avoid xline/yline 'Label' overhead)
text(meanAccuracy, yl1(2), sprintf('  Mean = %.4f', meanAccuracy), ...
    'Parent',ax1,'VerticalAlignment','bottom','HorizontalAlignment','left', ...
    'Color',cMean,'FontSize',10,'Clipping','on');
text(medianAccuracy, yl1(2)-(yl1(2)-yl1(1))*0.06, sprintf('  Median = %.4f', medianAccuracy), ...
    'Parent',ax1,'VerticalAlignment','bottom','HorizontalAlignment','left', ...
    'Color',cMedian,'FontSize',10,'Clipping','on');

xlabel(ax1,'D = New - Old (hours)'); ylabel(ax1,'Frequency');
title(ax1,'Distribution of paired differences');
grid(ax1,'on');

% Legend with explicit handles; disable auto-update for speed
lg1 = legend(ax1,[b hMean1 hMedian1], {'Counts','Mean','Median'}, 'Location','northwest');
set(lg1,'AutoUpdate','off');

% ---- Subplot 2: Accuracy across runs ----
ax2 = nexttile(t,2);
hData = plot(ax2, runsFull, accFull, '-', 'LineWidth', 1.25); % line only (fast)
hold(ax2,'on');
% draw sparse markers (fast) on thinned subset
plot(ax2, runsPlot, accPlot, 'o', 'LineWidth', 1.0, 'MarkerSize', 5);

xl2 = xlim(ax2);
hMean2   = line(ax2, xl2, [meanAccuracy meanAccuracy], 'LineStyle','--', ...
    'Color',cMean,'LineWidth',1.5,'HitTest','off');
hMedian2 = line(ax2, xl2, [medianAccuracy medianAccuracy], 'LineStyle','--', ...
    'Color',cMedian,'LineWidth',1.5,'HitTest','off');

xlabel(ax2,'Pair ID (not stress intensity)'); ylabel(ax2,'D (hours)');
title(ax2,'Paired differences by row ID'); grid(ax2,'on');
lg2 = legend(ax2,[hData hMean2 hMedian2], {'D','Mean','Median'}, 'Location','southeast');
set(lg2,'AutoUpdate','off');

% keep horizontal lines spanning full axes when you pan/zoom
addlistener(ax2,'XLim','PostSet',@(src,ev) set([hMean2 hMedian2],{'XData'},{ev.AffectedObject.XLim; ev.AffectedObject.XLim}));

% ---- Subplot 3: Box plot (tiledlayout-safe) ----
ax3 = nexttile(t,3);

boxchart(ax3, accuracies, ...
    'BoxFaceAlpha', 0.7, ...
    'MarkerStyle', 'none');

ylabel(ax3, 'D (hours)');
title(ax3, 'Box Plot of Paired Differences');
grid(ax3, 'on');

% ---- Subplot 4: Summary ----
ax4 = nexttile(t,4);
axis(ax4,'off');

summaryText = {
    '\fontsize{14}\bfSummary Statistics';
    '';
    sprintf('Mean:   %.4f', meanAccuracy);
    sprintf('Median: %.4f', medianAccuracy);
    sprintf('Modal bin (h): [%.4f, %.4f)', modeAccuracyRange(1), modeAccuracyRange(2));
    '';
    sprintf('Min:    %.4f', min(accuracies));
    sprintf('Max:    %.4f', max(accuracies));
    sprintf('Range:  %.4f', range(accuracies));
    '';
};

text(ax4, 0.05, 0.55, summaryText, 'VerticalAlignment','middle', ...
    'FontSize',12, 'Interpreter','tex');

sgtitle(t,'Paired ALT Differences: Central Tendency', ...
    'FontSize',16,'FontWeight','bold');

drawnow;  % a single flush at the very end
%% ================= HELPER FUNCTIONS =================
function statsTable = describeTable(tbl)
% Create a pandas.DataFrame.describe()-style summary for numeric columns
    X = table2array(tbl);
    vn = tbl.Properties.VariableNames;

    count = sum(~isnan(X),1);
    mu    = mean(X, 'omitnan');
    sd    = std(X,  'omitnan');
    mn    = min(X,  [], 'omitnan');
    q25   = quantile(X, 0.25);
    med   = median(X, 'omitnan');
    q75   = quantile(X, 0.75);
    mx    = max(X,  [], 'omitnan');

    statsTable = array2table([count; mu; sd; mn; q25; med; q75; mx], ...
        'RowNames', {'count','mean','std','min','25%','50%','75%','max'}, ...
        'VariableNames', vn);
end
