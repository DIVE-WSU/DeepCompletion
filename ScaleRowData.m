function  tr_matrix  = ScaleRowData(tr_matrix)

 
%     idx_zero_elem = find(tr_matrix == 0);
%     tr_matrix(idx_zero_elem) = 1;
%     tr_matrix = log(tr_matrix);
%  

max_value = 1;
min_value = 0;

max_feat = max(tr_matrix);
min_feat = min(tr_matrix);

diff = max_feat - min_feat;
index_zero = find(diff == 0);

for i = 1:size(tr_matrix,2)
    tr_matrix(:,i) = ((tr_matrix(:,i)-min_feat(i))/(max_feat(i)-min_feat(i)))*(max_value-min_value)+min_value;
%     te_matrix(:,i) = ((te_matrix(:,i)-min_feat(i))/(max_feat(i)-min_feat(i)))*(max_value-min_value)+min_value;
    
end

for i = 1: length(index_zero)
    tr_matrix(:, index_zero(i)) = zeros( size(tr_matrix,1), 1);
end

