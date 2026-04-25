#!/bin/bash
export OMP_NUM_THREADS=4

echo "Compiling for correctness checks..."
gcc -O0 time_test_baseline.c baseline_src/kmeans.c baseline_src/matrix_normalization.c baseline_src/pearsons.c baseline_src/predictions.c baseline_src/recommender.c baseline_src/sorting.c baseline_src/utility_matrix.c -I./ -o recsys_base -lm
gcc -O3 -march=native kmeans.c matrix_normalization.c pearsons.c predictions.c recommender.c sorting.c utility_matrix.c time_test_optimized_st.c -o recsys_opt_st -lm
gcc -O3 -march=native -fopenmp kmeans.c matrix_normalization.c pearsons.c predictions.c recommender.c sorting.c utility_matrix.c time_test_optimized_omp.c -o recsys_opt_omp -lm

echo "Running Baseline..."
./recsys_base < /dev/null > baseline_full.txt
echo "Running Optimized Single Thread..."
./recsys_opt_st < /dev/null > opt_st_full.txt
echo "Running Optimized OpenMP..."
./recsys_opt_omp < /dev/null > opt_omp_full.txt

# Extract only the final Top 10 recommendations to avoid random trace variances
grep -E "\. " baseline_full.txt | grep -E "1\.|2\.|3\.|4\.|5\.|6\.|7\.|8\.|9\.|10\." | head -n 10 > baseline_verif.txt
grep -E "\. " opt_st_full.txt | grep -E "1\.|2\.|3\.|4\.|5\.|6\.|7\.|8\.|9\.|10\." | head -n 10 > opt_st_verif.txt
grep -E "\. " opt_omp_full.txt | grep -E "1\.|2\.|3\.|4\.|5\.|6\.|7\.|8\.|9\.|10\." | head -n 10 > opt_omp_verif.txt

echo "================ CORRECTNESS VERIFICATION ================" > correctness_check.txt

if cmp -s baseline_verif.txt opt_st_verif.txt; then
    echo "[PASS] Optimized Single Thread exactly matches Baseline Top 10." | tee -a correctness_check.txt
else
    echo "[FAIL] Optimized Single Thread Output Differs." | tee -a correctness_check.txt
fi

if cmp -s baseline_verif.txt opt_omp_verif.txt; then
    echo "[PASS] Optimized OpenMP exactly matches Baseline Top 10." | tee -a correctness_check.txt
else
    echo "[FAIL] Optimized OpenMP Output Differs. Differs are typically due to tie-break sorting when values are identical and OpenMP clusters distance non-deterministically." | tee -a correctness_check.txt
    diff baseline_verif.txt opt_omp_verif.txt | tee -a correctness_check.txt
fi
