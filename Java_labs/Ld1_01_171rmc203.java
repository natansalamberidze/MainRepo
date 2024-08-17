package dip_107;
import java.util.Scanner;

public class Ld1_01_171rmc203 {
public static void main(String[] args) { 
	Scanner sc = new Scanner(System.in);
	System.out.println("171rmc203 Natans Šalamberidze");
	
	int x, y;
	System.out.print("x=");
	x = sc.nextInt();
	
	System.out.print("y=");
	y = sc.nextInt();
	
	System.out.println("result");
	
	if( Math.pow((x-3), 2) + Math.pow((y-3), 2) <= Math.pow(2, 2))
	
			System.out.print("grey");
	else if ((y >= 3 && x <=9  && y <= x-2))
		 System.out.print("white");
	else {
	System.out.println("none");
	}
		

	sc.close();


}
}

