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
	
	4. Add the full path of the TCoMX folder on you computer
	
	3. Open Matlab
	
	4. Add the TCoMX directory and subdirectories to your Matlab path


Everything should be ready for the execution.

## Execution
1. PREPARATION OF THE DATASET:

	1.1 Create a new folder on your computer and put there all the plans that you want to extract the metrics from.
	
	2.1 Create a new empty folder on your pc to store the results of the execution
	
	
2. SELECTION OF THE INPUT AND OUTPUT FOLDERS:

	1.1 Move to TCoMX/database/input;
	
	1.2 Open CONFIG.in
	1.3 
