function Step6_Evaluation_via_MultipleTrails(dir_input_1, dir_input_2, dir_output, epoch, task_positive, task_negative , dir_cns_intall,  dir_liblinear ) 

addpath(genpath(dir_liblinear));
addpath('/home/rli/Commonly_used_functions');
 
dir_save = strcat(dir_output,'/',num2str(epoch));
if ~exist(dir_save)
    mkdir(dir_save);
end
 
load([dir_input_1, '/PET_4D_train_cutmargin.mat');

% 2 : 'AD';
% 3 : 'Normal Control';
% 4 : 'pMCI';
% 5 : 'sMCI';

[n1,n2,n3,n4] = size(data);
PET_Known = reshape(data,[n1,prod([n2,n3,n4])]);
 

sum_temp = sum(PET_Known);
idx_nonzero = find(sum_temp ~=0);
PET_Known = PET_Known(:, idx_nonzero);
PET_Known  = ScaleRowData(PET_Known);

if length(task_positive) == 1
    index =  find( label == task_positive );
elseif length(task_positive) == 2
    index =  find( label == task_positive(1) |  label == task_positive(2));
end
 
PET_data_positive = PET_Known(index , :);
PET_label_positive =  ones(length(index),1);
clear index;

if length(task_negative) == 1
    index =  find( label == task_negative );
elseif length(task_negative) == 2
    index =  find( label == task_negative(1) |  label == task_negative(2));
end
PET_data_negative = PET_Known(index , :);
PET_label_negative = - ones(length(index),1);
clear index;


clear data label;
load([dir_input_2,'/predict_PET_',num2str(epoch),'.mat']);

PET_CNN = double(data);
PET_CNN = PET_CNN(:, idx_nonzero);
PET_CNN  = ScaleRowData(PET_CNN);

if length(task_positive) == 1
    index =  find( label == task_positive );
elseif length(task_positive) == 2
    index =  find( label == task_positive(1) |  label == task_positive(2));
end
PET_data_predicted_positive = PET_CNN(index , :);
PET_label_predicted_positive =  ones(length(index),1);
clear index;


if length(task_negative) == 1
    index =  find( label == task_negative );
elseif length(task_negative) == 2
    index =  find( label == task_negative(1) |  label == task_negative(2));
end
PET_data_predicted_negative = PET_CNN(index , :);
PET_label_predicted_negative = - ones(length(index),1);
clear index;
 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

X = [ PET_data_positive; ...
      PET_data_negative;...
      PET_data_predicted_positive; ...
      PET_data_predicted_negative];
      
Y = [ PET_label_positive; ...
      PET_label_negative;...
      PET_label_predicted_positive; ...
      PET_label_predicted_negative];      


index_positive  = find(Y == 1);  
data_positive   = X(index_positive, :);
label_positive  = Y(index_positive, :);

index_negative  = find(Y == -1);
data_negative   = X(index_negative, :);
label_negative  = Y(index_negative, :); 

num_postive     = size(index_positive,1);
num_negative    = size(index_negative,1);

a = 2/3;

num_train_postive   = floor(a*num_postive ) 
num_train_negative  = floor(a*num_negative) 

num_experiments = 30; 

auc_mean = [];
 

for i = 1 : num_experiments
    i
    clear  index_train_positve  index_test_positve
    rand('seed', i);
    index_train_positve     = my_randsample(num_postive, num_train_postive); % [ 1 3 5 7 9]
    index_test_positve      = setdiff(1:num_postive, index_train_positve); % [2 4 6 8 10]    
    trainX_positve  = data_positive(index_train_positve, :);
    testX_positve   = data_positive(index_test_positve, :);
    trainY_positve  = label_positive(index_train_positve, :);
    testY_positve   = label_positive(index_test_positve, :);
 
    clear  index_train_negative  index_test_negative
    rand('seed', i+50);
    index_train_negative     = my_randsample(num_negative, num_train_negative); % [ 1 3 5 7 9]
    index_test_negative      = setdiff(1:num_negative, index_train_negative); % [2 4 6 8 10]
    trainX_negative = data_negative(index_train_negative, :);
    testX_negative  = data_negative(index_test_negative, :);
	trainY_negative = label_negative(index_train_negative, :);
    testY_negative  = label_negative(index_test_negative, :);
 
    trainX  = [trainX_positve; trainX_negative];
    trainY  = [trainY_positve; trainY_negative];
	testX   = [testX_positve; testX_negative];
    testY   = [testY_positve; testY_negative];

    data_save = strcat(dir_save,'/task_',num2str(prod(task_positive)),'vs',num2str(prod(task_negative)),...
                    '_trail_', num2str(i),'.mat');
    save(data_save,'trainX','trainY', 'testX', 'testY','index_train_positve',  'index_test_positve',...
                    'index_train_negative', 'index_test_negative');
                    
    [predicted_lable,  auc_value] = SVM_computing_new( trainX, trainY, testX, testY); 
    
    filename = strcat(dir_save,'/task_',num2str(prod(task_positive)),'vs',num2str(prod(task_negative)),...      
                    '_predicted_lable_',num2str(i),'.mat')
    save(filename, 'predicted_lable','auc_value','index_train_positve','index_test_positve','index_train_negative',...                    'index_test_negative');   
    auc_mean = [auc_mean; auc_value];
end

fprintf('The epoch number is :%d \n.',epoch);
task_positive
task_negative
fprintf('The mean auc over %d experiments is: %f \n.', num_experiments, mean(auc_mean)); 
fprintf('The standard deviation over %d experiments is: %f \n.', num_experiments, std(auc_mean));