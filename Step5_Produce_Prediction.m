function Step5_Produce_Prediction(dir_input_1, dir_input_2, dir_output,  dir_cns_intall, p,  k  )

addpath(genpath( dir_cns_intall ));

load([dir_input_1, '/MRI_4D_test_cutmargin.mat']);

 
miniOutSize = p.miniOutSize;       % Spatial size of output level for training [Y*X*D].
border = sum(p.fSize(2:end)-1)/2; 
m3 = cnpkg_buildmodel(p, [size(data, 2), size(data, 3), size(data, 4)]);
m3.batch =  [0 0 0];


load([dir_input_2,'/model_info_', num2str(k),'.mat']);
m1 = M1{k,1};
for i = 2 : numel(p.fCount)
	m3.layers{m3.zw(i)}.val = m1.layers{m1.zw(i)}.val;
	m3.layers{m3.zb(i)}.val = m1.layers{m1.zb(i)}.val;
end
 


for j = 1 : size(data,1)
    fprintf('Prediction of %d over %d is finished. \n', j, size(data,1));

    [~, o, pppp, q] = size(data);
    temp1 = zeros(1, o + 2*border,  pppp + 2*border,   q + 2*border);
    temp1(1, border+1:end-border, border+1:end-border, border+1:end-border) = data(j, :,:,:);
    
    m3.input = temp1;
  	size(m3.input);
	
    m3.label = m3.input(1, border+1:end-border, border+1:end-border, border+1:end-border);
 	size(m3.label);   

    %cns('init', m3, 'gpu0'); 
    cns('init', m3, 'gpu', 'mean');
    
    cns('step', 1, m3.layers{m3.zx(end)}.stepNo(1)); % Don't need to backpropagate, etc.

    output(j,:,:,:) = cns('get', m3.zx(end), 'val');

end

clear data;

for i = 1 : size(output,1)
    i
    a = shiftdim(output(i,:,:,:)) ;
    b = reshape(a, [1, prod(size(a))]);
    data(i,:) = b;
end
 
save([dir_output,'/predict_PET_', num2str(k),'.mat'], 'data','label'); 
