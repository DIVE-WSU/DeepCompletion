function Step3_Produce_InputData_for_Testing(dir_input,  dir_output );

load([dir_input, '/index_cutmargin.mat']);
load([dir_input, '/MRI_4D_test_original.mat']); % This data should be 4D, otherwise use 'reshape' to be of dimension XXX * 64 * 64 * 64. The label information should be provided as well, i.e.

% 2: AD
% 3: Normal Control
% 4: pMCI
% 5: sMCI

data = data(:, ind_i, ind_j, ind_k); 
save([dir_output,'/MRI_4D_test_cutmargin.mat'],'data','label');



