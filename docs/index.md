# Welcome to SCADR Docs

## Get Started

- [Installation](installation.md)
- [Modules](modules.md)

## Example Output
- [Examples](examples.md)

# Overview

SCADR is a MATLAB-based tool designed to analyze single-cell phosphoprotein data derived from standard flow cytometry experiments, typically formatted as CSV files. Since transfection often results in variable expression levels across individual cells, SCADR takes advantage of this heterogeneity by tracking how changes in protein abundance (e.g., from a transfected gene) affect the levels of downstream phosphoproteins. By linking the expression of specific genes to signaling outputs, SCADR generates dose-response curves that reflect how the functional activity of a gene variant behaves across a range of expression levels. This enables a more nuanced and dynamic understanding of how protein variants impact intracellular signaling pathways in real time, at the single-cell level.

SCADR includes standard regression models such as rLOESS to reveal subtle functional differences among gene variants. It also provides traditional analytical metrics like median fluorescence intensity (MFI), as well as single-cell–based correlation analysis to uncover relationships between phosphoproteins. The tool offers built-in filtering options and supports multiple dimensionality reduction techniques—including PCA, t-SNE, and UMAP—along with biexponential transformations for visual clarity. These features allow users to identify signaling cross-talk, uncover variant-specific profiles, and explore complex cellular phenotypes through correlation heatmaps and clustering.
