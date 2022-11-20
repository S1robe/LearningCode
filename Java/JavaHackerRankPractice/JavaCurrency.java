package me..practice.hackerrank;

import javax.swing.text.NumberFormatter;
import java.text.NumberFormat;
import java.util.Currency;
import java.util.Locale;
import java.util.Scanner;

/**
 * This class was created to solve the Java Currency formatter challenge.
 */
public class JavaCurrency {

   /**
    * Everything outside of the comments in cls method belong to HackerRank
    * @param args
    */
   public static void main(String[] args) {
      Scanner scanner = new Scanner(System.in);
      double payment = scanner.nextDouble();
      scanner.close();


      // Write your code here.
      //Start my code

      String  us     = NumberFormat.getCurrencyInstance(Locale.US).format(payment),
              india  = NumberFormat.getCurrencyInstance(new Locale("en", "IN")).format(payment),
              china  = NumberFormat.getCurrencyInstance(Locale.CHINA).format(payment),
              france = NumberFormat.getCurrencyInstance(Locale.FRANCE).format(payment);
      //End my code



      System.out.println("US: " + us);
      System.out.println("India: " + india);
      System.out.println("China: " + china);
      System.out.println("France: " + france);
   }
}






