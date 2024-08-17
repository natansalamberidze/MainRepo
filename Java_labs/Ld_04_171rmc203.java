package dip_107;
import java.util.Scanner;
public class Ld_04_171rmc203 {
	static Scanner sc = new Scanner(System.in);
			public static void main(String[] args) {

		System.out.println("Natans Šalamberidze 11gr. 171rmc203");
		System.out.println("uzdevums:");
		
		int A[][] = new int[10][10];
		int i, j, k, C;
		
		if(sc.hasNextInt())
			k= sc.nextInt();
		else {
			System.out.println("input-output error");
			sc.close();
			return;
			
		}
		sc.close();
		if(k==1) {
		       C=1;
					for(j=9; j>=0;j--)
						for( i=j; i<=j+2; i++) {
							if(i<=9)
							A[i][j] = C++;
						}
				} 
		
		
		else if(k==2) {   
			
			for(j=8;j>=0;j--) {
				for(i=8-j;i>=0;i--)
					A[i][j] = 9-j-i; 
				}
			} 
		
		else {
			System.out.println("input-output error");
			return;
		}
			
		System.out.println("result:");
		for (i=0; i<10; i++) {
			for (j=0; j<10; j++)
				System.out.print(A[i][j] + "\t");
			System.out.println();
			
		}
		
	}
	

	
}
