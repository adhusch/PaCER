## Welcome to PaCER - Precise and Convenient Electrode Reconstruction for DBS

Please note that PaCER is a research tool **NOT** intended for clinical use.   
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

Copyright (C) 2017  Andreas Husch, 
					Centre Hospitalier de Luxembourg, National Department of Neurosurgery and
				    University of Luxembourg, Luxembourg Centre for Systems Biomedicine
![Image of a PaCER electrode reconstruction at two different time points of resolving brain shift.](PaCER.png)
### Requirements
The requirements to use PaCER are 
 *  a working **MATLAB installation**  
 *  **post-operative CT image** in **nifti** file format. 
 
A CT slice-thickness <= 1 mm is recommend, however PaCER will
work on lower resolution data too by falling back to a less sophisticated contact detection 
method (yielding lower accuracy). Nifti input files are supported in compressed form (.nii.gz) as
well as non-compressed (.nii).

### Getting Started
The easiest way to learn about PaCER is to run the example files. We recommend to add the
PaCER directory and all its subdirectories to your MATLAB path first. This can be 
archived by running the file SETUP_PACER.m in MATLAB (once). The examples include a call
to SETUP_PACER.

#### The Examples
 * **EXAMPLE_1.m** - Basic PaCER call and electrode plot. Start here!
     * **EXAMPLE_1_1.m** - Continues EXAMPLE_1 by adding an **MPR view** of the CT image and demonstrating some **plot customisations**
 * **EXAMPLE_2_1.m** - Continues EXAMPLE_1 by adding a **simplified VTA model** (Mädler/Coenen) (cf. Use-Case C)
 * **EXAMPLE_4.m** - Demonstrates PaCER operating in atlas space. Post OP CT and T1 linearly pre-registered to the template and electrodes plotted together with subcortical atlas segmentations. (cf. Use-Case D)

Note: We can currently not provide public examples using native space imaging data due to missing clearing to publicly share native data. The present examples are based on synthesised data in an atlas space. We would be happy for any data donations of anoymized raw Post OP data with the necessary clearing. However we strongly recommend to use PaCER on native space data and subseuqnetly tranform the resulting electrode objects if needed. Using native space data ensures best signal-to-noise ratio and thus detection accuracy.

### Questions
Feel free to drop a note to [https://github.com/adhusch/](https://github.com/adhusch/)

### Literature
A paper describing the algorithmic details of PaCER as well as reporting detailled accuracy analysis results on phantom and simulated data is currently in revision. It will be linked here after publication.

### Acknowledgement
This work was made possible by a Aide à la Formation Recherche grant (AFR) to Andreas Husch by the Luxembourg National Research (FNR).

PaCER is packaged with some free external software libraries for convenience. Please see the "toolboxes" folder and the respective LICENSE files for details.
We feel grateful to the authors of this toolboxes and scripts:
 * [Tools for NIfTI and ANALYZE image](https://de.mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image) by Jimmy Shen
 * [RGB triple of color name, version 2](https://de.mathworks.com/matlabcentral/fileexchange/24497-rgb-triple-of-color-name--version-2) by Kristjan Jonasson
 * [GUI Layout Toolbox](https://de.mathworks.com/matlabcentral/fileexchange/47982-gui-layout-toolbox) by David Sampson and Ben Tordoff
 * [in_polyhedron](https://de.mathworks.com/matlabcentral/fileexchange/48041-in-polyhedron) by Jaroslaw Tuszynski
 * [Cylinder Between 2 Points](https://de.mathworks.com/matlabcentral/fileexchange/5468-cylinder-between-2-points) by Per Sundqvist
 * MPR View, by Florian Bernard



![Logo LCSB / Uni.lu](unilcsb.png){:height="50px"}          ![Logo LCSB / Uni.lu](fnr.gif){:height="50px"}           ![Logo CHL](CHL.png){:height="50px"} 

