%% Start

clc
close all;
clear all;

% open the result file
% !! replace # with your own groupID
fid = fopen('ECE313_Final_group20_(winning_group)', 'w');

%% TASK 0

% LOAD PATIENT DATA

patient(1) = load('1_a41178.mat');
patient(2) = load('2_a42126.mat');
patient(3) = load('3_a40076.mat');
patient(4) = load('4_a40050.mat');
patient(5) = load('5_a41287.mat');
patient(6) = load('6_a41846.mat');
patient(7) = load('7_a41846.mat');
patient(8) = load('8_a42008.mat');
patient(9) = load('9_a41846.mat');

for i = 1:9
    patient(i).all_data_flr = floor(patient(i).all_data);
    patient(i).len = length(patient(i).all_labels);
    patient(i).train_data = patient(i).all_data_flr(:, 1:floor(((2/3)*patient(i).len)));
    patient(i).train_labels = patient(i).all_labels(:, 1:floor(((2/3)*patient(i).len)));
    patient(i).test_data = patient(i).all_data_flr(:, (floor(((2/3)*patient(i).len))+1):patient(i).len);
    patient(i).test_labels = patient(i).all_labels(:, (floor(((2/3)*patient(i).len))+1):patient(i).len);
    patient(i).pat_idx = i;
end

fprintf(fid, 'TASK 0\n\n');
fprintf(fid, 'In this task, we created an array of patient structures to keep track of all patient data.\n');
fprintf(fid, 'Each module loaded consisted of "all_data" and "all_labels" vectors. These vectors were\n');
fprintf(fid, 'stored in the patient structure. Next, the test and training data/label sets were created for\n');
fprintf(fid, 'each patient and appended.\n\n');

%% TASK 1.1A

for i = 1:9
    patient(i).h1 = sum(patient(i).train_labels)/length(patient(i).train_labels);
    patient(i).h0 = 1 - patient(i).h1;
end

fprintf(fid, 'TASK 1.1A\n\n');
fprintf(fid, 'The following are the prior probabilities of H1 and H0 respectively for each patient.\n\n');

for i = 1:9
    fprintf(fid, 'P(H1)=%d \t\t\t P(H0)=%d\n', patient(i).h1, patient(i).h0);
end

%% TASK 1.1B

for i = 1:9
    patient(i).mats = cell(1,7);
    %patient(i).maxminfeat = cell(1,7);
    for j = 1:7
        patient(i).mats{1,j} = likelihood_matrix(patient(i).train_data(j,:), patient(i).train_labels);
        %patient(i).mmfeat{1,j} = mmfeat(patient(i).mats{1,j});
    end
end

fprintf(fid, '\nTASK 1.1B\n\n');
fprintf(fid, 'For this task, we constructed the likelihood matrices for each of the seven features\n');
fprintf(fid, 'for each patient. This information can be seen in the patients structure. For each patient,\n');
fprintf(fid, 'there exists a 1x7 cell called "mats".\n\n');

%% TASK 1.1C

for i = 1:9
    figure(i);
    for j = 1:7
        subplot(7, 1, j);
        plot(patient(i).mats{1,j}(1,:), patient(i).mats{1,j}(3,:));
        hold on;
        plot(patient(i).mats{1,j}(1,:), patient(i).mats{1,j}(2,:));
        xlabel(['Feature']);
        ylabel('Probability');
        title('Probabilities of H0 & H1 vs. Feature');
        legend('H0 pmf', 'H1 pmf');
    end
    %imagename = strcat(num2str(i));
    %saveas(gcf,imagename,'jpeg');
end


fprintf(fid, 'TASK 1.1C\n\n');
fprintf(fid, 'When the code runs, 9 figures will be presented. These figures summarize our results as required.\n\n');

%% TASK 1.1D

for i = 1:9
    patient(i).ml_vecs = cell(1,7);
    patient(i).map_vecs = cell(1,7);
    for j = 1:7
        ml_dr_vec = zeros(1,size(patient(i).mats{1,j},2));
        map_dr_vec = zeros(1,size(patient(i).mats{1,j},2));
        for k = 1:size(patient(i).mats{1,j},2)
            if (patient(i).mats{1,j}(2,k) >= patient(i).mats{1,j}(3,k))
                ml_dr_vec(1,k) = 1;
            end
            if (patient(i).mats{1,j}(2,k)*patient(i).h1 >= patient(i).mats{1,j}(3,k)*patient(i).h0)
                map_dr_vec(1,k) = 1;
            end
        end
        patient(i).ml_vecs{1,j} = ml_dr_vec;
        patient(i).map_vecs{1,j} = map_dr_vec;
    end
end

fprintf(fid, 'TASK 1.1D\n\n');
fprintf(fid, 'For this task, we constructed the ML and MAP vectors for each patient. These vectors\n');
fprintf(fid, 'were appended to each patient structure in the patient array.\n\n');

%% TASK 1.1E

HT_table_array = cell(9,7);

for i = 1:9
    for j = 1:7
        HT_table_array{i,j} = create_ht_table(patient(i), j);
    end
end

fprintf(fid, 'TASK 1.1E\n\n');
fprintf(fid, 'For this task, we constructed the 9x7 HT_table_array. Each index into the array is an Fx5 array,\n');
fprintf(fid, 'where F is total number of distinct values a particular feature can take.\n\n');

%% TASK 1.2

Error_table_array = cell(9,7);

for i = 1:9
    for j = 1:7
        % fprintf('%d %d\n', i, j);
        % Problem encountered: Test data does not appear in training data
        % Wait for answer in Piazza
        % -> Already Solved
        Error_table_array{i,j} = create_error_table(patient(i), j, HT_table_array{i,j});
    end
end

fprintf(fid, 'TASK 1.2\n\n');
fprintf(fid, 'For this task, we constructed the 9x7 Error_table_array. Each index into the array is a 2x3 array.\n');
fprintf(fid, 'This smaller array contains the following information: P(False Alarm), P(Missed Detection),\n');
fprintf(fid, 'and P(Error). These values are presented in reference to both ML and MAP rules.\n\n');

%% TASK 2.1

fprintf(fid, 'TASK 2.1\n\n');

correlation_matrix = zeros(9,9);

for i = 1:9
    for k = 1:9
        len1 = size(patient(i).train_data,2);
        len2 = size(patient(k).train_data,2);
        minlen = min(len1,len2);
        data1 = patient(i).train_data(1,1:minlen);
        data2 = patient(k).train_data(1,1:minlen);
        cor = corrcoef(data1, data2);
        
        correlation_matrix(i,k) = cor(1,2);
        
        if((cor==1) & (i ~= k))
            %patients i and k have share same data
            fprintf(fid, 'Patients %d and %d have the same data.\n\n', i, k);
        end
        
    end
end

fprintf(fid, 'The correlation matrix is stored in the correlation_matrix variable. As one can see in the data structure, apart\n');
fprintf(fid, 'from the datasets of the same patients correlating with themselves, we can also see that there are datasets of different\n');
fprintf(fid, 'patients that have exactly the same data. These patients are patients 6 and 9. This redundancy is problematic and\n');
fprintf(fid, 'to improve our data overall we can choose to eliminate either patients data.\n\n');

%% TASK 2.2

% debug
%[feat_idx1, feat_idx2] = select_two_feats_ML_MAP(patient(1), HT_table_array(1,:))
%[feat_idx1, feat_idx2] = select_two_feats_cor_golden(patient(1));

% metric 1 - lowest ML/MAP & metric 2 - golden correlation

% for each patient, use a vote to select the best two features
% break ties arbitrarily

best_feat_indices = zeros(9,2);
best_feat_indices_three = zeros(9,3);
best_feat_indices_four = zeros(9,4);
best_feat_indices_five = zeros(9,5);
best_feat_indices_six = zeros(9,6);
best_feat_indices_metric1 = zeros(9,2);
best_feat_indices_metric2 = zeros(9,2);

for i = 1:9
    votes = zeros(1,7);
    [feat_idx1, feat_idx2] = select_two_feats_ML_MAP(patient(i), HT_table_array(i,:));
    best_feat_indices_metric1(i,1) = feat_idx1;
    best_feat_indices_metric1(i,2) = feat_idx2;
    votes(1,feat_idx1) = votes(1,feat_idx1)+1;
    votes(1,feat_idx2) = votes(1,feat_idx2)+1;
    [feat_idx1, feat_idx2] = select_two_feats_cor_golden(patient(i));
    best_feat_indices_metric2(i,1) = feat_idx1;
    best_feat_indices_metric2(i,2) = feat_idx2;
    votes(1,feat_idx1) = votes(1,feat_idx1)+1;
    votes(1,feat_idx2) = votes(1,feat_idx2)+1;
    
    [val, feat_idx1] = max(votes);
    votes2 = votes(:);
    votes2(feat_idx1) = -inf;
    [val2, feat_idx2] = max(votes2);
    votes3 = votes2(:);
    votes3(feat_idx2) = -inf;
    [val3, feat_idx3] = max(votes3);
    votes4 = votes3(:);
    votes4(feat_idx3) = -inf;
    [val4, feat_idx4] = max(votes4);
    votes5 = votes4(:);
    votes5(feat_idx4) = -inf;
    [val5, feat_idx5] = max(votes5);
    votes6 = votes5(:);
    votes6(feat_idx5) = -inf;
    [val6, feat_idx6] = max(votes6);
    
    % first feature
    best_feat_indices(i,1) = feat_idx1;
    best_feat_indices_four(i,1) = feat_idx1;
    best_feat_indices_three(i,1) = feat_idx1;
    best_feat_indices_five(i,1) = feat_idx1;
    best_feat_indices_six(i,1) = feat_idx1;
    
    % second feature
    best_feat_indices(i,2) = feat_idx2;
    best_feat_indices_four(i,2) = feat_idx2;
    best_feat_indices_three(i,2) = feat_idx2;
    best_feat_indices_five(i,2) = feat_idx2;
    best_feat_indices_six(i,2) = feat_idx2;
    
    % third feature
    best_feat_indices_four(i,3) = feat_idx3;
    best_feat_indices_three(i,3) = feat_idx3;
    best_feat_indices_six(i,3) = feat_idx3;
    best_feat_indices_five(i,3) = feat_idx3;
    
    % fourth feature
    best_feat_indices_four(i,4) = feat_idx4;
    best_feat_indices_six(i,4) = feat_idx4;
    best_feat_indices_five(i,4) = feat_idx4;
    
    best_feat_indices_six(i,5) = feat_idx5;
    best_feat_indices_five(i,5) = feat_idx5;
    best_feat_indices_six(i,6) = feat_idx6;
end

% metric 3 - correlation (calculated now but used later in task 3)
% this is done now because it is necessary for the code directly below

best_feat_corr = zeros(9,2);

for i = 1:9
    patient(i).feat_corr = feature_corrs(patient(i));
    min_corr = min(min(patient(i).feat_corr));
    [min_row, min_col] = find(patient(i).feat_corr==min_corr);
    min_row = min_row(1);
    min_col = min_col(1);
    best_feat_corr(i,1) = min_row;
    best_feat_corr(i,2) = min_col;
end

% the least correlated pair out of three

best_feat_err_corr_three = zeros(9,2);

for i = 1:9
    minval = 1;
    min1 = 1;
    min2 = 1;
    for j = 1:3
        for k = (j+1):3
            if (patient(i).feat_corr(best_feat_indices_three(i,j),best_feat_indices_three(i,k))<minval)
                minval = patient(i).feat_corr(best_feat_indices_three(i,j),best_feat_indices_three(i,k));
                min1 = best_feat_indices_three(i,j);
                min2 = best_feat_indices_three(i,k);
            end
        end
    end
    best_feat_err_corr_three(i,1) = min1;
    best_feat_err_corr_three(i,2) = min2;
end

% the least correlated pair out of four

best_feat_err_corr_four = zeros(9,2);

for i = 1:9
    minval = 1;
    min1 = 1;
    min2 = 1;
    for j = 1:4
        for k = (j+1):4
            if (patient(i).feat_corr(best_feat_indices_four(i,j),best_feat_indices_four(i,k))<minval)
                minval = patient(i).feat_corr(best_feat_indices_four(i,j),best_feat_indices_four(i,k));
                min1 = best_feat_indices_four(i,j);
                min2 = best_feat_indices_four(i,k);
            end
        end
    end
    best_feat_err_corr_four(i,1) = min1;
    best_feat_err_corr_four(i,2) = min2;
end

% the least correlated pair out of five

best_feat_err_corr_five = zeros(9,2);

for i = 1:9
    minval = 1;
    min1 = 1;
    min2 = 1;
    for j = 1:5
        for k = (j+1):5
            if (patient(i).feat_corr(best_feat_indices_five(i,j),best_feat_indices_five(i,k))<minval)
                minval = patient(i).feat_corr(best_feat_indices_five(i,j),best_feat_indices_five(i,k));
                min1 = best_feat_indices_five(i,j);
                min2 = best_feat_indices_five(i,k);
            end
        end
    end
    best_feat_err_corr_five(i,1) = min1;
    best_feat_err_corr_five(i,2) = min2;
end

% the least correlated pair out of six

best_feat_err_corr_six = zeros(9,2);

for i = 1:9
    minval = 1;
    min1 = 1;
    min2 = 1;
    for j = 1:6
        for k = (j+1):6
            if (patient(i).feat_corr(best_feat_indices_six(i,j),best_feat_indices_six(i,k))<minval)
                minval = patient(i).feat_corr(best_feat_indices_six(i,j),best_feat_indices_six(i,k));
                min1 = best_feat_indices_six(i,j);
                min2 = best_feat_indices_six(i,k);
            end
        end
    end
    best_feat_err_corr_six(i,1) = min1;
    best_feat_err_corr_six(i,2) = min2;
end

% Technique 4: weights (calculated but not used)

weights_for_all_pat = zeros(9,7);
for i = 1:9
    weights_for_all_pat(i,:) = assign_weights(patient(i), HT_table_array(i,:));
    patient(i).weights = weights_for_all_pat(i,:);
end

fprintf(fid, 'TASK 2.2\n\n');
fprintf(fid, 'For this task, we implemented two ways to select the top two features. The first way was to find\n');
fprintf(fid, 'the top two features that had the lowest min(ML error, MAP error) value. This method is expected to work because\n');
fprintf(fid, 'intuitively, a feature is good if it has the lowest error using the MAP or ML decision rules. \n');
fprintf(fid, 'The second way was to find the top two features that had the closest correlation to the golden alarms.\n');
fprintf(fid, 'It is a good method because intuitively, a feature has a strong influence on the actual result if it is \n');
fprintf(fid, 'strongly correlated with the golden labels.\n');
fprintf(fid, '\nWe found that the top two features for the three patients we chose (4,5,7) are:\n\n');

fprintf(fid, 'Patient 4: 3 \t 1\n');
fprintf(fid, 'Patient 5: 1 \t 2\n');
fprintf(fid, 'Patient 7: 5 \t 3\n\n');

fprintf(fid, 'Although in this task, we used only metric 1 and 2 to select our pair of features, we will use a variety of tests\n');
fprintf(fid, 'and metrics later in task 3. This will hopefully help us better select the best pair of features for each patient.\n\n');

%% TASK 3.1ABC

for i = 1:9
    f1 = best_feat_indices(i,1);
    f2 = best_feat_indices(i,2);
    patient(i).Joint_HT_table = joint_ht(patient(i),f1,f2);
end

fprintf(fid, 'TASK 3.1ABC\n\n');
fprintf(fid, 'We calculated the joint ht table for all of the nine patients.\n');
fprintf(fid, 'For patient i, we stored the table in patient(i).Joint_HT_table\n\n');

%% TASK 3.1D

fig_num = 0;
for i = [4,5,7]
    f1 = best_feat_indices(i,1);
    f2 = best_feat_indices(i,2);
    feat1 = patient(i).mats{1,f1};
    feat2 = patient(i).mats{1,f2};
    size_f1 = size(feat1,2);
    size_f2 = size(feat2,2);
    
    pmf_h1 = zeros(size_f1,size_f2);
    pmf_h0 = zeros(size_f1,size_f2);
    
    for j = 1:size_f1
        for k = 1:size_f2
            row_num = (j-1)*size_f2+k;
            pmf_h1(j,k) = patient(i).Joint_HT_table(row_num,3);
            pmf_h0(j,k) = patient(i).Joint_HT_table(row_num,4);
        end
    end
    
    title_str = strcat('Patient-',int2str(i));
    x_str = 'Feature 2 Value';
    y_str = 'Feature 1 Value';
    
    fig_num = fig_num + 1;
    figure(fig_num+9);
    mesh(feat2(1,:),feat1(1,:),pmf_h1);
    z_str = 'Conditional Probability Given H1';
    xlabel(x_str);
    ylabel(y_str);
    zlabel(z_str);
    title(title_str);
    
    fig_num = fig_num + 1;
    figure(fig_num+9);
    mesh(feat2(1,:)',feat1(1,:)',pmf_h0);
    z_str = 'Conditional Probability Given H0';
    xlabel(x_str);
    ylabel(y_str);
    zlabel(z_str);
    title(title_str);
end

fprintf(fid, 'TASK 3.1D\n\n');
fprintf(fid, 'We plotted the conditional PMFs for patients 4, 5, and 7.\n');
fprintf(fid, 'For each patient, there are two plots, one for the condition on H1, the other on H0.\n');
fprintf(fid, 'In each plot, a point represents how likely an alarm exists given the two feature values Xi and Yj,\n'); 
fprintf(fid, 'and given either H1 or H0.\n\n');

%% TASK 3.2A

for i = 1:9
    
    f1 = best_feat_indices(i,1);
    f2 = best_feat_indices(i,2);
    jht = patient(i).Joint_HT_table;
    test_data_size = size(patient(i).test_data,2);
    
    patient(i).joint_ml_vec = zeros(1,test_data_size);
    patient(i).joint_map_vec = zeros(1,test_data_size);
    
    for j = 1:test_data_size
        % find rows in Joint_HT_table corresponding to feature idx f1
        idx1_arr = find(jht(:,1)==patient(i).test_data(f1,j));
        
        if size(idx1_arr,1)==0
            patient(i).joint_ml_vec(1,j) = 1;
            patient(i).joint_map_vec(1,j) = 1;
        else
            % take the subset of Joint_HT_table corresponding to feature idx f1
            jht_f1 = jht(idx1_arr,:);
            
            % find rows in the subset of Joint_HT_table corresponding to
            % feature idx f2
            idx2_arr = find(jht_f1(:,2)==patient(i).test_data(f2,j));
            if size(idx2_arr,1) == 0
                patient(i).joint_ml_vec(1,j) = 1;
                patient(i).joint_map_vec(1,j) = 1;
            else
                % fill in the ml and map decision vectors
                patient(i).joint_ml_vec(1,j) = jht_f1(idx2_arr(1,1),5);
                patient(i).joint_map_vec(1,j) = jht_f1(idx2_arr(1,1),6);
            end
        end
    end
end

%% TASK 3.2B

joint_error_table_array = cell(1,9);

for i = 1:9
    mat = zeros(2, 3);
    
    % ML rule
    [probFalse, probMiss, probError] = CompareVoter(patient(i).joint_ml_vec, patient(i).test_labels);
    mat(1,1) = probFalse;
    mat(1,2) = probMiss;
    mat(1,3) = probError;
    
    % MAP rule
    [probFalse, probMiss, probError] = CompareVoter(patient(i).joint_map_vec, patient(i).test_labels);
    mat(2,1) = probFalse;
    mat(2,2) = probMiss;
    mat(2,3) = probError;
    
    joint_error_table_array{1,i} = mat;
end

fprintf(fid, 'TASK 3.2AB\n\n');
fprintf(fid, 'We calculated an error table for each of the nine patients.\n');
fprintf(fid, 'The table for patient i is stored in joint_error_table_array{1,i} which is a 9*2 array.\n\n');

%% TASK 3.2C

for i = 1:9
    figure(i+18);
    subplot(3, 1, 1);
    bar(patient(i).joint_ml_vec);
    xlabel(['ML']);
    ylabel('Alarm');
    title_str = sprintf('Alarms of Patient %d',i);
    title(title_str);
    subplot(3, 1, 2);
    bar(patient(i).joint_map_vec);
    xlabel(['MAP']);
    ylabel('Alarm');
    subplot(3, 1, 3);
    bar(patient(i).test_labels);
    xlabel(['Golden']);
    ylabel('Alarm');
end

fprintf(fid, 'TASK 3.2C\n\n');
fprintf(fid, 'For each patient, we graphed one plot, containing three subplots.\n');
fprintf(fid, 'Those three subplots correspond to the alarms denoted by ML prediction, MAP prediction, and the golden labels.\n\n');

%% TASK 3.3B

joint_error_table_array_try_array = cell(1,15);
ml_error_array = cell(1,15);
map_error_array = cell(1,15);
avg_error_array = cell(1,15);

% 1st: metric 1 and 2
[joint_error_table_array_try_array{1,1}, ml_error_array{1,1}, map_error_array{1,1}, avg_error_array{1,1}] = calc_error_two_features_train(patient, best_feat_indices);

% 2nd: metric 3
[joint_error_table_array_try_array{1,2}, ml_error_array{1,2}, map_error_array{1,2}, avg_error_array{1,2}] = calc_error_two_features_train(patient, best_feat_corr);

% 3st: only use feature 1
default_feat = ones(9,2);
[joint_error_table_array_try_array{1,3}, ml_error_array{1,3}, map_error_array{1,3}, avg_error_array{1,3}] = calc_error_two_features_train(patient, default_feat);

% 4th: metric 1 only
[joint_error_table_array_try_array{1,4}, ml_error_array{1,4}, map_error_array{1,4}, avg_error_array{1,4}] = calc_error_two_features_train(patient, best_feat_indices_metric1);

% 5th: metric 2 only
[joint_error_table_array_try_array{1,5}, ml_error_array{1,5}, map_error_array{1,5}, avg_error_array{1,5}] = calc_error_two_features_train(patient, best_feat_indices_metric2);

% 6th: for each patient, the first feature gives the lowest ml error,
% the second feature gives the lowest map error
best_feat_indices_ml_map = zeros(9,2);

for i = 1:9
    min_ml_idx = 0;
    min_ml_err = 1;
    min_map_idx = 0;
    min_map_err = 1;
    for j = 1:7
        if (Error_table_array{i,j}(1,3)<min_ml_err)
            min_ml_err = Error_table_array{i,j}(1,3);
            min_ml_idx = j;
        end
        if (Error_table_array{i,j}(2,3)<min_map_err)
            min_map_err = Error_table_array{i,j}(2,3);
            min_map_idx = j;
        end
    end
    best_feat_indices_ml_map(i,1) = min_ml_idx;
    best_feat_indices_ml_map(i,2) = min_map_idx;
end
[joint_error_table_array_try_array{1,6}, ml_error_array{1,6}, map_error_array{1,6}, avg_error_array{1,6}] = calc_error_two_features_train(patient, best_feat_indices_ml_map);

% 7th: for each patient, try all pairs of features, select the pair that
% gives the lowest average error
% deleted since it's not a good approach because it uses test data

% 8th: for each patient, select the pair that gives the best ROC curve
best_feat_roc = [1,3; 1,3; 4,2; 3,1; 1,2; 1,3; 5,3; 1,3; 1,3];
[joint_error_table_array_try_array{1,8}, ml_error_array{1,8}, map_error_array{1,8}, avg_error_array{1,8}] = calc_error_two_features_train(patient, best_feat_roc);

% 9th: for each patient, select the least correlated pair out of three
% features that give the lowest error
[joint_error_table_array_try_array{1,9}, ml_error_array{1,9}, map_error_array{1,9}, avg_error_array{1,9}] = calc_error_two_features_train(patient, best_feat_err_corr_three);

% 10th: for each patient, select the least correlated pair out of four
% features that give the lowest error
[joint_error_table_array_try_array{1,10}, ml_error_array{1,10}, map_error_array{1,10}, avg_error_array{1,10}] = calc_error_two_features_train(patient, best_feat_err_corr_four);

% 11th: for each patient, select the least correlated pair out of five
% features that give the lowest error
[joint_error_table_array_try_array{1,11}, ml_error_array{1,11}, map_error_array{1,11}, avg_error_array{1,11}] = calc_error_two_features_train(patient, best_feat_err_corr_five);

% 12th: for each patient, select the least correlated pair out of six
% features that give the lowest error
[joint_error_table_array_try_array{1,12}, ml_error_array{1,12}, map_error_array{1,12}, avg_error_array{1,12}] = calc_error_two_features_train(patient, best_feat_err_corr_six);

% selected: best_feat_err_corr_four
fprintf(fid, 'TASK 3.3B\n\n');
fprintf(fid, 'For each of patients 4, 5, and 7, we tried different pairs of features and compared their performances.\n');
fprintf(fid, 'Based on their performances, we decided to use the following rule to select the pair of features for each patient:\n\n');
fprintf(fid, 'For each patient, we first select four features with the lowest errors and the highest correlation between \n');
fprintf(fid, 'their predictions and the golden labels. This is simply running metric 1 and 2, with a voter system.\n');
fprintf(fid, 'Then, out of the four features, we select two of them, which have the lowest correlation.\n\n');
fprintf(fid, 'Hence, we have selected the best pair of features for each patient, and our results are stored in \n');
fprintf(fid, 'best_feat_err_corr_four, which is a 9*2 array. The best pair of features for patient i is stored in the i-th row of the array.\n\n');
fprintf(fid, 'The selection is copied below: \n\n');

for i = 1:9
    fprintf(fid, 'Patient %d: %d %d\n', i, best_feat_err_corr_four(i,1), best_feat_err_corr_four(i,2));
end

fprintf(fid, '\n');

%% TASK 3.4

for i = [4,5,7]
    test_data_size = size(patient(i).test_data,2);
    scores_test = zeros(1,test_data_size);
    f1 = best_feat_err_corr_four(i,1); % selected pair of features
    f2 = best_feat_err_corr_four(i,2); % selected pair of features
    jht = patient(i).Joint_HT_table; % create a temporary copy of the patients joint distribution table
    
    for j = 1:test_data_size
        % find rows in Joint_HT_table corresponding to feature idx f1
        idx1_arr = find(jht(:,1)==patient(i).test_data(f1,j));
        
        if size(idx1_arr,1)==0
            scores_test(1,j) = 1;
        else
            % take the subset of Joint_HT_table corresponding to feature idx f1
            jht_f1 = jht(idx1_arr,:);
            
            % find rows in the subset of Joint_HT_table corresponding to
            % feature idx f2
            idx2_arr = find(jht_f1(:,2)==patient(i).test_data(f2,j));
            if size(idx2_arr,1) == 0
                scores_test(1,j) = 1;
            else
                % fill in the ml and map decision vectors
                scores_test(1,j) = jht_f1(idx2_arr(1,1),3);
            end
        end
    end
    
    % plot performance curve
    [X,Y] = perfcurve(patient(i).test_labels,scores_test,1);
    figure(i+27);
    plot(X,Y);
    xlabel('False positive rate')
    ylabel('True positive rate')
    title_str = strcat('ROC Curve for Patient',num2str(i));
    title(title_str);
end

fprintf(fid, 'TASK 3.4\n\n');
fprintf(fid, 'We plotted the ROC curves for patients 4, 5, and 7. Please see the generated graphs.\n');
fprintf(fid, 'The perfcurve function tries different thresholds and makes predictions for the alarms.\n');
fprintf(fid, 'Therefore, an ROC curve is good if it is close to the top, i.e. it goes up fast to the top edge,\n');
fprintf(fid, 'because it means high true positive rate and low false positive rate.\n\n');

%% Slides

fprintf(fid, 'Bonus Task:\n\n');
fprintf(fid, 'We present our performance here:\n\n');
fprintf(fid, 'In the following, row i contains the ML error and the MAP error for patient i,\n');
fprintf(fid, 'based on our selection of two features for patient i:\n\n');


for i = 1:9
    [joint_error_table_array_final, ml_error, map_error, avg_error] = calc_error_two_features_one_patient(patient(i), best_feat_err_corr_four(i,1),best_feat_err_corr_four(i,2));
    disp_str = strcat('Patient ', num2str(i), ': ML: ', num2str(ml_error), ' MAP: ', num2str(map_error));
    disp(disp_str);
    fprintf(fid, '%s\n', disp_str);
end

%% Powerpoint Questions 

fprintf(fid, '\nAnswering Questions From PowerPoint Slides:\n\n');
fprintf(fid, 'Our 3 selected patients are patients 4, 5, and 7. The average probability of error for each are:\n\n');
fprintf(fid, 'Patient4: ML:0.077689 \t MAP:0.017928\n');
fprintf(fid, 'Patient5: ML:0.020223 \t MAP:0.013947\n');
fprintf(fid, 'Patient7: ML:0.096301 \t MAP:0.020237\n\n');

fprintf(fid, 'Compare the results generated by the ML and MAP decision rules based on:\n\n');

fprintf(fid, '- Different features -\n\n');
fprintf(fid, 'See section 1.2B where we construct the Error_table_array. In this 9*7 cell array, you will notice that for each patient and each feature, the\n');
fprintf(fid, 'MAP decision rule will generate a lower probability of error than the probability of error generated by the ML decision rule.\n\n');

fprintf(fid, '- Different selected pairs of features -\n\n');
fprintf(fid, 'See section 3.2B where we construct the joint_error_table_array. In this 1*9 array, you will notice that on average, the probabilty of error\n');
fprintf(fid, 'for the MAP decision rule here is less than the probability of error for MAP decision rule calculated in task 1.2B, which is on a\n');
fprintf(fid, 'per patient per feature basis. Furthermore, when speaking in terms of just the joint distribution, the probability of error for the MAP decision rule\n');
fprintf(fid, 'is lower than the probability of error for the ML decision rule, as was noted when doing this check for single features in task 1.2B.\n\n');

fprintf(fid, '- Different criteria for choosing the pairs -\n\n');
fprintf(fid, 'We tried 11 methods for choosing the best pair of features in TASK 3.3B, and compared their performances.  \n');
fprintf(fid, 'Based on their performances, we decided to use the following rule to select the pair of features for each patient:\n\n');
fprintf(fid, 'For each patient, we first select four features with the lowest errors and the highest correlation between \n');
fprintf(fid, 'their predictions and the golden labels. This is simply running metric 1 and 2, with a voter system.\n');
fprintf(fid, 'Then, out of the four features, we select two of them which have the lowest correlation.\n\n');
fprintf(fid, 'Hence, we have selected the best pair of features for each patient. \n');
fprintf(fid, 'In general, we found that methods that consider all of metrics 1, 2, and 3 perform better than methods that only\n');
fprintf(fid, 'consider one or two metrics.\n\n');

fprintf(fid, '- Different error metrics (false alarms, miss detection, and error) -\n\n');
fprintf(fid, 'We found that MAP always results in lower rates of false alarms and error than ML does.\n');
fprintf(fid, 'However, MAP sometimes gives higher rates of missed detection than ML does. We believe this is because\n');
fprintf(fid, 'most of the data have no alarms, which means almost always predicting zeros can result in quite low probability of error\n');
fprintf(fid, 'despite missing most of the alarms. Therefore, probability of error by itself is not a comprehensive measure of performance.\n');
fprintf(fid, 'Other measures of performance should be considered as well. For example, by looking at the ROC curves, we observed that\n');
fprintf(fid, 'always predicting zeros is close to a random guess, with similar true positive rates and false positive rates. Hence ROC curves\n');
fprintf(fid, 'can help us realize that always predicting zeros is a bad decision rule, whereas p(error) by itself cannot.\n');
fprintf(fid, 'Therefore, different error metrics can provide different information when comparing the decision rules.\n\n');

