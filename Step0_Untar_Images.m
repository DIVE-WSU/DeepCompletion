function Step0_Untar_images(dir_input)
 

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


 
for i = 1 : size(name_1,1)
    for j = 1 : size(name_1,2)
	
        j
		dir_2 = name_1(i,j);
		temp = dir_2{1,1};
		if (isempty(temp) == 0)
			dir_1 = strcat(dir_input,'/', name(i,1));
			files = dir([char(dir_1),'/',temp ,'/*.gz']);
			for k = 1: size(files,1)
				[pathstr, name_2, ext] = fileparts(files(k,1).name);
                aa = [dir_input, '/',name{i, 1},'/',temp ,'/', files(k,1).name] ;
                bb = [dir_input, '/',name{i, 1},'/',temp ] ;
 				gunzip(aa,bb);
			end
		end
	end
end

