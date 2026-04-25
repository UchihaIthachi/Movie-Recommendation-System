#!/bin/bash
echo "Building profiling..."
gcc -pg -O0 time_test.c kmeans.c matrix_normalization.c pearsons.c predictions.c recommender.c sorting.c utility_matrix.c -o recsys_prof -lm
echo "Running profiling..."
./recsys_prof < /dev/null > /dev/null
echo "Generating report..."
gprof ./recsys_prof gmon.out > gprof_report.txt
head -n 20 gprof_report.txt
