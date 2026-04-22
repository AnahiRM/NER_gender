#!/bin/bash
# Run this script once to set up the data folder before running the notebooks.

echo "=== Setting up Archelec data ==="

mkdir -p data

# 1. Clone the manifesto text files
echo "Cloning manifesto texts..."
git clone https://gitlab.teklia.com/ckermorvant/arkindex_archelec.git data/archelec_repo

# 2. Unzip each election year
echo "Unzipping election years..."
BASE="data/archelec_repo/text_files"
for year in 1973 1978 1981 1988 1993; do
    cd "$BASE/$year"
    unzip -q legislatives.zip
    cd - > /dev/null
done

# Copy nested files for years with wrong structure
for year in 1981 1988 1993; do
    rsync -a "$BASE/$year/text_files/$year/legislatives/" "$BASE/$year/legislatives/" 2>/dev/null || true
done

echo ""
echo "=== Manual step required ==="
echo "Download the metadata CSV from: https://archelec.sciencespo.fr/explorer"
echo "Save it as: data/archelec_metadata_full.csv"
echo ""
echo "Setup complete. You can now run the notebooks in order."
