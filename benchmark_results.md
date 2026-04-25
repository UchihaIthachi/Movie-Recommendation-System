# Benchmark Results

## 1. Reproducibility Environment
- **OS:** Ubuntu 24.04 (Linux 6.8.0 x86_64)
- **CPU:** Intel(R) Xeon(R) Processor @ 2.30GHz
- **Compiler:** GCC 13.3.0
- **Compiler Flags:**
  - Baseline: `-O0 -lm`
  - Optimized Single-Thread: `-O3 -march=native -lm`
  - Optimized OpenMP: `-O3 -march=native -fopenmp -lm`
- **OMP Threads:** `export OMP_NUM_THREADS=4`

## 2. Dataset Configuration
Analyzed from `Dataset/ratings_learn.csv`:
- Unique Users: 548
- Unique Movies: 8297
- Total Ratings: 80963
- Matrix Size: 4,546,756 elements
- Density: 1.78%
- Sparsity: 98.22%

## 3. Profiling Tools Used
- `gprof`: Function-level execution tracing and heatmapping.
- `sys/time.h` & `omp_get_wtime()`: High-resolution wall-clock evaluations.

## 4. Bottlenecks Identified
1. **$O(N^2)$ Output Sorting:** Sorting the entire 9,125 movie catalog using basic sorting when only 1,000 maximum results are generated is extremely slow (`sorting.c`).
2. **Repeated Allocations:** `calc_similarity` iterated identical user rating structures and re-allocated and freed matrices per calculation loop, causing I-O blockages and excessive L1 cache misses.
3. **Repeated Disk File I/O:** Reading multiple massive CSV files inside the `recommender()` call each time created massive delays upon interactive queries.

## 5. Correctness Verification
Verification checked standard `recsys_base` outputs against `recsys_opt_st` and `recsys_opt_omp`.
- **Baseline vs Optimized Single-Thread:** `[PASS]`
- **Baseline vs Optimized OpenMP:** `[PASS]`
Outputs match exact configurations across test runs avoiding unpredictable race logic across intermediate logging sequences.

## 6. Cold/Warm Benchmark Table
*Measurements are recorded independently capturing explicit Cold vs Warm bounds per runtime loop*

| Version | Cold Avg | Warm Avg | Cold Speedup | Warm Speedup |
|---------|----------|----------|--------------|--------------|
| Baseline O0 | 0.90s | 0.88s | 1.00x | 1.00x |
| Optimized O3 single-thread | 0.50s | 0.069s | 1.80x | 12.75x |
| Optimized O3 OpenMP | 0.54s | 0.069s | 1.66x | 12.75x |

## 7. Trade-offs and Conclusion
The average recommendation time was reduced using profiling-guided code-level optimization. The optimized single-threaded build trades a negligible $\sim$40 MB of higher peak memory utilization (due to static data caching) for a 12.75$\times$ reduction in CPU execution time. It should be noted that while the dataset contains 8,297 unique movies, the baseline C codebase hardcodes the maximum movie ID upper bound as 9,125 (`#define No_of_movies 9125`) to prevent segmentation faults from discontinuous IDs. Therefore, the memory overhead reflects this $548 \times 9125$ dimension.

Because the dataset has extreme 98.22% sparsity, computational loops resolve rapidly under `-O3` optimizations such that multi-core OpenMP overhead cancels out parallel gains, meaning the OpenMP variant provides no measurable advantage over the optimized single-threaded binary. 

No new recommendation algorithms were introduced (rank-$k$ factorization implementations were bypassed to strictly comply with retaining existing algorithms). 

The optimized repository can be evaluated at: [https://github.com/UchihaIthachi/Movie-Recommendation-System](https://github.com/UchihaIthachi/Movie-Recommendation-System)
