#include<stdint.h>

extern float my_division(float* a, float* b);
extern int check_square(int x, int y, int r);
extern int Matrix_Coordinates[11][22];
extern uint8_t ROWS;
extern uint8_t COLUMNS;

__attribute__((naked))void call_svc(void){
				__asm("svc #0xCA\n\t"
							"BX LR");
}


int main(void){
	//int *n = &(Matrix_Coordinates);
	int radius = 2;
	//int radius = 3;
	//int radius = 5;
	
	//int R = ROWS;
	//int C = COLUMNS;
	int x_coordinate;
	int y_coordinate;
	int area = 0;
	

	
	
	int i,j;
	for (i = 0; i < ROWS; i++) {
    for (j = 0; j < COLUMNS; j += 2) {
        x_coordinate = Matrix_Coordinates[i][j];
        y_coordinate = Matrix_Coordinates[i][j + 1];

        area += check_square(x_coordinate, y_coordinate, radius);
    }
}
	
	radius = radius * radius;
	float radius_f = (float)radius;
	float area_f = (float)area;
	float PI = my_division(&area_f, &radius_f); //passing the address of this values seeds the prototype is a pointer to that address
	call_svc();
	__asm__("SVC #0xFE");

		
	while(1);
}
