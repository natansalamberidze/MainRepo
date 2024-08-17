package dip_107;

public class kd {
	public static void f(int[] A, int i) {
		 if (i<A.length-1) {
			 f(A,i+1);
			 A[i]=A[i+1];
		 }
	}

	public static void main(String[] args) {
		int[] A = {1,2,3,4,5,6};
		f(A,0);
		System.out.printf("%d %d %d %d %d %d",A[0], A[1],A[2],A[3],A[4],A[5]);
		}
	}

	
	
	 
	
	
