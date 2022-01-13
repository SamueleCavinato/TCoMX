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

## Aim 
TCoMX was realized in order to provide common tool to be used across the different institutions. A strong effort was done to make the library accessible to any type of user, even to non expert programmers. Furthermore, no fees are needed to use it because we believe that science is based on the free sharing of knowledge and tools. For this reason, TCoMX is released under a GNU GPL v3 licence that allow you to use, modify and distribute new versions of the library by following two simple rules (1) give to others the same freedom you had from us (2) state the changes you did (please find all the technical details in the LICENCE file). However, in the same spirit of sharing knowledge, we warmly encourage the authors that are interested in adding new interesting and usefull features to the library, to contact us in order to collaborate.

## How to cite
Please cite the library in your works as: 

Cavinato S, Scaggion A. TCoMX: Tomotherapy Complexity Metrics EXtractor. ArXiv211215056 Phys. Published online December 30, 2021. Accessed January 7, 2022. http://arxiv.org/abs/2112.15056

If you need other citation formats, you can refer to the updated version of the TCoMX User Manual on arxiv: http://arxiv.org/abs/2112.15056

## Results
If you publish some results obtained using TCoMX and you want to gain visibility, do not hesitate to contact us. We are planning to add a secion "Results" to the TCoMX User Manual in order to collect all the relevant findings. 

## Correspondences
If you need help with the installation and/or execution of TCoMX, or if you have any suggestion or thing to share, you can contact us at samuele.cavinato@iov.veneto.it or alessandro.scaggion@iov.veneto.it.

## Footnotes
TCoMX is intended for research use only. The clinical use of TCoMX is strongly forbidden. The authors don't take responsabilities of any improper use of the tools contained in this repository and of all the material related to it. 


