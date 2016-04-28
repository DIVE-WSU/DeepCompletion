function Step1_Image_to_Tensor(dir_input,  dir_output)


a = dir(dir_input);
for i = 3 : size(a,1);
	name{i-2, 1} = a(i,1).name;
end

for i  =  1 : size(name,1)
 	dir_1 = strcat(dir_input,'/', name(i,1));
	b = dir(char(dir_1));
	for j = 3 : size(b,1);
		name_1{i, j-2 } = b(j,1).name;
	end
end

%dir_output = 'Z:\DingGang\combineMRI_PET_dtensor';

if ~exist(dir_output)
    mkdir(dir_output);
end
 
 for i = 1 : size(name_1,1)
    i
    for j = 1 : size(name_1,2)
        j;
		dir_2 = name_1(i,j);
		temp = dir_2{1,1};
		if (isempty(temp) == 0)
			dir_1 = strcat(dir_input,'/', name(i,1)) ;
            dir_to_save = strcat(dir_output,'/', name(i,1)) ;
            files = dir([char(dir_1),'/',temp ,'/*.hdr']);
			for k = 1: size(files,1)
                k;
                [pathstr, name_2, ext] = fileparts(files(k,1).name);
                aa = [dir_input, '/',name{i, 1},'/',temp ,'/', files(k,1).name]; 
                info = analyze75info(aa);
                dtensor  = analyze75read(info);
                path_to_save = strcat(dir_to_save,'/',temp);
                path_to_save = path_to_save{1,1};
                if ~exist(path_to_save)
                    mkdir(path_to_save);
                end
                path_to_save = strcat(path_to_save,'/', name_2, '.mat') ;
                save(path_to_save, 'dtensor');
                 
			end
		end
	end
end

% info = analyze75info('brainMRI.hdr');
% X = analyze75read(info);
% Z:\DingGang\combineMRI_PET\AD\003_S_1257\003_S_1257-01_RAVENSmap.4D.GM_smooth_downsample.img