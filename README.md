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
Install with pip
```bash
pip install slap2-utils
```


Clone this repository

```bash
git clone https://github.com/Peter-Hogg/SLAP2_Utils.git
```

## Pull Request and Usage

Pull requests are welcome. Please report bugs, as we're still refining this library over time.

## License

This project is licensed under the Mozilla Public License Version 2.0 - see the LICENSE.md file for details.

## Credits and Acknowledgements
This library was developed and maintained by Mahir Taher and Jerry Tong. Thanks to all contributors in this paper (need to be filled) who have helped in providing suggestions and edits to this project.



This repository contains:
- All scripts, functions, images, sounds, and sub-apps contributing to the main MATLAB SCiYA app under 'App development files' (needs changing)
- All files needed to install the app as a standalone programme within 'App installation files'
- 'Example dataset libraries' to use with the app
- Some draft 'Result figures' generated from the app
- A template well info file, that can be copied and adjusted to your particular dataset

This is a playlist of tutorials on how to use the app:
https://www.youtube.com/playlist?list=PLQXaSVKpMlufvOHX_xGMvrYaMX2iwqGzz

Tutorials on how to edit simple features of the app:
https://www.youtube.com/playlist?list=PLQXaSVKpMlueJDR_1vNk82CpdZR-cUtTx

Contact details:
Mahir Taher: mahir.taher@hotmail.co.uk (developer)
Jerry Tong: jerry.tong@ubc.ca (developer)
kurt.haas@ubc.ca (PI)

