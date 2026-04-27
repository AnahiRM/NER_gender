# Gendered Citation Patterns in French Legislative Manifestos (1973–1993)

Final project for M2 Machine Learning for NLP, ENSAE

---

## Overview

This project studies whether male and female candidates in French legislative elections cite political figures differently, with a focus on the **gender of cited persons**. Using a corpus of 20,331 manifestos from five elections (1973–1993), I build an NLP pipeline that:

1. Extracts person citations via **CamemBERT-NER**
2. Resolves the gender of cited figures through **Wikidata**
3. Analyses citation patterns by candidate gender and year

**Core finding:** Quantitatively, female candidates cite women in 44% of their known-gender citations, compared to 5% for male candidates (Mann-Whitney U, p < 0.001). This gap persists across all five election years and also reflects qualitative differences: female candidates invoke feminist intellectuals and activists absent from male manifestos.

---

## Repository Structure

```
NER_gender/
│
├── notebooks/
│   ├── 01_data_exploration.ipynb   # Load corpus, descriptive stats, coverage analysis
│   ├── 02_ner_pipeline.ipynb       # CamemBERT-NER extraction + citation cleaning
│   ├── 03_gender_tagging.ipynb     # Wikidata gender lookup for cited persons
│   ├── 04_analysis.ipynb           # Statistical analysis and visualizations
│   └── 05_annotation.ipynb         # Manual NER evaluation (precision/recall)
│
├── data/
│   ├── archelec_metadata_full.csv  # Candidate metadata (gender, party, department)
│   ├── manifestos_with_metadata.csv    # 20,331 manifestos joined with metadata
│   ├── citations.csv                   # 85,827 raw NER citations
│   ├── citations_clean.csv             # 50,416 citations after cleaning
│   ├── gender_lookup.csv               # Wikidata gender for 10,324 unique names
│   ├── citations_with_gender.csv       # Final dataset: citations + gender
│   ├── wikidata_cache.json             # Raw Wikidata API cache
│   └── annotation_sample.csv           # NER evaluation sample
│
├── figures/
│   ├── fig_female_evolution.png        # % female candidates over time (1958–1993)
│   ├── fig_descriptive.png             # Manifesto count and length by gender
│   ├── fig_citation_composition.png    # Overall gender of cited figures + by candidate gender
│   ├── fig_temporal.png                # Female citation share over time
│   ├── fig_temporal_figures.png        # Unique female figures cited over time
│   ├── fig_top_female_pct.png          # Top cited female figures by candidate gender
│
└── setup_data.sh                       # Script to download the Archelec corpus
```

---

## Pipeline

```
archelec_metadata_full.csv
raw .txt manifesto files
        │
        ▼
01_data_exploration.ipynb
        │  manifestos_with_metadata.csv (20,331 manifestos)
        ▼
02_ner_pipeline.ipynb
        │  citations.csv (85,827 raw) → citations_clean.csv (50,416 clean)
        ▼
03_gender_tagging.ipynb
        │  gender_lookup.csv · citations_with_gender.csv
        ▼
04_analysis.ipynb
        │  figures/
        ▼
05_annotation.ipynb
           Precision 0.857 · Recall 0.978 · F1 0.913
```

---

## Data Attrition

```
Raw NER output:          85,827 citations  (38,460 unique names)

── Cleaning ────────────────────────────────────────────────
  Noise removed:         -4,910   (titles, honorifics)
  Single-word removed:  -10,470   (single tokens)
  Truncated names:         -441   (e.g. "Giscard D")
  Rare (< 2 times):     -19,590   (appear only once)
────────────────────────────────────────────────────────────
Clean citations:          50,416  (10,139 unique names)

── Wikidata gender tagging ─────────────────────────────────
  Names queried:          10,324
  Found on Wikidata:       5,146 / 10,324  (49.8%)

  Gender assigned:
    male:                 30,995 citations  (61.5%)
    unknown:              17,073 citations  (33.9%)
    female:                2,337 citations   (4.6%)
────────────────────────────────────────────────────────────
Final coverage:   66.1% of citations have known gender
```

---

## Key Results

| | Female candidates | Male candidates |
|---|---|---|
| N candidates (with known citations) | 1,320 | 12,262 |
| Mean % citations to female figures | **43.99%** | **4.69%** |
| Mann-Whitney U test (p-value) | < 0.001 | |

The gap persists across all five election years. The repertoire of unique female figures cited by female candidates also grew steadily from 40% (1973) to 48% (1988), while the rate for male candidates remained flat at 2–5%.

**Most cited women overall:** Arlette Laguiller, Huguette Bouchardeau, Gisèle Halimi, Simone de Beauvoir, Dominique Voynet.

---

## Setup

### Requirements

```bash
pip install pandas numpy matplotlib seaborn scipy transformers tqdm requests langdetect
```

### Data

The Archelec manifesto texts are not included in this repository. Run the setup script to download them:

```bash
bash setup_data.sh
```

The candidate metadata file (`archelec_metadata_full.csv`) is included in `data/`.

### Running the pipeline

Run notebooks in order:

```
01 → 02 → 03 → 04
```

Notebook `05` can be run independently for NER evaluation.

---

## Limitations

- **Wikidata gender gap:** the 33.9% unknown rate likely skews female, meaning reported citation rates are conservative lower bounds.
- **512-token NER limit:** CamemBERT-NER only processes the first ~350 words of most manifestos. Citations later in the text are missed.
- **No citation context:** we detect that a name is cited but not whether the citation is approving, critical, or adversarial.


