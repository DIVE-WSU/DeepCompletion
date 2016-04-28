function  [predicted_lable_temp, area]  = SVM_computing_new(trainX,trainY,testX,testY)  
trainX = sparse(trainX);
model_linear = train(trainY, trainX, '-c 1 -s 0 -q heart_scale');
test_lable =  testY;

testX = sparse(testX);
[predicted_lable_temp,~,prob_matrix] = predict( test_lable , testX , model_linear, '-q -b 1');
a = predicted_lable_temp(1);
b = prob_matrix(1,:);
if (  abs(a-b(1)) <= abs(a-b(2)))
    predicted_lable_prob = prob_matrix(:,1);
else
	predicted_lable_prob = prob_matrix(:,2);
end
    
[area, std_residual, thresholds, oneMinusSpec, Sensitivity, TN, TP, FN, FP] = ls_roc(predicted_lable_prob, testY,'nofigure');

