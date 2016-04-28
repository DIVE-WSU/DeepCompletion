function  Step2_Tensor_to_BigMatrix_PET(dir_input, dir_output)


class_name = {'AD', 'NORMAL', 'pMCI', 'sMCI'};

dmatrix = [];
label = [];
for i = 1 : length(class_name)
i
    data_path = char(strcat(dir_input, '/',class_name(i))); 
    files = dir([data_path,'/*']);
    length(files) - 2;
    
    for j = 3 : length(files)
        j;
        [~, name_folder, ~] = fileparts(files(j).name);
 
        
%         file_name_load = strcat(name_folder,'-01_RAVENSmap.4D.GM_smooth_downsample.mat');
        load([data_path,'/',name_folder,'/WarpedPETt1ToMdl_smooth_downsample.mat']);
        temp =  reshape(dtensor, [1 prod(size(dtensor))]);
 
        dmatrix = [dmatrix; temp];
        label = [label;  1+i ];
    end
end

dmatrix = double(dmatrix);

save([dir_output,'/dmatrix_whole_PET.mat'], 'dmatrix', 'label');



 

