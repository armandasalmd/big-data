## Big data project description

#### Table of contents

-   Installation guide
    -   prerequisites
    -   running the code
-   Folder/File structure description
-   Simple idea & project description
-   Output samples

---

#### Installation guide

**_Prerequisites_**

1. Matlab IDE
2. Install addon - Parallel Computing Toolbox
3. Install addon - Mapping Toolbox
4. Install Git on your machine

**_Setting up the files_**

We are going to use CBE data files and individual model (.nc)

-   `git clone https://github.coventry.ac.uk/barkausa/big-data.git`
-   `/data/cbe/` -> `24HR_CBE_01.csv` - `24HR_CBE_25.csv`
-   `/data/` -> `model1.nc` - `model7.nc`

** make sure to rename the individual models are specified above! (modelX.nc)**

**_Running the code_**

Type in command window

```matlab
run('./dist/index.m')
```

That's it B-)

---

#### Folder/File structure description

-   `/data` - holds big data files that were given
-   `/data/cbe` - hold cbe big data files that were given
-   `/dist` - distribution/production source code
-   `/images` - any project related images
-   `/specs` - directory with all specification versions
-   `/src` - place where development code goes
-   `flowchart.drawio` - flowchart file
-   `log_book.xlsx` - excel log book to manage the project

---

#### Simple idea & project description

![flowchart](/images/flowchart.png)

**_Any room for improvement?_**

Instead of loading pre-proccesed CBE, I could implement parallel based algorithm to generate one for me (this problem is challenging!)

---

#### Output samples

map images
