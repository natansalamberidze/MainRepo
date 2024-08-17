import java.util.Scanner;

public class Main {
  public static void firstMethod(int[] a) {
    int t = (int) Math.log(a.length);
		int[] h = new int[t];
		h[0] = 1;
		for (int k = 1; k < t; k++) {
			h[k] = 2*h[k-1] + 1;
		}
		t--;
		while (t >= 0) {
	    int inc = h[t];
		  t--;
		  int i = inc;
		  while (i < a.length) {
		    int temp = a[i];
		    int j = i - inc;
		    while (j >= 0 && a[j] > temp) {
			    a[j+inc] = a[j];
			    j-=inc;
		    }
		    a[j+inc] = temp;
		    i++;
      }
    }
	}
  public static void secondMethod(int[] a) {
		boolean b = true;
		while (b) {
			b = false;
			for (int i = 0; i < a.length; i+=2) {
				if (i+1 < a.length) {
					if (a[i] > a[i+1]) {
						int temp = a[i];
						a[i] = a[i+1];
						a[i+1] = temp;
						b = true;
					}
				}
			}
			for (int i = 1; i < a.length; i+=2) {
				if (i+1 < a.length) {
					if (a[i] > a[i+1]) {
						int temp = a[i];
						a[i] = a[i+1];
						a[i+1] = temp;
						b = true;
					}
				}
			}
		}
	}
  public static void thirdMethod(int[] a){
		int gCnt, gLen, min, bmin;
		gLen = (int) Math.sqrt(a.length);
		gCnt = gLen;
		if (Math.sqrt(a.length) % 1 != 0){
			gCnt++;
		}
		int[] buf;
		buf = new int[gCnt];
		int[][] gBorders;
		gBorders = new int[gCnt][2];
		gBorders[0][0] = 0;
		gBorders[0][1] = gLen-1;
		for(int i = 1; i<gCnt; i++){
			gBorders[i][0] = gBorders[i-1][0]+gLen;
			gBorders[i][1] = gBorders[i-1][1]+gLen;
		}
		gBorders[gCnt-1][1] = a.length-1;
		for(int i = 0; i<gCnt; i++){
			min = gBorders[i][0];
			for(int j = gBorders[i][0]+1; j<=gBorders[i][1]; j++){
				if (a[min]>a[j]){
					min = j;	
				}
			}
			buf[i] = a[min];
			a[min] = Integer.MAX_VALUE;
		}
		int[] b;
		b = new int[a.length];
		for(int k = 0; k<b.length; k++){
			bmin = 0;
			for(int i = 1; i<gCnt; i++){
				if (buf[bmin]>buf[i]){
					bmin = i;
				}
			}
			b[k] = buf[bmin];
			buf[bmin] = Integer.MAX_VALUE;
			min = gBorders[bmin][0];
			for(int i = gBorders[bmin][0]+1; i<=gBorders[bmin][1]; i++){
				if (a[min]>a[i]){
					min = i;
				}
			}
			buf[bmin] = a[min];
			a[min] = Integer.MAX_VALUE;
		}
    for(int i = 0; i<b.length; i++){
      a[i] = b[i];
		}
	}

  public static void main(String[] args) {
    System.out.println("Natans Šalamberidze 9. grupa 171RMC203");
    int v = 0;
    boolean c = false;
    Scanner sc = new Scanner(System.in);
    while (!c) {
      System.out.print("method: ");
      if (sc.hasNextInt())
			  v = sc.nextInt();
		  else {
			  System.out.println("input-output error");
			  sc.close();
		    return;
		  }
      switch(v){
      case 1:
        c = true;
        break;
      case 2:
        c = true;
        break;
      case 3:
        c = true;
        break;
      default:
        System.out.println("the value must be either 1, 2 or 3");
    }
    }
    System.out.print("count: ");
		int n;
		if (sc.hasNextInt())
			n = sc.nextInt();
		else {
			System.out.println("input-output error");
			sc.close();
			return;
		}
		int[] a;
		a = new int[n];
		System.out.println("items:");
		for(int i = 0; i<n; i++){
			if (sc.hasNextInt())
				a[i] = sc.nextInt();
			else {
				System.out.println("input-output error");
				sc.close();
				return;
			}
		}
    switch(v){
      case 1:
        firstMethod(a);
        break;
      case 2:
        secondMethod(a);
        break;
      case 3:
        thirdMethod(a);
    }
		System.out.println("result:");
		for(int i = 0; i<n; i++){
			System.out.print(a[i]+" ");
		}
		sc.close();
  }
}