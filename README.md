# TCoMX - version v1.0

## Introduction
The TCoMX is a Matlab®(The MathWorks,Inc, Natwick, MA, USA) library which has been developed at the Medical Physics Department of the Veneto Instute of Oncology (IOV-IRCCS). The purpose is to provide a common tool for the extraction of complexity metrics from TomoTherapy® plans. All the metrics found in literature are included. Furthermore, an intensive work has been performed to extend the definition of the existing metrics as well as to develop new ones. 
In the version v1.0 the library allows to extract up to 33 different metrics. Additionaly, 
some of them are provided with one or more parameters that can be arbitrary and easily tuned by the user before the execution.
The library is compatible with the latest versions of the two Therapy Planning System that can currently be used for ThomoTherapy® planning: Precision v .... and RayStation v ...
The library can be used both on Windows and Linux Ubuntu operative systems.

## Prerequisites
-> Matlab® R2018a or later (the library might be compatible with previous versions, but the retro-compatibility was tested up to version R2018a)

-> Windows or Linux Ubuntu (the library was tested on Windows10 and Ubuntu 20.04 LTS).

-> Precision v ... or RayStation v ... (compatiblity with older version might be guaranteed but needs to be checked)

## Installation
Please go through the following steps to get TCoMX installed on your computer:

	1. Download and extract TCoMX
	
	2. Move to TCoMX/database/input
	
	3. Open the PATH_TO_TCoMX_FOLDER.in file
	
	4. Add the full path of the TCoMX folder on you computer as YOUR_PATH/TCoMX
	
	3. Open Matlab
	
	4. Add the TCoMX directory and subdirectories to your Matlab path


Everything should be ready for the execution.

## Execution
	1. PREPARATION OF THE DATASET:

	  1.1. Create a new folder on your computer and put there all the plans that you want to extract the metrics from

	  IN ~/TCoMX/database/utils/reference_dataset THERE ARE 9 ANONYMIZED RT PLANS THAT YOU CAN USE TO TEST THE CODE
	
	  2.1. Create a new empty folder on your pc to store the results of the execution
	
	
	2. SELECTION OF THE INPUT AND OUTPUT FOLDERS:

	  2.1. Move to TCoMX/database/input;
	
	  2.2. Open CONFIG.in:
	  
	    2.2.1. (Optional) Give a name to the execution by typing it below # Analysis ID name;
	
	    2.2.2. Add the full path of the input folder created during the "PREPARATION OF THE DATASET"
	
     	    2.2.3. ADD the full path of the results folder created during the "PREPARATION OF THE DATASET"
		
	3. SELECTION OF THE METRICS TO COMPUTE
	
	  3.1 Move to TCoMX/database/input;
	  
	  3.2 Open METRICS.in: all the metrics are organized in categories and sub-categories. You can do the following things:
	  
	      a) Leave everything as it is and compute all the metrics;
	      
	      b) Remove some metric
	      
	      c) Remove a whole subcategory
	      
	      d) Remove a whole category
	      
	      BE VERY CAREFULL TO AVOID THE FOLLOWING:
	      
	      !A) Remove a category without removing the corresponding subcategories
	      
	      !B) Remove a subcategory without removing the corresponding metrics
	      
	  3.3 The metrics with a "->" have one or more parameters which can be tuned. For a complete list of the metrics and the corresponding parameters we refer to the "TomoTherapy® Complexity Metrics Reference Guide". 
	  
 	      BE VERY CAREFULL:
	 	
	      !A) To use the correct synthax
	 	
	      !B) Not to add the "->" and some parameter to the metrics which do not have parameters to be tuned.
	 	
	   3.4 Type TCoMX on your Matlab console. 
	   
## Reading the results
The results of the execution are stored in a subfolder of the results folder created at step 2.1. The folder is automatically created by TCoMX and its name is unique so that it cannot be overwritten by the following executions. 
The subfolder contains: 

	a. CONFIG.in : a copy of the CONFIG.in file 
	
	b. METRICS.in: a copy of the METRICS.in file
      	
	c. logfile.txt: a summary of the execution
      	
	d. dataset.mat: the results of the extraction process as a .mat file
      	
	e. dataset.xlsx: the results of the extraction process as a .xlsx file
 	


