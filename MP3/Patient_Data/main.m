%% Start

clc
close all;
clear all;

% open the result file
% !! replace # with your own groupID
fid = fopen('ECE313_Final_group20_(winning_group)', 'w');


% TASK 0

%LOAD PATIENT DATA

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
end

%% %% LOAD PATIENT DATA 1
% load('1_a41178.mat');
% patient_1 = all_data;
% pat_flr1 = floor(all_data);
% %pat_tab1 = tabulate(pat_flr1);
% label_1 = all_labels;
% length_1 = length(pat_flr1);
% 
% train_pat_1 = pat_flr1(:, 1:floor(((2/3)*length_1)));
% train_lab_1 = label_1(:, 1:floor(((2/3)*length_1)));
% 
% test_pat_1 = pat_flr1(:, (floor(((2/3)*length_1)+1):length_1));
% test_lab_1 = label_1(:, 1:floor(((2/3)*length_1)));
% 
% % LOAD PATIENT DATA 2
% load('2_a42126.mat');
% patient_2 = all_data;
% pat_flr2 = floor(all_data);
% %pat_tab2 = tabulate(pat_flr2);
% label_2 = all_labels;
% length_2 = length(pat_flr2);
% 
% train_pat_2 = pat_flr2(:, 1:floor(((2/3)*length_2)));
% train_lab_2 = label_2(:, 1:floor(((2/3)*length_2)));
% 
% test_pat_2 = pat_flr2(:, (floor(((2/3)*length_2)+1):length_2));
% test_lab_2 = label_2(:, 1:floor(((2/3)*length_2)));
% 
% % LOAD PATIENT DATA 3
% load('3_a40076.mat');
% patient_3 = all_data;
% pat_flr3 = floor(all_data);
% %pat_tab3 = tabulate(pat_flr3);
% label_3 = all_labels;
% length_3 = length(pat_flr3);
% 
% train_pat_3 = pat_flr3(:, 1:floor(((2/3)*length_3)));
% train_lab_3 = label_3(:, 1:floor(((2/3)*length_3)));
% 
% test_pat_3 = pat_flr3(:, (floor(((2/3)*length_3)+1):length_3));
% test_lab_3 = label_3(:, 1:floor(((2/3)*length_3)));
% 
% % LOAD PATIENT DATA 4
% load('4_a40050.mat');
% patient_4 = all_data;
% pat_flr4 = floor(all_data);
% %pat_tab4 = tabulate(pat_flr4);
% label_4 = all_labels;
% length_4 = length(pat_flr4);
% 
% train_pat_4 = pat_flr4(:, 1:floor(((2/3)*length_4)));
% train_lab_4 = label_4(:, 1:floor(((2/3)*length_4)));
% 
% test_pat_4 = pat_flr4(:, (floor(((2/3)*length_4)+1):length_4));
% test_lab_4 = label_4(:, 1:floor(((2/3)*length_4)));
% 
% % LOAD PATIENT DATA 5
% load('5_a41287.mat');
% patient_5 = all_data;
% pat_flr5 = floor(all_data);
% %pat_tab5 = tabulate(pat_flr5);
% label_5 = all_labels;
% length_5 = length(pat_flr5);
% 
% train_pat_5 = pat_flr5(:, 1:floor(((2/3)*length_5)));
% train_lab_5 = label_5(:, 1:floor(((2/3)*length_5)));
% 
% test_pat_5 = pat_flr5(:, (floor(((2/3)*length_5)+1):length_5));
% test_lab_5 = label_5(:, 1:floor(((2/3)*length_5)));
% 
% % LOAD PATIENT DATA 6
% load('6_a41846.mat');
% patient_6 = all_data;
% pat_flr6 = floor(all_data);
% %pat_tab6 = tabulate(pat_flr6);
% label_6 = all_labels;
% length_6 = length(pat_flr6);
% 
% train_pat_6 = pat_flr6(:, 1:floor(((2/3)*length_6)));
% train_lab_6 = label_6(:, 1:floor(((2/3)*length_6)));
% 
% test_pat_6 = pat_flr6(:, (floor(((2/3)*length_6)+1):length_6));
% test_lab_6 = label_6(:, 1:floor(((2/3)*length_6)));
% 
% % LOAD PATIENT DATA 7
% load('7_a41846.mat');
% patient_7 = all_data;
% pat_flr7 = floor(all_data);
% %pat_tab7 = tabulate(pat_flr7);
% label_7 = all_labels;
% length_7 = length(pat_flr7);
% 
% train_pat_7 = pat_flr7(:, 1:floor(((2/3)*length_7)));
% train_lab_7 = label_7(:, 1:floor(((2/3)*length_7)));
% 
% test_pat_7 = pat_flr7(:, (floor(((2/3)*length_7)+1):length_7));
% test_lab_7 = label_7(:, 1:floor(((2/3)*length_7)));
% 
% % LOAD PATIENT DATA 8
% load('8_a42008.mat');
% patient_8 = all_data;
% pat_flr8 = floor(all_data);
% %pat_tab8 = tabulate(pat_flr8);
% label_8 = all_labels;
% length_8 = length(pat_flr8);
% 
% train_pat_8 = pat_flr8(:, 1:floor(((2/3)*length_8)));
% train_lab_8 = label_8(:, 1:floor(((2/3)*length_8)));
% 
% test_pat_8 = pat_flr8(:, (floor(((2/3)*length_8)+1):length_8));
% test_lab_8 = label_8(:, 1:floor(((2/3)*length_8)));
% 
% % LOAD PATIENT DATA 9
% load('9_a41846.mat');
% patient_9 = all_data;
% pat_flr9 = floor(all_data);
% %pat_tab9 = tabulate(pat_flr9);
% label_9 = all_labels;
% length_9 = length(pat_flr9);
% 
% train_pat_9 = pat_flr9(:, 1:floor(((2/3)*length_9)));
% train_lab_9 = label_9(:, 1:floor(((2/3)*length_9)));
% 
% test_pat_9 = pat_flr9(:, (floor(((2/3)*length_9)+1):length_9));
% test_lab_9 = label_9(:, 1:floor(((2/3)*length_9)));


%% TASK 1.1A
% % Patient 1
% p1_h1 = sum(train_lab_1)/length_1;
% p1_h0 = 1 - p1_h1;
% 
% % Patient 2
% p2_h1 = sum(train_lab_2)/length_2;
% p2_h0 = 1 - p2_h1;
% 
% % Patient 3
% p3_h1 = sum(train_lab_3)/length_3;
% p3_h0 = 1 - p3_h1;
% 
% % Patient 4
% p4_h1 = sum(train_lab_4)/length_4;
% p4_h0 = 1 - p4_h1;
% 
% % Patient 5
% p5_h1 = sum(train_lab_5)/length_5;
% p5_h0 = 1 - p5_h1;
% 
% % Patient 6
% p6_h1 = sum(train_lab_6)/length_6;
% p6_h0 = 1 - p6_h1;
% 
% % Patient 7
% p7_h1 = sum(train_lab_7)/length_7;
% p7_h0 = 1 - p7_h1;
% 
% % Patient 8
% p8_h1 = sum(train_lab_8)/length_8;
% p8_h0 = 1 - p8_h1;
% 
% % Patient 9
% p9_h1 = sum(train_lab_9)/length_9;
% p9_h0 = 1 - p9_h1;

for i = 1:9
    patient(i).h1 = sum(patient(i).train_data)/length(patient(i).train_data);
    patient(i).h0 = 1 - patient(i).h1;
end

%% TASK 1.1B

for i = 1:9
    patient(i).mats = cell(1,7)
    for j = 1:7
        patient(i).mats{1,j} = likelihood_matrix(patient(i).train_data(j,:), patient(i).train_labels);
    end
end
