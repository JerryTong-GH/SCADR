# SCADR (Single Cell Analytics for Dose Response) 

Currently editing in progress

## Overview
The `slap2-utils` library is designed to facilitate the reading of SLAP2 (Scanned Line Angular Projection Microscopy version 2) binary files using Python. This utility aims to support researchers and developers working with data from SLAP2 two-photon microscopes by providing an interface to manipulate and analyze these files directly in Python as an alternative to a Matlab-based workflow. The SLAP2 microscope is a commercially available kit from MBF Bioscience (https://www.mbfbioscience.com/products/slap2). The detailed documentation can be found by clicking the documentation icon above `Overview`.

## Features
- **Reading SLAP2 Binary Files**: Convert SLAP2 proprietary binary data into accessible formats for Python.
- **Metadata Parsing**: Extract and utilize metadata associated with SLAP2 data files.
- **Data Manipulation**: Tools to manipulate and process data points read from the binary file.
- **Trace Extraction**: Tools to extract and generate traces from ROIs imaged in integrated scan mode.
- **Data Inspection**: A GUI to inspect and review data stored in the binary file.

## Installation
Install with pip
```bash
pip install slap2-utils
```


Clone this repository

```bash
git clone https://github.com/Peter-Hogg/SLAP2_Utils.git
```
## Contributing

Contributions are welcome! If you'd like to contribute, please fork the repository and use a new branch for your contributions. Pull requests are welcome. Please report bugs, as we're still refining this library over time.

## License

This project is licensed under the Mozilla Public License Version 2.0 - see the LICENSE.md file for details.

## Credits and Acknowledgements
This library was developed by Peter Hogg and Jerry Tong. It's a rework of several Matlab tools from MBF with added utility functions. Thanks to all contributors who have helped in refining this tool and helped with the project.



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

