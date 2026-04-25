//Centered cosine similarity
#include<stdio.h>
#include<stdlib.h>
#include<math.h>

// Optimized pearson_correlation function
// Precomputed mag_a is passed, so we only compute dot_p and mag_b.
double pearson_correlation(double *A, double *B, unsigned int size, double mag_a){
    double dot_p = 0.0;
    double mag_b = 0.0;
    unsigned int i;
    
    // Unrolled or sequentially accessed loops
    for(i=0; i<size; i++){
        // Pre-checking B[i] speeds up sparse arrays (since many entries are 0)
        if (B[i] != 0.0) {
            dot_p += A[i] * B[i];
            mag_b += B[i] * B[i];
        }
    }
    
    // Avoid division by zero
    if (mag_a == 0.0 || mag_b == 0.0) {
        return 0.0;
    }
    
    return dot_p / (sqrt(mag_a) * sqrt(mag_b));
}

void calc_similarity(double *normalizeduser, double *normalized_matrix, double *similarity, int No_of_users, int No_of_movies){
	int i=0;
    
    // Precompute mag_a since normalizeduser doesn't change
    double mag_a = 0.0;
    for (int k = 0; k < No_of_movies; k++) {
        mag_a += normalizeduser[k] * normalizeduser[k];
    }
    
	for(i=0;i<No_of_users;i++){ //traverse through each user
		// Instead of reallocating memory and copying the normalized_matrix row, 
        // directly pass the pointer to the start of the user's vector in normalized_matrix.
		double *A = &normalized_matrix[i*No_of_movies];
		
		//find similarity between new user and ith user
		similarity[i] = pearson_correlation(normalizeduser, A, No_of_movies, mag_a);
	}
}
