package dip_107;
import java.util.Scanner;
public class Ld_05_171rmc203 {
static Scanner sc; 
	
	public static boolean checkNumbers(int n) {
		int x;
		x = sc.nextInt();
		
		return check(n-1, x, true);
	}
	
	private static boolean check(int n, int prevNum, boolean flag) {
		int x;
		if (n==0) {
			return flag;
		}
		else {
			x = sc.nextInt();
			flag = flag && x >= prevNum;
			return check(n-1, x, flag);
		}
	}
		
	public static void main(String[] args) {
		sc = new Scanner(System.in);
		System.out.println("000RDB000 Jānis Programmētājs");
		
		
		int count;
		System.out.print("count:");
		count = sc.nextInt();
		
		System.out.println("numbers:");
		boolean result = checkNumbers(count); 
		
		System.out.print("result:");
		if (result)
			System.out.println(1);
		else
			System.out.println(2);
		
		sc.close();
	}
}
