#!/bin/bash
export OMP_NUM_THREADS=4

echo "Building baseline..."
gcc -O0 time_test_baseline.c baseline_src/kmeans.c baseline_src/matrix_normalization.c baseline_src/pearsons.c baseline_src/predictions.c baseline_src/recommender.c baseline_src/sorting.c baseline_src/utility_matrix.c -I./ -o recsys_base -lm 2>/dev/null

echo "Building optimized single-thread..."
gcc -O3 -march=native kmeans.c matrix_normalization.c pearsons.c predictions.c recommender.c sorting.c utility_matrix.c time_test_optimized_st.c -o recsys_opt_st -lm 2>/dev/null

echo "Building optimized OpenMP..."
gcc -O3 -march=native -fopenmp kmeans.c matrix_normalization.c pearsons.c predictions.c recommender.c sorting.c utility_matrix.c time_test_optimized_omp.c -o recsys_opt_omp -lm 2>/dev/null

echo "--- RUNNING BASELINE O0 ---" > raw_benchmark_logs.txt
for i in {1..5}; do
  echo "Run $i:" | tee -a raw_benchmark_logs.txt
  ./recsys_base < /dev/null | grep -E "Cold|Warm" | sed "s/Type '0' for No and '1' for Yes: //" | tee -a raw_benchmark_logs.txt
done

echo "" | tee -a raw_benchmark_logs.txt
echo "--- RUNNING OPTIMIZED O3 SINGLE-THREAD ---" | tee -a raw_benchmark_logs.txt
for i in {1..5}; do
  echo "Run $i:" | tee -a raw_benchmark_logs.txt
  ./recsys_opt_st < /dev/null | grep -E "Cold|Warm" | sed "s/Type '0' for No and '1' for Yes: //" | tee -a raw_benchmark_logs.txt
done

echo "" | tee -a raw_benchmark_logs.txt
echo "--- RUNNING OPTIMIZED O3 OPENMP ---" | tee -a raw_benchmark_logs.txt
for i in {1..5}; do
  echo "Run $i:" | tee -a raw_benchmark_logs.txt
  ./recsys_opt_omp < /dev/null | grep -E "Cold|Warm" | sed "s/Type '0' for No and '1' for Yes: //" | tee -a raw_benchmark_logs.txt
done
