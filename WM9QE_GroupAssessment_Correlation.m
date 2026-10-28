% calculates Pearson and Spearman correlations between Old & New lifetimes across matched conditions.

% Source 1: WM9QE_Week1_Descriptive_Statistics_New.mlx, Section 3 (Week 01, Session 02)
% Source 2: WM9QE_Week1_Session1_Independent_Learning_Solution.mlx, Exercise 8 (Week 01, Session 01)

clear; clc; close all;

%% Input Data
Old = [11 15 19 22 24 27 28 30 31 33 35 36 37 38 39 42 43 46 49 64];
New = [16 21 25 27 32 34 35 36 40 41 43 44 47 48 49 50 52 54 55 61];
D = New - Old;

%% Section 3 -> Pearson Correlation for Feature Selection
features = Old';
target_corr = corr(features, New');
fprintf('Feature-Target Correlations:\n');
fprintf('Old vs New: r = %.3f\n', target_corr(1));
corr_matrix = corr(features);
fprintf('\nFeature Correlation Matrix:\n');
disp(corr_matrix);
names = {'Old'};
figure('Name','Pearson Correlation','Position',[100 100 900 350],'WindowStyle','docked');
subplot(1,2,1);
bar(abs(target_corr)); hold on
yline(0.7, 'g--', 'Strong');
set(gca,'XTickLabel',names);
ylabel('|Correlation| with New'); title('Descriptive association');
ylim([0 1]); grid on
subplot(1,2,2);
imagesc(corr_matrix); colorbar; clim([-1 1]);
set(gca,'XTick',1,'XTickLabel',names,'YTick',1,'YTickLabel',names);
title('Single-input correlation matrix'); axis square
drawnow

%% Section 3 -> AI Application Example -> Step 2: Calculate Correlation Matrix
% Combine all variables into a single data matrix
dataMatrix = [Old', New'];
featureNames = {'Old','New'};

% --- 2. PEARSON CORRELATION (Linear Relationship) ---

% Calculate Pearson correlation matrix
R_Pearson = corr(dataMatrix, 'Type', 'Pearson');

fprintf('====================================================\n');
fprintf('               PEARSON CORRELATION MATRIX (R)\n');
fprintf('====================================================\n');
disp(array2table(R_Pearson, 'VariableNames', featureNames, 'RowNames', featureNames));

% --- 3. SPEARMAN CORRELATION (Monotonic Relationship) ---

% Calculate Spearman rank correlation matrix
R_Spearman = corr(dataMatrix, 'Type', 'Spearman');

fprintf('====================================================\n');
fprintf('              SPEARMAN CORRELATION MATRIX (rho)\n');
fprintf('====================================================\n');
disp(array2table(R_Spearman, 'VariableNames', featureNames, 'RowNames', featureNames));

% --- 4. VISUALIZATION ---

% Figure 1: Heatmap for Pearson Correlation
figure('Name', 'Pearson Correlation Heatmap','WindowStyle','docked');
h_pearson = heatmap(featureNames, featureNames, R_Pearson);
h_pearson.Title = 'Pearson Correlation (Linear Relationships)';
h_pearson.FontSize = 10;
colormap(jet); % Use jet or other color map
colorbar;

% Figure 2: Heatmap for Spearman Correlation
figure('Name', 'Spearman Correlation Heatmap','WindowStyle','docked');
h_spearman = heatmap(featureNames, featureNames, R_Spearman);
h_spearman.Title = 'Spearman Correlation (Monotonic Relationships)';
h_spearman.FontSize = 10;
colormap(jet); % Use jet or other color map
colorbar;

% Calculate correlation matrix for features again
corrMatrix = corr(dataMatrix);

threshold = 0.8;
[row, col] = find(abs(corrMatrix) > threshold & corrMatrix < 1);

fprintf('High Correlation Pairs (|r| > %.2f):\n', threshold);
if isempty(row)
    fprintf('  None found.\n');
else
    for k = 1:length(row)
        if row(k) < col(k)
            fprintf('  %s <-> %s: r = %.3f\n', ...
                featureNames{row(k)}, featureNames{col(k)}, ...
                corrMatrix(row(k), col(k)));
        end
    end
end
fprintf('\n');

%% Scatter: Week 1 Session1 Independent Learning Solution -> Exercise 8: Feature Correlation Scatter Plot
figure('WindowStyle','docked');
% >>> Write your code here <<<

old_time_h = Old;
new_time_h = New;

scatter(old_time_h, new_time_h, 80, 'b','filled'); hold on

% Fit linear regression

xlabel('Old (hours)'); ylabel('New (hours)');
title('Matched Old vs New'); grid on
legend('Matched pairs'); hold off
