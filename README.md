# Movie Recommendation System

A profiling-guided Movie Recommendation system optimized in C. This program leverages clustering (k-means) and Pearson correlation to predict movie ratings using Collaborative Filtering.

### 🔗 Important Links

- **Repository URL:** [https://github.com/UchihaIthachi/Movie-Recommendation-System](https://github.com/UchihaIthachi/Movie-Recommendation-System)
- **Detailed Benchmark Logs:** [benchmark_results.md](benchmark_results.md)
- **Scientific Computing Final Report:** [report/main.pdf](report/main.pdf)

---

## 🚀 Usage / How to Run

### 1. Compile the Final Optimized Build

The primary production build relies on single-threaded aggressive compiler optimizations to efficiently evaluate the sparse dataset matrix.

```bash
gcc -O3 -march=native ui.c kmeans.c matrix_normalization.c pearsons.c predictions.c recommender.c sorting.c utility_matrix.c -o recsys_opt_st -lm
```

_(Alternatively, to run the experimental OpenMP build natively, append `-fopenmp` and set `export OMP_NUM_THREADS=4`)._

### 2. Execute the CLI Program

```bash
./recsys_opt_st
```

### 3. Interacting with the Menu

Upon launching, the interactive menu will prompt you.

1. Select `2` to login.
2. Select `0` to log in as an existing user, or `1` for a new user.
3. If existing, type a valid User ID (e.g., `1`).
4. Type `1` to **Show existing recommendations** based on the target User ID.
5. The system will load the data, cache it into memory, and output a ranked **Top-10 List of Movies**!

---

## 📊 Running Benchmarks and Verification

To automatically measure iterations across "Cold" (Data Parse + Prediction) and "Warm" (Cache + Prediction) system states:

```bash
export OMP_NUM_THREADS=4
./run_benchmark.sh
```

To automatically verify algorithmic correctness evaluating that optimized variants produce identical outputs relative to the unoptimized baseline:

```bash
./verify_correctness.sh
```

## 📈 Python Plot Generation & Reproducibility

To construct graphing analytics parsing `ratings_learn.csv` dataset sparsity limits:

```bash
python3 scripts/analyze_dataset.py
python3 scripts/generate_plots.py
```

_(Generated graphs correspond inside the `report/figures/` directory)._

To regenerate the LaTeX document formatting natively:

```bash
./report/build_report.sh
```
