# Movie Recommendation System

A profiling-guided Movie Recommendation system optimized using C. This program leverages clustering (k-means) and Pearson correlation for predicting movie ratings using Collaborative Filtering.

## Build Instructions

### Baseline Build
```bash
gcc -O0 ui.c kmeans.c matrix_normalization.c pearsons.c predictions.c recommender.c sorting.c utility_matrix.c -o recsys_base -lm
```

### Optimized Single-Thread Build
```bash
gcc -O3 -march=native ui.c kmeans.c matrix_normalization.c pearsons.c predictions.c recommender.c sorting.c utility_matrix.c -o recsys_opt_st -lm
```

### Optimized OpenMP Build
```bash
gcc -O3 -march=native -fopenmp ui.c kmeans.c matrix_normalization.c pearsons.c predictions.c recommender.c sorting.c utility_matrix.c -o recsys_opt_omp -lm
```

## Running Benchmarks and Verification
To benchmark iterations across "Cold" (Data Parse + Prediction) and "Warm" (Cache + Prediction) profiles:
```bash
export OMP_NUM_THREADS=4
./run_benchmark.sh
```

To verify correctness output between optimization trees:
```bash
./verify_correctness.sh
```

## Python Plot Generation & Reproducibility
To construct graphing analytics against `ratings_learn.csv` sizes:
```bash
python3 scripts/analyze_dataset.py
python3 scripts/generate_plots.py
```
*(Graphs correspond inside `report/figures/` directories).*

For detailed measurements mapping execution footprints and `gprof` logs across structural implementations, see the [Benchmark Results](benchmark_results.md) page or generate the included LaTeX document:
```bash
./report/build_report.sh
```

**Repository URL:** [https://github.com/UchihaIthachi/Movie-Recommendation-System](https://github.com/UchihaIthachi/Movie-Recommendation-System)
