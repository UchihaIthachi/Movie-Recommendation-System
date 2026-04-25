#!/bin/bash
gcc -O3 -march=native -fopenmp time_test.c kmeans.c matrix_normalization.c pearsons.c predictions.c recommender.c sorting.c utility_matrix.c -o recsys_opt -lm
export OMP_NUM_THREADS=4
echo "Running optimized..."
./recsys_opt < test_input.txt | grep "Run Time"
