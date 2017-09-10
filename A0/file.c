#include <stdio.h>
#include <stdlib.h>
#include <string.h> // include for strerror(3) function
#include <errno.h> // include to access errno

int checkFile(char *path);
int print_error(char *path, int errnum);
void checkError(char *path);

int main (int argc, char *argv[]){
	switch (argc) {
		case 1:
			printf("Usage: file path \n");
			exit(EXIT_FAILURE);
		case 2: 
			exit(checkFile(argv[1]));
		default: 
			printf("Too many arguments\n");
			exit(EXIT_FAILURE);
	}
}	


int checkFile(char *path){
	// open file
	FILE* f = fopen(path, "r");
	// check IO error
	checkError(path);
mp
	// get file size
	fseek(f, 0, SEEK_END); // seek to end
	int file_size = (int) ftell(f); 
	// seek back to beginning
	fseek(f, 0, SEEK_SET); // seek to end

	// check IO error
	urecheckError(path);

	// allocate file size
	char *content = (char *) malloc(file_size);	

	// read file
	int read_size = (int) fread(content, 1, file_size, f);
	// check IO error
	checkError(path);


	// check if file is of type empty
	if(file_size == 0){
	// empty file
		fprintf(stdout, "%s: empty\n", path);
	}else{
	// check if file is of type data

	int bool = 0;
		for(int i=0; i<read_size; i++){
			if( !((7 <= (int)content[i]) && ((int)content[i] <= 13)) && !((int)content[i] == 27) && !((32 <= (int)content	[i]) && ((int)content[i] <= 126))
			){
				bool = 1;				
				break;
		}
	}

// can we roll this into the loop?
		if(bool == 1){
		fprintf(stdout, "%s: data\n", path);
		}else{
			fprintf(stdout, "%s: ASCII text\n", path);
		}	
}

	//exit protocol
	// close file
	fclose(f);
	// check IO error
	checkError(path);

	// exit with exit_succes
	exit(EXIT_SUCCESS);	
}


int print_error(char *path, int errnum){
	return fprintf(stdout, "%s: cannot determine (%s)\n", path, strerror(errnum));
}

void checkError(char *path){ 
	if(errno != 0){
		// if IO error, print error
		print_error(path, errno); 
		exit(EXIT_SUCCESS);	
	}
}





