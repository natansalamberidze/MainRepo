package dip_107;

import java.util.Random;
import java.util.Scanner;

public class Md3_171rmc203 {

	public static void main(String[] args) {
		int a[] = new int [20];
		int k, i;
		
		
		Scanner sc = new Scanner(System.in);
	
		System.out.println("171rmc203 Natans Šalamberidze 11.grupa");
		System.out.print("k=");
		if (sc.hasNextInt())
		k = sc.nextInt();
		else {
		System.out.println("input-output error");
		sc.close();
		return;
		}
		sc.close();
	
		System.out.println("result:");
		if (k==0) {
			Random r = new Random();
             
			for (i=0; i<=19; i++)
			
				a[i] = r.nextInt(100)-50;
			
		}
		else  {
	for (i=1; i<=19; i++) {
			
				a[0]=1;
				a[i] = a[i-1]+k;
			}
		}
		System.out.println("A:");		
				for (i=0; i<=19; i++) {
				System.out.printf("%d\t", a[i]);
					if (i==9) System.out.println();
				}
				 
		
				
	System.out.println("A="); {	
			 i=1;
				while(i<a.length && k!=0) {
					System.out.printf("%2d\t", a[i]);
					if (i==9) System.out.println();
					i++;
				a[19]=0;
				}
				
				
				
	}
	
				
				
				
				
				
				
				
					
		
}	

}

				
				
				
				
					
	
	
