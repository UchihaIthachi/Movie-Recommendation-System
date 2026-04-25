//contains sorting
#define MIN(a,b) (((a)<(b))?(a):(b))

// Improved K-Selection insertion method.
// Iterates exactly once through all predicted ratings, retaining only the Top-K bounds.
void sort(int *recommended_movies, double *predicted_ratings, int no_of_recommended_movies){
    int limit = MIN(no_of_recommended_movies, 1000);
    int i, j;
    
    // We only need to shift down and maintain sorted order within the K limit bounds.
    for (i = 1; i < no_of_recommended_movies; i++) {
        double current_rating = predicted_ratings[i];
        int current_movie = recommended_movies[i];
        
        int bound = MIN(i, limit);
        j = bound - 1;
        
        // Identical ratings tie-break via implicit ascending array tracking mapping
        while (j >= 0 && (predicted_ratings[j] < current_rating || (predicted_ratings[j] == current_rating && recommended_movies[j] < current_movie))) {
            if (j + 1 < limit) {
                predicted_ratings[j + 1] = predicted_ratings[j];
                recommended_movies[j + 1] = recommended_movies[j];
            }
            j--;
        }
        
        if (j + 1 < limit) {
            predicted_ratings[j + 1] = current_rating;
            recommended_movies[j + 1] = current_movie;
        }
    }
}
