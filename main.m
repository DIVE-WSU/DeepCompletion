 clc;
 clear all;
  
 dir_original_data = '/home/rli/DG/combineMRI_PET';
 dir_tensor = '/home/rli/DG/combineMRI_PET_dtensor';

 dir_save_train_info = '/home/rli/DG/771';
 dir_data_modality = '/home/rli/DG';
 dir_save_predicted_data = '/home/rli/DG/771_result';
 dir_output_auc = '/home/rli/DG/AUC';
 
 dir_cns_intall = '/home/rli/cns';
 dir_liblinear = '/home/rli/Downloaded_Software/liblinear-1.93';

%% Design the network
p = struct;                  % Network parameters. 
p.fCount = [1 10 10 1];      % We have 1 input layer, 2 hidden layer, and 1 output layer.
p.fSize  = [0 7 7 1];        % Size of filter in Y and X dimension for each layer.
p.fDepth = [0 7 7 1];        % Size of filter in D (depth) dimension for each layer.
p.eta    = [0 1 1 1] * 1e-2;  % Learning rate for weights and biases for each layer.
p.miniOutSize = [3 3 3];      % Spatial size of output layer for training [Y*X*D].
p.nEpoch = 15;               % Number of epochs for training in total.
p.nIter = 50000;             % Number of mini-batches for training for each epoch.

epoch = 10;                 % Number of finished epochs. 

task_positive = [4,5]; % Label for task of interest. Here, we consider MCI vs. NC.
task_negative = 3;
% 2 : 'AD';
% 3 : 'Normal Control' or NC;
% 4 : 'pMCI';
% 5 : 'sMCI';



Step0_Untar_Images(dir_original_data);
Step1_Image_to_Tensor(dir_original_data, dir_tensor);
Step2_Tensor_to_BigMatrix_MRI(dir_tensor, dir_data_modality);
Step2_Tensor_to_BigMatrix_PET(dir_tensor, dir_data_modality);
Step3_Cut_Margin(dir_data_modality, dir_data_modality);
Step3_Produce_InputData_for_Testing(dir_data_modality,  dir_data_modality);
Step4_Cnpkg_Trainmodels(dir_data_modality,  dir_save_train_info,  dir_cns_intall, p );
Step5_Produce_Prediction(dir_data_modality,  dir_save_train_info,  dir_save_predicted_data, dir_cns_intall, p, epoch );
Step6_Evaluation_via_MultipleTrails(dir_data_modality, dir_save_predicted_data, dir_output_auc, epoch, task_positive, task_negative, dir_cns_intall,  dir_liblinear ); 

 