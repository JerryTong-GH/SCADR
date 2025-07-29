The software may still run on earlier versions of MATLAB; however, full functionality and stability cannot be guaranteed if older versions of add-ons/matlab are used. 

All installation tests have been conducted using MATLAB version 2022b or later. Before installing SCADR, please ensure that the following MATLAB add-on toolboxes are installed. These can be downloaded for free via the Add-On Explorer within MATLAB:

- *Image Processing Toolbox* (v22.2 or newer)

- *Mapping Toolbox* (v22.2 or newer)

- *Statistics and Machine Learning Toolbox* (v22.2 or newer)

There are two ways of using/installing SCADR:

## Using SCADR as a Developer
This installation mode is intended for users who wish to modify or extend SCADR’s functionality or user interface. It gives full access to the underlying code, making it ideal for developers looking to adapt SCADR to their specific research or analysis needs.

Steps to Set Up SCADR in Development Mode:

1. Open MATLAB and navigate to the **Development** folder located within the SCADR GitHub repository.
   
2. Select all folders inside the **Development** directory.
   
3. Right-click on the selected folders and choose:
   
4. Add to Path → Selected Folders and Subfolders.
   
5. Locate and double-click the file **SCADR.mlapp**.

Note: If MATLAB does not open the file using App Designer, install the App Designer add-on from the Add-Ons tab.

To modify the code, click **Code View** (top-right of the App Designer window).
To launch the software in UI mode, click the **Run** button located beneath the **Canvas** tab.

## Using SCADR as a General User (Recommended)
This installation method allows you to use SCADR without directly modifying its source code. It is ideal for users who want a stable, ready-to-use version of the software without the risk of unintentionally breaking any functionality. While code editing is not supported in this mode, the installation is more secure and can be easily reinstalled if needed.

Steps:

1. Navigate to the Installation Files directory on the main page of the SCADR repository.
   
2. Double-click on the **SCADR_Installer**.
   
3. Follow the on-screen prompts to complete the installation process.
   
Note: For a successful installation, it is recommended to run the installer as an **administrator**.

## Datasets Included in the Library
By default, SCADR includes the dataset used in the publication:
“Multiplex phosphoflow analysis with a single-cell dosage response platform (SCADR) facilitates deciphering lipid and protein phosphatase–dependent PTEN functions.”

Several figures from this study are available in the Demo section as reference examples.
