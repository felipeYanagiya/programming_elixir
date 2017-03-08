import java.util.Scanner;
import java.util.*;

class PrimeRange {
   public static void main (String[] args) {
      Scanner scanner = new Scanner(System.in);
      int i = 0;
      int num = 0;
      //Empty String
      List<Integer> primeNumbers = new ArrayList<Integer>();

      if (args.length == 0) {
        throw new IllegalArgumentException("Enter a valid entry number!");
      }

      int n = Integer.parseInt(args[0]);

      for (i = 1; i <= n; i++) {
         int counter = 0;
         for (num = i; num >= 1; num--) {
	           if(i % num == 0)
		           counter = counter + 1;
	       }
	       if (counter == 2) {
	           //Appended the Prime number to the String
	           primeNumbers.add(i);
	       }
      }
      System.out.println("Prime numbers from 1 to n are :");
      System.out.println(primeNumbers);
   }
}
