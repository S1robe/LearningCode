package me.kira.practice.hackerrank;

import javax.swing.text.NumberFormatter;
import java.util.Currency;
import java.util.Locale;
import java.util.Scanner;

/**
 * This class was created to solve the Java Currency formatter challenge.
 */
public class JavaCurrency {

   /**
    * Everything outside of the comments in this method belong to HackerRank
    * @param args
    */
   public static void main(String[] args) {
      Scanner scanner = new Scanner(System.in);
      double payment = scanner.nextDouble();
      scanner.close();


      // Write your code here.
      //Start my code
      Currency us;
      Currency india;
      Currency china;
      Currency france;
      us = Currency.getInstance(Locale.US);
      india = Currency.getInstance(new Locale("en", "IN"));
      china = Currency.getInstance(Locale.CHINA);
      france = Currency.getInstance(Locale.FRANCE);



      //End my code



      System.out.println("US: " + us);
      System.out.println("India: " + india);
      System.out.println("China: " + china);
      System.out.println("France: " + france);
   }
}






