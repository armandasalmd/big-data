## Installation guide

#### Table of contents

-   Prerequisites
-	Downloading big data files
-   Running the code


**_Prerequisites_**

1. Matlab IDE R2019b
2. Install addon - Parallel Computing Toolbox
3. Install addon - Mapping Toolbox
4. Install Git on your machine

**_Downloading big data files_**

-	Download source code
	-	`git clone https://github.coventry.ac.uk/barkausa/big-data.git`
	-	Or extract the `ZIP/RAR` file

-	create `/data` directory
-	create `/data/cbe` directory
-	create `/data/org` directory

> We are going to use MODEL COMBINED and Cluster Based Ensemble data

[Download link for MODEL COMBINED](https://cumoodle.coventry.ac.uk/mod/resource/view.php?id=2495570)

[Download link for CBE data](https://cumoodle.coventry.ac.uk/mod/resource/view.php?id=2495978)

Download it and ensure you place it in root/data/ folder like this:

-	/data
	-	/cbe
		-	24HR_CBE_01.csv
		-	...
		-	24HR_CBE_25.csv
	-	/org
		-	24HR_Orig_01.csv
		-	...
		-	24HR_Orig_25.csv
	-	models-combined.nc



**_Running the code_**

-	Open Matlab in ./big-data/dist/ folder
-	Type: `program` in Matlab console to START the program

And explore the program. That's it :)
