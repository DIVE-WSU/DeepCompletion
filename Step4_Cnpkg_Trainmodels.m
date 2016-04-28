function Step4_Cnpkg_Trainmodels(dir_input,  dir_output,  dir_cns_intall, p  ) 

addpath(genpath( dir_cns_intall ));

if (exist(dir_output ) ==0)
	mkdir(dir_output);
end

load([dir_input, '/MRI_4D_train_cutmargin.mat']);

size(data);
MRI_398 = data;
clear data;

load([dir_input, '/PET_4D_train_cutmargin.mat']);
size(data);

for  j = 1 : size(data,1)
	aa = data(j,:,:,:);
	aa = aa  / max(max(max(aa)));
	data(j,:,:,:) = aa;
	clear aa;
end
PET_398 = data;
clear data;
 

miniOutSize = p.miniOutSize;


border = sum(p.fSize(2:end)-1)/2; %%%

if ~exist('nEpoch', 'var'), nEpoch = p.nEpoch ; end
if ~exist('nIter' , 'var'), nIter  = p.nIter; end

% % Create two models, one for training and one for testing.
% % Two cases for initializing the weights.
% %  1 . At the very beginning, use random numbers. 
m1 = cnpkg_buildmodel(p, miniOutSize);
m2 = cnpkg_buildmodel(p, [size(PET_398, 2), size(PET_398, 3), size(PET_398, 4)]);
for i = 2 : numel(p.fCount)
    siz = cell2mat(m2.layers{m2.zw(i)}.size);
    m2.layers{m2.zw(i)}.val = single(0.5 * randn(siz) / sqrt(prod(siz(1 : 4))));
    m2.layers{m2.zb(i)}.val = single(0.5 * randn(siz(5), 1));
end


% % 2.If the code is stopped by accident, use the produced intermediate weights to go on the training.
% load([dir_output,'/model_15_105.mat']); % The position where the code is stopped. 
% m2_last = m2;
% clear m2;
% m1 = cnpkg_buildmodel(p, miniOutSize);
% m2 = cnpkg_buildmodel(p, [size(PET_398, 2), size(PET_398, 3), size(PET_398, 4)]);
% for i = 2 : numel(p.fCount)
	% m2.layers{m2.zw(i)}.val = m2_last.layers{m2_last.zw(i)}.val;
	% m2.layers{m2.zb(i)}.val = m2_last.layers{m2_last.zb(i)}.val;
% end




% Loop over epochs.

eloss = zeros(1, nEpoch);
fprintf('training (%u epochs, %u iterations per epoch):\n', nEpoch, nIter);
clear k label i;
M1 = cell(nEpoch,1);
M2 = cell(nEpoch,1);
for epoch = 1 : nEpoch
    epoch 
    for k = 1 : size(MRI_398,1)
        k 
        for i = 2 : numel(p.fCount)
            m1.layers{m1.zw(i)}.val = m2.layers{m2.zw(i)}.val;
            m1.layers{m1.zb(i)}.val = m2.layers{m2.zb(i)}.val;
        end
        
        [~, o, pppp, q] = size(MRI_398);
        temp1 = zeros(1, o + 2*border,  pppp + 2*border,   q + 2*border);
        temp1(1, border+1:end-border, border+1:end-border, border+1:end-border) = MRI_398(k, :,:,:);
        temp2(1,:,:,:) = PET_398(k, :, :, :);
        

        m1.input =  temp1 ; % Convert to [F*Y*X*D].
        m1.label =  temp2 ; % Convert to [F*Y*X*D].

        m2.input =  temp1 ;
        m2.label =  temp2 ;

        % Randomly select minibatches.
        m1.batch = zeros(nIter, 3);
		m1.batch(:, 1) = randi(size(MRI_398, 2) - miniOutSize(1) + 1, [nIter 1]) - 1;
		m1.batch(:, 2) = randi(size(MRI_398, 3) - miniOutSize(2) + 1, [nIter 1]) - 1;
		m1.batch(:, 3) = randi(size(MRI_398, 4) - miniOutSize(3) + 1, [nIter 1]) - 1;
 		m2.batch = [0 0 0];

        t1 = clock;
        cns('init', m1, 'gpu', 'mean');
        cns('run', nIter);

        % Retrieve weights, transfer them to testing model.

        for i = 2 : numel(p.fCount)
            m1.layers{m1.zw(i)}.val = cns('get', m1.zw(i), 'val');
            m1.layers{m1.zb(i)}.val = cns('get', m1.zb(i), 'val');
            m2.layers{m2.zw(i)}.val = m1.layers{m1.zw(i)}.val;
            m2.layers{m2.zb(i)}.val = m1.layers{m1.zb(i)}.val;
        end

        t1 = etime(clock, t1);
        t2 = clock;

        cns('init', m2, 'gpu', 'mean');
        cns('step', 1, m2.layers{m2.zx(end)}.stepNo(1)); 

        output = cns('get', m2.zx(end), 'val');
		max(max(max(output)))
        size(output)
        size(temp2)
        t2 = etime(clock, t2);
		aa = squeeze(temp2 - output);
        eloss_sample(k) = norm(squeeze(mean(0.5 * aa.^ 2)));
        
        file_name_4 = strcat(dir_output,'/weight_',num2str(epoch),'_',num2str(k),'.mat');
		save(file_name_4,'m1','m2');
        
	end
    
    eloss(epoch) = mean(eloss_sample);
    fprintf('completed epoch #%u of %u (train: %f sec, test: %f sec)\n', epoch, nEpoch, t1, t2);

    M1{epoch} = m1;
    M2{epoch} = m2;
    
	filename = strcat(dir_output,'/model_info_',num2str(epoch),'.mat');
    save(filename,'M1', 'M2');
    
end
cns('done');
