function Step3_Cut_Margin (dir_input, dir_output)
 
load([dir_input, '/dmatrix_whole_MRI.mat']);

[n1, ppp] = size(dmatrix);

if ppp ~= prod([64,64,64])
    error('The size of image should be [64, 64, 64]!');
    return;
end
 
data = reshape(dmatrix,[n1, 64, 64,64]);
 
  

ind_i = [];

for i = 1:64
    i
    c = [];

    for j = 1:n1
        b = shiftdim(data(j,i,:,:),2);
        c(j) = norm(b);
    end
    d = norm(c);
    if d>0
        ind_i = [ind_i;i];
    end
end

ind_j = [];
for i = 1:64
    i
    c = [];
  
    for j = 1:n1
        b = shiftdim(data(j,:,i,:));
        b = shiftdim(b,2);
        c(j) = norm(b);
    end
    d = norm(c);
    if d>0
        ind_j = [ind_j;i];
    end
end


ind_k = [];
for i = 1:64
    i
    c = [];
    
    for j = 1:n1
        b = shiftdim(data(j,:,:,i),1);
        c(j) = norm(b);
    end
    d = norm(c);
    if d>0
        ind_k = [ind_k;i];
    end
end

data = data(:,ind_i,ind_j,ind_k);
save([dir_output, '/MRI_4D_train_cutmargin.mat'], 'data', 'label');
save([dir_output, '/index_cutmargin.mat'], 'ind_i', 'ind_j', 'ind_k' );

clear data label;
load([dir_input,'/dmatrix_whole_PET.mat']);
[n1, ppp] = size(dmatrix);
if ppp ~= prod([64,64,64])
     error('The size of image should be [64, 64, 64]!');
     return;
end
data = reshape(dmatrix,[n1, 64, 64,64]);
data = data(:,ind_i,ind_j,ind_k);
save([dir_output,'/PET_4D_train_cutmargin.mat'], 'data', 'label');

