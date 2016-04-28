Combining multi-modality brain data for disease diagnosis commonly leads to improved performance. A challenge in using 
multimodality data is that the data are commonly incomplete; namely, some modality might be missing for some subjects. 
This tool is used for completing and integrating multi-modality neuroimaging data. This tool is intended to be used internally 
by the DIVE group. However, anyone is welcomed to use this code without notifying us after citing the following paper:

@incollection{li2014deep,
  title={Deep learning based imaging data completion for improved brain disease diagnosis},
  author={Li, Rongjian and Zhang, Wenlu and Suk, Heung-Il and Wang, Li and Li, Jiang and Shen, Dinggang and Ji, Shuiwang},
  booktitle={Medical Image Computing and Computer-Assisted Intervention--MICCAI 2014},
  pages={305--312},
  year={2014},
  publisher={Springer}
}



--------------------------------------------------------------
--- Deep CNN interface based on 'Cnpkg' for AD classification  ---
--------------------------------------------------------------

List of files
=============
1. main.m
2. Step0_Untar_images.m
3. Step1_Image_to_Tensor.m
4. Step2_Tensor_to_BigMatrix_MRI.m
5. Step2_Tensor_to_BigMatrix_PET.m
6. Step3_Cut_Margin.m
7. Step3_Produce_InputData_for_Testing.m
8. Step4_Cnpkg_Trainmodels.m
9. Step5_Produce_Prediction.m
10. Step6_Evaluation_via_MultipleTrails.m
11. SVM_computing_new.m
12. ScaleRowData.m
13. README.txt


Prerequisite software installation 
==================================
The following software/package MUST be installed in advance, otherwise the code couldn't run successfully.

1. CNPKG

    The corresponding link: 
    
    http://cbcl.mit.edu/jmutch/cns/cnpkg/doc/

2. Liblinear

    The corresponding link: 
    
    http://www.csie.ntu.edu.tw/~cjlin/liblinear/
    
Usage
=====
 
The whole procedure is divided into 6 steps in general.  
Step0 is for unzipping the original images saved in '.rar' files.
Step1 is for reading the unzipped images, transforming them into tensors and saved them in '.mat' files.
Step2 is for loading the saved '.mat' files and integrating  the images information into a big feature matrix.
Stpe3 is for cutting the zero-value margins of images to save the computational cost.
Step4 is for training the 3-D CNN model using 'Cnpkg'. The input of the model is the MRI image modality, and the output for updating the model weights is the existing PET modality. 
Step5 is for estimating the incomplete PET modality of subjects whose MRI modality is available only.  
Step6 is for evaluating the prediction performance using 'Liblinear' by multiple trails. 
 
These steps are executed in order with the code in 'main.m'.

Examples
========

1. Modify the file 'main.m', which is to give the paths for loading and saving.
2. Run 'main.m'.






