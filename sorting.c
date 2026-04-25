//contains sorting
#define MIN(a,b) (((a)<(b))?(a):(b))

void sort(int *recommended_movies, double *predicted_ratings, int no_of_recommended_movies){
	int i=0,j=0;
    
    // We only process up to 1000 items as per the main loop limits
    int limit = MIN(no_of_recommended_movies, 1000);
	
	// Apply identical bubble sort limit without N^2 sorting the entire trailing bounds
	for(i=0;i<limit;i++){
		for(j=i+1;j<no_of_recommended_movies;j++){
			if(predicted_ratings[i]<predicted_ratings[j]){
				double temp1; int temp2;
				temp1 = predicted_ratings[i]; temp2 = recommended_movies[i];
				predicted_ratings[i] = predicted_ratings[j]; recommended_movies[i] = recommended_movies[j];
				predicted_ratings[j] = temp1; recommended_movies[j] = temp2;
			}
		}
	}
}
