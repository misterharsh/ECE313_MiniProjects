function [feat_idx1, feat_idx2] = select_two_feats_ML_MAP(pat, HT_tables)
    
    % create error tables for each feature
    error_tables = zeros(7,2,3);
    for feat_idx = 1:7
        % HT_tables is a 1*7 cell array
        error_tables(feat_idx,:,:) = create_error_table(pat, feat_idx, HT_tables{1,feat_idx});
    end
    
    % compare different features using error tables
    % the two features with the least min(ML_err, MAP_err) are selected
    ML_errs = zeros(1,7);
    MAP_errs = zeros(1,7);
    for i = 1:7
        error_table = error_tables(i,:,:);
        %size(error_table)
        ML_errs(1,i) = error_table(1,1,3);
        MAP_errs(1,i) = error_table(1,2,3);
    end
    
    Min_errs = zeros(1,7);
    for i = 1:7
        Min_errs(i) = min(ML_errs(i), MAP_errs(i));
    end
    [val, feat_idx1] = min(Min_errs);
    
    Min_errs2 = Min_errs(:);
    Min_errs2(feat_idx1) = inf;
    [val2, feat_idx2] = min(Min_errs2);
end
