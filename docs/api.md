# API Reference

## class Analyzer

```python
class Analyzer:
    def __init__(self, filepath: str):
        """Load and initialize data from a CSV file."""

    def preprocess(self):
        """Cleans and normalizes the dataset."""

    def run_umap(self, markers=None):
        """Runs UMAP dimensionality reduction on the selected markers."""

    def plot(self):
        """Displays a 2D plot of the UMAP embedding."""
