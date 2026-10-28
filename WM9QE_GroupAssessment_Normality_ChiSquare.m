% Get a chi-square test for normality on the paired differences, D = New - Old.

% Source: WM9QE_Week2_Normality_Hypothesis_Parametric_Tests.mlx, Section 3, Example 3.1

%% Step 0. Initialization
clear; clc; close all;

%% Step 1. Input Sample Data
Old = [11 15 19 22 24 27 28 30 31 33 35 36 37 38 39 42 43 46 49 64];
New = [16 21 25 27 32 34 35 36 40 41 43 44 47 48 49 50 52 54 55 61];

D = New - Old;
differences_h = D';

n = numel(differences_h);  % numel() counts total observations
fprintf('Sample size n = %d\n', n);

%% Step 2. Descriptive Statistics
% Compute key descriptive measures to summarize data shape
MeanVal   = mean(differences_h);           % Sample mean
StdVal    = std(differences_h, 0);         % Sample std (n-1 denominator)
MedianVal = median(differences_h);         % Middle value
VarVal    = var(differences_h, 0);         % Sample variance
KurtVal   = kurtosis(differences_h) - 3;   % Excess kurtosis (like Excel)
SkewVal   = skewness(differences_h);       % Measure of asymmetry
MinVal    = min(differences_h);
MaxVal    = max(differences_h);
RangeVal  = range(differences_h);          % Max - Min
mu = MeanVal;
sigma = StdVal;

% Quartiles and IQR
Q1  = prctile(differences_h,25);           % 25th percentile
Q2  = prctile(differences_h,50);           % Median
Q3  = prctile(differences_h,75);           % 75th percentile
IQRv = Q3 - Q1;                       % Interquartile range

% Outlier boundaries (Tukey's rule)
LowerBound = Q1 - 1.5 * IQRv;
UpperBound = Q3 + 1.5 * IQRv;

% Display all descriptive stats in a table
DescStats = array2table([MeanVal; StdVal; MedianVal; VarVal; KurtVal; SkewVal; ...
    RangeVal; Q1; Q2; Q3; IQRv; LowerBound; UpperBound], 'RowNames', ...
    {'MeanVal', 'StdVal', 'MedianVal', 'VarVal', 'KurtVal', 'SkewVal', ...
    'RangeVal', 'Q1', 'Q2', 'Q3', 'IQRv', 'LowerBound', 'UpperBound'});
disp(DescStats)

%% Step 3. Determine Bins using Sturges' Rule
% Observed Histogram data
k = round(1 + 3.322 * log10(length(differences_h)));
[observed_freq, edges] = histcounts(differences_h, k);

centres = edges(1:end-1) + diff(edges)/2;  % Bin centres
range_res = range(differences_h);
ClassRange = range_res / k;
fprintf('\nChi-Square Test Setup:\n');
fprintf('Classes = %d, Class Width = %.4f\n', k, ClassRange);

%% Step 4. Visualization
figure('Color','w','Position',[100 100 950 360],'WindowStyle','docked');
% --- Boxplot (detect outliers, spread, symmetry)
boxplot(differences_h, 'orientation', 'horizontal');
hold on;
xline(MeanVal,'r--','Mean','LabelHorizontalAlignment','left');
xline(LowerBound,'k:','Lower Bound');
xline(UpperBound,'k:','Upper Bound');
title('Boxplot of Paired Differences D = New - Old');
xlabel('Difference (hours)');
grid on; hold off;

% --- Histogram with Normal PDF overlay
figure('Color','w','Position',[100 100 950 360],'WindowStyle','docked');
histogram(differences_h, 'BinEdges', edges, ...
    'FaceColor', [0.3 0.6 0.8], 'FaceAlpha', 0.8);
hold on;

% normpdf() computes Normal probability density
x = linspace(MinVal, MaxVal, 400);
y = normpdf(x, mu, sigma) * n * ClassRange;  % Scale PDF to frequency scale
plot(x, y, 'r-', 'LineWidth', 1.8);

title('Histogram with Normal Overlay');
xlabel('Difference D = New - Old (hours)'); ylabel('Frequency');
legend('Observed','Normal(muHat,sigmaHat)','Location','best');
grid on; hold off;

%% Step 5. Observed Frequencies
% histcounts() counts how many data points fall into each bin
[observed_freq, edges] = histcounts(differences_h, k);
DifferenceBins_h = centres';
Frequency  = observed_freq';
Table_Observed = table(DifferenceBins_h, Frequency)

%% Step 6. Expected Frequencies under Normal(muHat, sigmaHat)
% normcdf() gives cumulative probability of the Normal distribution
cdf_edges = normcdf(edges, mu, sigma);

% diff() computes differences between consecutive CDF values
bin_prob = diff(cdf_edges);

expected = n * bin_prob;

fprintf('\nSum Observed = %.3f, Sum Expected = %.3f\n', sum(Frequency), sum(expected));

%% Step 7. Chi-square Contributions and Test Statistic
chi_contrib = (Frequency - expected').^2 ./ expected';

Chi2Table = table(DifferenceBins_h, Frequency, bin_prob', expected', chi_contrib, ...
    'VariableNames', {'BinCenter','Observed','BinProb','Expected','Chi2Contribution'})

Chi2_Stat = sum(chi_contrib);
df = k - 1 - 2;
p_val = 1 - chi2cdf(Chi2_Stat, df);  % Right-tail p-value using chi2cdf()

fprintf('\nChi-square Statistic = %.3f\nDegrees of Freedom = %d\np-value = %.3f\n', ...
    Chi2_Stat, df, p_val);

%% Step 8. Decision at alpha = 0.05
alpha = 0.05;
if p_val > alpha
    decision = "Fail to reject H0 -> Data consistent with Normality.";
else
    decision = "Reject H0 -> Data deviate from Normality.";
end
fprintf('\nDecision: %s\n', decision);

%% Step 9. Interpretation
fprintf('\n--- Interpretation ---\n');
fprintf('chi2(%d) = %.3f, p = %.3f\n', df, Chi2_Stat, p_val);
fprintf('-> %s\n', decision);
fprintf('Conclusion: The chi-square test suggests %s\n', lower(decision));

mu = MeanVal;
sigma = StdVal;
cdf_edges = normcdf(edges, mu, sigma);
bin_prob = diff(cdf_edges);
expected = n * bin_prob;

% Verify sums
fprintf('\nSum Observed = %.3f, Sum Expected = %.3f\n', sum(Frequency), sum(expected));

%% Step 10. Applicability Diagnostics
small_expected = expected < 5;
fprintf('\n--- Applicability Diagnostics (not a replacement test) ---\n');
fprintf('Number of observations with n = %d\n', n);
fprintf('Minimum expected count = %.3f\n', min(expected));
fprintf('Number of bins with expected count < 5 = %d\n', sum(small_expected));
fprintf('Sum of observed counts = %.3f\n', sum(Frequency));
fprintf('Sum of expected counts = %.3f\n', sum(expected));
fprintf('The finite edges may omit Normal tail probability outside the sample range.\n');
fprintf('Therefore the course calculation is reported, but its chi-square p-value\n');
fprintf('should not be presented as automatically reliable when these conditions fail.\n');
