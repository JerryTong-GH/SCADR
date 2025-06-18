# SCADR (Single Cell Analytics for Dose Response) 

Currently editing in progress

## Overview
The `SCADR` library analyzes dose-dependent single-cell phosphoprotein profiles from flow cytometry data. It is focuses on capturing the phosphoprotein profile of each cell so as to examine the impact of gene expression on signaling pathways at a single cell level. 

## Features
- **Single Cell Resolution**: SCADR analyzes individual cell data rather than population medians, capturing subtle functional differences between variants.
- **Dose-response Analysis**: SCADR links protein expression levels (e.g., from HA-tagged constructs) to downstream signaling outputs using smooth regression methods (e.g., rLOESS).
- **Multiparameter Profiling**: SCADR supports simultaneous assessment of multiple phosphoproteins (e.g., pAKT, pS6, pERK, pCREB, pp38) within each cell.
- **Variant Classification**: SCADR distinguishes the functional impacts of gene variants (e.g., PTEN missense mutations) on canonical and non-canonical signaling pathways.
- **Pairwise Correlation and Heatmaps**: SCADR quantifies co-regulation and signaling cross-talk between phosphoproteins, useful for identifying mechanistic insights and variant clustering.
- **Data Transformation**: SCADR includes commonly used algorithms for data transformation such as PCA, t-SNE, UMAP, and bi-exp scaling, improving visualization and interpretation of variant-specific signaling signatures in flow cytometry data with a wide dynamic range.

## Installation (to be done)
System Requirements and Installation Instructions for SCADR

SCADR requires MATLAB version 2022b or later. While the software may run on older versions, we cannot guarantee full functionality or integrity in those environments.

Before installing SCADR, please ensure that the following MATLAB add-on toolboxes are installed. These can be downloaded for free via the Add-On Explorer within MATLAB:

- Curve Fitting Toolbox (v22.2 or newer)

- Data Acquisition Toolbox (v22.2 or newer)

- Image Processing Toolbox (v22.2 or newer)

- Mapping Toolbox (v22.2 or newer)

- Statistics and Machine Learning Toolbox (v22.2 or newer)

The SCADR installation file is located in the App Installation File directory on the main page. Follow the on-screen prompts to complete the installation process.

By default, SCADR includes the dataset used in the publication:
“Multiplex phosphoflow analysis with a single-cell dosage response platform (SCADR) facilitates deciphering lipid and protein phosphatase–dependent PTEN functions.”
Several figures from this study are available in the Demo section for reference.
## Pull Request and Usage

Pull requests are welcome. Please report bugs, as we're still refining this library over time.

## Extras

The following video playlists provide tutorials on how to use and customize the SCADR app:

Getting Started with SCADR
[Tutorial Playlist – General App Usage](https://www.youtube.com/playlist?list=PLQXaSVKpMlufvOHX_xGMvrYaMX2iwqGzz
)

Editing SCADR Features
[Tutorial Playlist – Customization and Feature Editing](https://www.youtube.com/playlist?list=PLQXaSVKpMlueJDR_1vNk82CpdZR-cUtTx
)

Please note that these playlists are not actively maintained. As SCADR continues to evolve and new functionalities are added, some content may become outdated. However, these videos still serve as a helpful starting point for users new to the platform.

## License

This project is licensed under the Mozilla Public License Version 2.0 - see the LICENSE.md file for details.

## Credits and Acknowledgements
This library was developed and maintained by Mahir Taher and Jerry Tong. Thanks to all contributors in this paper (need to be filled) who have helped in providing suggestions and edits to this project.

Contact details:
Mahir Taher: mahir.taher@hotmail.co.uk (developer)
Jerry Tong: jerry.tong@ubc.ca (developer)
kurt.haas@ubc.ca (PI)

