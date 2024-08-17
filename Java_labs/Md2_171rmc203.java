package dip_107;
import java.util.Scanner;
public class Md2_171rmc203 {
public static void main(String[] args) {
System.out.println("171rmc203 Natans Šalamberidze 11.grupa");
Scanner sc = new Scanner(System.in);
 double x,y,v0, t=0.05,g=8.88,alpha=35;
 boolean hitTarget = false;
System.out.print("ātrums = " );
if(sc.hasNextDouble())
	v0 = sc.nextDouble();
else {
	System.out.println("input-output error");
	sc.close();
	return;
}
sc.close();
System.out.println("result:");
System.out.println("t\t x\t y");

do {
	x = v0*t*Math.cos(Math.toRadians(alpha));
	y = v0*t*Math.sin(Math.toRadians(alpha)) -g*t*t/2;
	System.out.printf(" %-3.2f\t%-7.3f%-7.3f%n", t,x,y);
	
	if ((x >=0 && x<=10 && y>0) || (x>=12 && x<=17 && y>-2) || (x>10 && x<12 && y>-4) || (x>17 && y>-4)) {
	hitTarget= true;
	break;
}
}
   while (x>=12 && x<=17 && y<=-2);
	  if(hitTarget)
		  System.out.println("the target was destroyed");
   else
	   System.out.println("shot off the target");
  
}
}
