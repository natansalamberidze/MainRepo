package dip_107;
import java.util.Scanner;
public class Ld3_01_171rmc203 {
public static void main(String[] args) {
	Scanner sc = new Scanner(System.in);
	System.out.println("171RMC203 Natans Šalamberidze 1");
	
	double x;
	System.out.print("x=");
	x = sc.nextDouble();
	System.out.println("result:");
	if (x < 0.1  || x > 1.5 ) {
		System.out.println("error");
		return;
		
	}
double a, s;
	int i;
	s = -(2*x)*(2*x)/2;
	a = -(2*x)*(2*x)/2;
	i =4;
	while(Math.abs(a) > 0.001) {
		a = -a*(2*x)*(2*x)/(i+2);
		s=s+a;
		i=i+2;
	}
	System.out.printf("function=%9f", 2*(Math.cos(x))*(Math.cos(x))-1);
	System.out.printf("\nsumma=%.4f",s);
		
	}
		
   }

