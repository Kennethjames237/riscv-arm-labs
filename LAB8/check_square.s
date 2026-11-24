				
				AREA check_square_area, CODE, READONLY
					
					EXPORT	Matrix_Coordinates
					EXPORT ROWS
					EXPORT COLUMNS

Matrix_Coordinates 	DCD -5,5,-4,5,-3,5,-2,5,-1,5,0,5,1,5,2,5,3,5,4,5,5,5
					DCD -5,4,-4,4,-3,4,-2,4,-1,4,0,4,1,4,2,4,3,4,4,4,5,4
					DCD -5,3,-4,3,-3,3,-2,3,-1,3,0,3,1,3,2,3,3,3,4,3,5,3
					DCD -5,2,-4,2,-3,2,-2,2,-1,2,0,2,1,2,2,2,3,2,4,2,5,2
					DCD -5,1,-4,1,-3,1,-2,1,-1,1,0,1,1,1,2,1,3,1,4,1,5,1
					DCD -5,0,-4,0,-3,0,-2,0,-1,0,0,0,1,0,2,0,3,0,4,0,5,0
					DCD -5,-1,-4,-1,-3,-1,-2,-1, -1,-1 ,0,-1,1,-1,2,-1,3,-1,4,-1,5,-1
					DCD -5,-2,-4,-2,-3,-2,-2,-2,-1,-2,0,-2,1,-2,2,-2,3,-2,4,-2,5,-2
					DCD -5,-3,-4,-3,-3,-3,-2,-3,-1,-3,0,-3,1,-3,2,-3,3,-3,4,-3,5,-3
					DCD -5,-4,-4,-4,-3,-4,-2,-4,-1,-4,0,-4,1,-4,2,-4,3,-4,4,-4,5,-4
					DCD -5,-5,-4,-5,-3,-5,-2,-5,-1,-5,0,-5,1,-5,2,-5,3,-5,4,-5,5,-5
ROWS 				DCB 11
COLUMNS 			DCB 22

               
			 
check_square    PROC
				EXPORT  check_square
					
				MUL r0, r0, r0 ; X^2
				MUL r1, r1, r1 ; Y^2
				ADD r0, r0, r1 ; X^2 + Y^2
				
				MUL r2, r2,  r2 ;R^2
				
				CMP	r0, r2 
				ITE	LS
				MOVLS r0, #1
				MOVHI r0, #0
				
				BX LR
				ENDP
					
					
my_division		PROC
				EXPORT	my_division
				IMPORT  __aeabi_fdiv  ; the library to divide floating points in arm
					
				PUSH{R4,R5,R6,R7,LR}
				;access the address to retrive the values because in the c the parameter where passed by address i.e &area_f, &radius_f
				LDR r0, [r0] ; Area
				LDR r1, [r1] ; radius 
				
				BL __aeabi_fdiv
				
				POP{R4,R5,R6,R7,PC}
				ENDP
					
					
                END