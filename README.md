# TCoMX - version v1.0
TCoMX (Tomotherapy Complexity Metrics EXtractor) is a newly developed
Matlab® (The Mathworks Inc, Natick, MA, USA) library for the automatic extraction of a
wide set of complexity metrics from the DICOM RT-plan files of helical tomotherapy (HT)
treatments. It was developed at the Medical Physics Department of the Veneto Instute of Oncology (IOV-IRCCS). 
The current version of TCoMX (v1.0) allows the extraction of all the different complexity metrics proposed in the literature,some of them with customisable parameters.
TCoMX is compatible with DICOM RT-PLAN files generated using both RayStation
(RaySearch Laboratories, Stockholm, Sweden) and Precision (Accuray, Sunnyvale, CA)
TPSs. It was developed entirely on Matlab® R2020b. The backward compatibility with
previous Matlab® releases was checked up to version R2018a. Compatibility with older
versions should be guaranteed but needs to be verified. The library was developed on Linux
Ubuntu 20.04.1 LTS and the compatibility with Windows 10 was verified. The compatibility
with other versions of the two operating systems as well as with other operating systems
needs to be investigated. A reference dataset composed by 18 anonymized DICOM RT-
PLAN files (9 Precision, 9 RayStation) is also provided in this repository.
We refer to the TCoMX_UserManual it this repository for any detail concerning its functioning. 
