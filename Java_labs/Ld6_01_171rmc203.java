package dip_107;
import java.util.Scanner;
 
public class Ld6_01_171rmc203{
	static String Symbols(String symbol) {
	symbol = symbol.trim();
	String result = "";
	char ch = '0';
int i,max=0,test=0;
char[]arr = symbol.toCharArray();
for(i=0;i<arr.length;i++)
if(i+1<arr.length) {
		if(arr[i]==arr[i+1])
		test++;
else {
		test++;
if(test>max) {
			ch=arr[i];
			max=test;
			test=0;
			  }
	 test=0;
			  }  
			  }
else {
test++;
if(test>max) {
		ch= arr[i];
		 max=test;
			  }
		  }
	for(i=0;i<max;i++)
	result=result+ch;
	return result;
	      }
public static void main(String[]args) {
		String s;
		Scanner sc= new Scanner(System.in);
		System.out.println("Natans Šalamberidze 11.grupa 171RMC203 ");
		System.out.print("input string: ");
		s = sc.nextLine();
		sc.close();
		System.out.println("result: ");
		System.out.println(Symbols(s));
	      }
     }
	
	
	
	
	
