
	package dip_107;
	import java.util.Scanner;
	public class Md_171rmc203 {
		public static void main(String[] args) {
			Scanner sc = new Scanner(System.in);
			    double x=0, y=0;
			    System.out.println("171rmc203 Natans Šalamberidze 1");
			    System.out.print("x=");
				   if (sc.hasNextFloat())
				      x = sc.nextFloat();
				   else {
				System.out.println("input-output error");
				   sc.close();
				   return;
				   }
				   
				System.out.print("y=");
				if (sc.hasNextFloat())
				    y = sc.nextFloat();
				    else {
				System.out.println("input-output error");
				sc.close();
				return;
				}
				sc.close();
				System.out.println();
		
				boolean green=(Math.pow(x-6,2) + Math.pow(y-6,2) <= 16);
				boolean redA= x>4 && x<5 && y>6 && y<7;
				boolean redB=x>7 && x<8 && y>6 && y<7;
				boolean redC=x>5 && x<7 &&  y>4 && y<5;
				boolean blueA=x>=4 && x<=6 && y>x+4 && y<=(-x+16);
				boolean blueB=x>=6 && x<=8 && y<=x+4 && y>(-x+16);
				
				
				
				if(redA||redB||redC) {  
					 System.out.println("red") ;
				}
				else if(blueA||blueB) {
					System.out.println("blue") ;
				}
				else if(green) {    
					System.out.println("green"); 
				}
				else     
					System.out.println("white");   
		
			    
		}
		}

