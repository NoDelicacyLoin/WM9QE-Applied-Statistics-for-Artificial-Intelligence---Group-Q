% Compares mean lifetimes using paired t-tests with D = New - Old.
% The two-sided test asks whether they differ; the right-sided test asks whether New lasts longer on average.

% Source 1: WM9QE_Week2_Normality_Hypothesis_Parametric_Tests.mlx, Section 4, Example 4.4
% Source 2: WM9QE_Week2_Extra_Examples_Hypothesis_Parametric_Tests.mlx, Extra Example 6

%% Step 0. Initialization
clear; clc; close all;
% clear: removes variables from the workspace to avoid contamination.
% clc: clears the command window for a clean start.
% close all: closes any previously open figure windows.

%% Step 1. Input Data
Old = [11 15 19 22 24 27 28 30 31 33 35 36 37 38 39 42 43 46 49 64];
New = [16 21 25 27 32 34 35 36 40 41 43 44 47 48 49 50 52 54 55 61];

n = numel(Old);

fprintf('Number of paired observations: n = %d\n\n', n);

%% Part A — two-sided hypothesis: is there a difference?
fprintf('\n=== PART A: TWO-SIDED PAIRED T-TEST ===\n');
fprintf('Question: is there a mean time-to-failure difference?\n');
fprintf('D = New - Old (hours)\nH0: mu_D = 0\nH1: mu_D ~= 0\n');
fprintf('All inference is conditional on paired-test assumptions.\n');

%% Step 2. Descriptive Statistics
% Compute basic descriptive statistics for both conditions.
Mean_Old = mean(Old);
Mean_New = mean(New);
Std_Old  = std(Old,0);
Std_New  = std(New,0);

Desc = table([Mean_Old; Std_Old; n], ...
              [Mean_New; Std_New; n], ...
              'VariableNames', {'Old','New'}, ...
              'RowNames', {'Mean','StdDev','SampleSize'});

disp('--- DESCRIPTIVE SUMMARY TABLE ---');
disp(Desc);

fprintf(['Interpretation:\n', ...
    '- The mean time to failure for Old is %.2f hours; for New it is %.2f hours.\n', ...
    '- We will test whether this observed paired difference is statistically significant.\n\n'], ...
    Mean_Old, Mean_New);

%% Step 3. Visualization, Boxplot and Histograms
% Always visualize data distributions before hypothesis testing. This step helps check normality, spread, and any outliers visually.

figure('Color','w','Position',[100 100 1200 1500],'WindowStyle','docked');

% ---- (a) Boxplot comparison ----
subplot(2,1,1);
colors = [0 0.4470 0.7410; 0.8500 0.3250 0.0980];  % MATLAB default blue/red

% boxplot(Y): draws box-and-whisker plots.
% Each column of Y is treated as a separate group.
boxplot([Old', New'], ...
        'Labels', {'Old','New'}, ...       % X-axis group labels
        'Colors', colors, ...               % assign group colors
        'Widths', 0.6);                     % width of boxplots

title('Boxplot of Old vs New Time to Failure');
ylabel('Time to Failure (hours)');
grid on;

% ---- (b) Histograms + normal distribution overlays ----
subplot(2,1,2); hold on;

% histogram(x,'Normalization','pdf'): plots a histogram scaled as a
% probability density function (so the area = 1).
histogram(Old, 'Normalization','pdf', ...
           'FaceColor',colors(1,:), 'FaceAlpha',0.7);
histogram(New, 'Normalization','pdf', ...
           'FaceColor',colors(2,:), 'FaceAlpha',0.6);

% Overlay theoretical normal distributions for each group.
% normpdf(x,mu,sigma): returns values of the normal PDF.
x = linspace(min([Old New])-2, max([Old New])+2, 400);
plot(x, normpdf(x, Mean_Old, Std_Old), 'Color',colors(1,:), 'LineWidth',1.6);
plot(x, normpdf(x, Mean_New, Std_New), 'Color',colors(2,:), 'LineWidth',1.6);

title('Distribution of Time to Failure (Old vs New)');
xlabel('Time to Failure (hours)'); ylabel('Probability Density');
legend('Old data','New data','Normal Fit (Old)','Normal Fit (New)', ...
       'Location','best');
grid on; hold off;

%% Step 4. Compute Paired Differences and t-Test Statistic
D = New - Old;
dbar = mean(D);            % mean difference
sd_d = std(D,0);
SE_d = sd_d / sqrt(n);     % standard error of the mean difference
df = n - 1;                % degrees of freedom for t-test

% Test statistic formula:
t_stat = dbar / SE_d;

% Set significance level (two-tailed test)
alpha = 0.05;

% tinv(p,df): inverse t-distribution function.
% Returns t-critical value such that P(T <= tcrit) = p for given df.
t_crit = tinv(1 - alpha/2, df);

% tcdf(x,df): cumulative distribution function of t.
p_two = 2 * (1 - tcdf(abs(t_stat), df));

% Display computed statistics.
fprintf('\n--- PAIRED T-TEST RESULTS ---\n');
fprintf('Mean difference (New-Old) = %.3f hours\n', dbar);
fprintf('Std deviation of differences (s_d) = %.3f\n', sd_d);
fprintf('Standard Error (SE_d) = %.3f\n', SE_d);
fprintf('Degrees of freedom (df) = %d\n', df);
fprintf('t-statistic = %.3f\n', t_stat);
fprintf('t-critical (two-tailed, alpha=0.05) = +/- %.3f\n', t_crit);
fprintf('p-value (two-tailed) = %.6g\n', p_two);

% Decision logic: compare p-value or t-statistic to criteria.
if p_two < alpha
    decision = 'Reject H0: the mean paired difference is not zero.';
else
    decision = 'Fail to reject H0: no significant evidence of a non-zero mean paired difference.';
end
fprintf('Decision: %s\n', decision);

%% Step 5. 95% Confidence Interval for Mean Difference
% Formula:
%   CI = d̄ ± t_(α/2, df) × (s_d / √n)

% Compute lower and upper bounds:
CI_low  = dbar - t_crit * SE_d;
CI_high = dbar + t_crit * SE_d;

% Display the CI numerically:
fprintf('\n--- 95%% Confidence Interval for Mean Difference ---\n');
fprintf('CI = [%.3f , %.3f] hours\n', CI_low, CI_high);

% Create a small, labeled table for easy viewing:
CITable = table(dbar, SE_d, t_crit, CI_low, CI_high, ...
    'VariableNames', {'MeanDiff','StdError','tCritical','LowerBound','UpperBound'});
disp('--- Confidence Interval Summary ---');
disp(CITable);

% Interpret the interval in plain language:
if CI_low <= 0 && CI_high >= 0
    fprintf('Interpretation:\n');
    fprintf('  0 lies within the CI -> the true mean difference could be zero.\n');
    fprintf('  Therefore, we fail to reject H0 at alpha = 0.05.\n');
else
    fprintf('Interpretation:\n');
    fprintf('  0 is NOT within the CI -> the mean difference is supported by the interval.\n');
    fprintf('  Therefore, reject H0 at alpha = 0.05.\n');
end

%% Step 6. Visualize t-Distribution with Rejection Regions (Optional)
x = linspace(-4,4,400);     % range of t values for plotting
y = tpdf(x,df);              % t-distribution density for df degrees of freedom

figure('Color','w','Position',[100 100 900 450],'WindowStyle','docked');
h_density = plot(x, y, 'k-', 'LineWidth', 1.5); hold on;

% area(): fills regions under the curve to show rejection zones.
h_left = area(x(x < -t_crit), y(x < -t_crit), 'FaceColor',[1 0.6 0.6], 'EdgeColor','none');
h_right = area(x(x >  t_crit), y(x >  t_crit), 'FaceColor',[1 0.6 0.6], 'EdgeColor','none');

% xline(): vertical reference lines.
% We mark the observed t-statistic for clarity.
h_observed = xline(t_stat,'--','Color',[0.2 0.2 0.2],'LineWidth',1.5,...
    'Label','t_{calc}','LabelHorizontalAlignment','center',...
    'LabelVerticalAlignment','bottom');

title(sprintf('Paired t-Distribution (df = %d, alpha = 0.05, Two-Tailed)', df));
subtitle('H_0: \mu_D = 0; H_1: \mu_D \neq 0   (D = New - Old)');
xlabel('t value'); ylabel('Probability Density');
legend([h_density h_left h_observed], ...
       't(df)','Rejection regions (alpha/2 each side)','Observed t-statistic', ...
       'Location','northwest');
grid on; hold off;

%% Step 7. Interpretation
fprintf('\n--- INTERPRETATION ---\n');
fprintf('At alpha = 0.05:\n');
fprintf('  |t| = %.3f, tcrit = %.3f.\n', abs(t_stat), t_crit);

if abs(t_stat) > t_crit
    fprintf('  |t| > tcrit, Reject H0.\n');
    fprintf('  There is significant evidence that the mean paired difference is not zero.\n');
else
    fprintf('  |t| < tcrit, Fail to reject H0.\n');
    fprintf('  There is insufficient evidence that the mean paired difference is not zero.\n');
end

fprintf('95%% Confidence Interval = [%.2f , %.2f] hours.\n', CI_low, CI_high);
fprintf('If this interval includes zero, the mean difference could be zero.\n');

% Create a compact final summary table for reports.
Results = table(n, dbar, sd_d, SE_d, df, t_stat, t_crit, p_two, ...
                CI_low, CI_high, string(decision), ...
    'VariableNames', {'n','MeanDiff','StdDiff','StdError','df','t_stat','t_crit', ...
                      'p_value','CI_Lower','CI_Upper','Decision'});

disp('--- FINAL SUMMARY TABLE ---');
disp(Results);

fprintf('\nConclusion:\n');
fprintf('The paired t-test evaluates whether the average Old/New change\n');
fprintf('is significantly different from zero for the supplied matched rows.\n');
fprintf('No causal effect or stress-response interaction is established.\n');

%% Step 8. Practical Summary
% Why we used a paired t-test:

%% Part B — right-sided hypothesis: does New last longer on average?

fprintf('\n=== PART B: RIGHT-SIDED PAIRED T-TEST ===\n');
fprintf('Question: does New have a longer mean ALT time to failure?\n');
fprintf('D = New - Old (hours)\nH0: mu_D <= 0\nH1: mu_D > 0\n');
fprintf('Null-boundary calculation: mu_D = 0; alpha = 0.05.\n');
fprintf('Added after seeing the data; supplementary, not independent confirmation.\n');
fprintf('Inference remains conditional on independence and the distribution of D.\n');

mean_new = Mean_New;
mean_old = Mean_Old;
sd_new = Std_New;
sd_old = Std_Old;
n_new = n;
n_old = n;
diff_mean = dbar;
SE = SE_d;
t_calc = t_stat;

%% Part B — Step 2: right-tail critical value and p-value
% --- Critical Value and p-Value (Right-tailed test) ---
alpha = 0.05;

% t critical value for 1 - α quantile (right tail)
t_crit_right = tinv(1 - alpha, df);

% p-value = probability of observing t_calc or greater
p_right = 1 - tcdf(t_calc, df);
%% Part B — Step 3: numerical results and decision
fprintf('\nRight-Tailed Paired t-Test (supplier claim)\n');
fprintf('----------------------------------------------------\n');
fprintf('Group Means and Variability:\n');
fprintf('  Mean (New): %.2f hours\n', mean_new);
fprintf('  Mean (Old): %.2f hours\n', mean_old);
fprintf('  Std. Dev (New): %.2f\n', sd_new);
fprintf('  Std. Dev (Old): %.2f\n', sd_old);
fprintf('  Matched observations: New = %d, Old = %d (paired)\n', n_new, n_old);
fprintf('----------------------------------------------------\n');
fprintf('Test Statistic and Results:\n');
fprintf('  Mean difference (New - Old): %.3f hours\n', diff_mean);
fprintf('  Standard Error (SE): %.4f\n', SE);
fprintf('  t_calc = %.3f\n', t_calc);
fprintf('  Degrees of freedom (paired df = n-1) = %.0f\n', df);
fprintf('  t_crit_right (alpha = 0.05, one-tailed) = %.3f\n', t_crit_right);
fprintf('  p-value (one-tailed) = %.6g\n', p_right);

% --- Decision Rule ---
if t_calc > t_crit_right
    decision_right = "Reject H0 -> New has a greater mean ALT time to failure under the test assumptions.";
else
    decision_right = "Fail to reject H0 -> Insufficient evidence that New has greater mean ALT time to failure.";
end
fprintf('----------------------------------------------------\n');
fprintf('Decision: %s\n', decision_right);

%% Part B — Step 4: right-tail rejection region

x = linspace(min(-4,t_calc-1),max(4,t_calc+1),500);  % x-axis range for plotting t values
y = tpdf(x, df);         % compute probability density values for t-distribution

figure('Color','w','Position',[100 100 850 450],'WindowStyle','docked');
plot(x, y, 'k-', 'LineWidth', 1.5); hold on;

% --- Shade rejection region (right tail where we reject H0) ---
area(x(x > t_crit_right), y(x > t_crit_right), 'FaceColor',[1 0.6 0.6], 'EdgeColor','none');

xline(t_calc, 'r--', 'LineWidth', 1.5, 'Label','t_{calc}', ...
    'LabelVerticalAlignment','bottom','LabelHorizontalAlignment','center');
xline(t_crit_right, 'b--', 'LineWidth', 1.2, 'Label','t_{crit,right}', ...
    'LabelVerticalAlignment','top','LabelHorizontalAlignment','center');

% --- Add plot labels and legend ---
title(sprintf('Paired t-Distribution (df = %.0f, alpha = 0.05, Right-Tailed)', df));
subtitle('H_0: \mu_D \leq 0; H_1: \mu_D > 0   (D = New - Old)');
xlabel('t value');
ylabel('Probability Density');
legend('t-distribution','Rejection region (right tail)','Location','northwest');
grid on;
hold off;
%% Part B — Step 5: interpretation
fprintf('\nINTERPRETATION\n');
fprintf('----------------------------------------------------\n');
fprintf('At alpha = 0.05 (right-tailed test):\n');
fprintf('  Calculated t = %.2f\n', t_calc);
fprintf('  Critical t = %.2f\n', t_crit_right);
fprintf('  p-value = %.6g\n', p_right);

if t_calc > t_crit_right
    fprintf('\n-> Since t_calc > t_crit_right, we REJECT H0.\n');
    fprintf('  There is statistically significant evidence that the new resistor\n');
    fprintf('  has a greater mean ALT time to failure than the old resistor.\n');
else
    fprintf('\n-> Since t_calc <= t_crit_right, we FAIL TO REJECT H0.\n');
    fprintf('  We do not have sufficient evidence that the new resistor\n');
    fprintf('  has a greater mean ALT time to failure.\n');
end
fprintf('----------------------------------------------------\n');
fprintf('Scope: mean advantage across the supplied matched ALT conditions.\n');
fprintf('This does not establish superiority at every stress level or normal-use lifetime.\n');
fprintf('The 95%% CI printed in Part A is the TWO-SIDED CI, not a one-sided bound.\n');
