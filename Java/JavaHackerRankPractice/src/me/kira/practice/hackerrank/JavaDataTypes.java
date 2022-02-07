package me.kira.practice.hackerrank;

import java.util.Scanner;

/**
 * This class was created to solve this problem on HackerRank
 *
 * Given an input integer, you must determine which primitive data types are capable of properly storing that input.
 *
 * The first line contains an integer, T, denoting the number of test cases.
 * Each test case, T, is comprised of a single line with an integer, n, which can be arbitrarily large or small.
 *
 * For each input variable n and appropriate primitive dataType you must determine if the given primitives are capable of storing it. If yes, then print:
 *
 */
public class JavaDataTypes {

   public static void main(String[] args) {
      Scanner in = new Scanner(System.in);
      int t = in.nextInt();
      in.nextLine();
      for(; t>0;t--){
         String cantidate = in.nextLine();
         byte result = 0b0000;
         try{
            Byte.parseByte(cantidate);
            result = 0b1111;
         }
         catch(NumberFormatException e){
            try{
               Short.parseShort(cantidate);
               result = 0b111;
            }
            catch(NumberFormatException f){
               try{
                  Integer.parseInt(cantidate);
                  result = 0b11;
               }
               catch(NumberFormatException g){
                  try{
                     Long.parseLong(cantidate);
                     result = 0b1;
                  }
                  catch(NumberFormatException h){}
               }
            }
         }
         printResults(cantidate, result);
      }
   }

   private static void printResults(String cantidate, byte result){
      switch(result){
         case 0b1111:
            System.out.println(cantidate + " can be fitted in:");
            System.out.println("* byte");
            System.out.println("* short");
            System.out.println("* int");
            System.out.println("* long");
            break;
         case 0b111:
            System.out.println(cantidate + " can be fitted in:");
            System.out.println("* short");
            System.out.println("* int");
            System.out.println("* long");
            break;
         case 0b11:
            System.out.println(cantidate + " can be fitted in:");
            System.out.println("* int");
            System.out.println("* long");
            break;
         case 0b1:
            System.out.println(cantidate + " can be fitted in:");
            System.out.println("* long");
            break;
         default:
            System.out.println(cantidate + " can't be fitted anywhere.");
      }
   }
}
















































































//   Scanner sc = new Scanner(System.in);
//   int t=sc.nextInt();
//
//        for(int i=0;i<t;i++)
//                                {
//
//                                try
//                                {
//                                long x=sc.nextLong();
//                                System.out.println(x+" can be fitted in:");
//                                if(x>=-128 && x<=127)System.out.println("* byte");
//                                //Complete the code
//                                }
//                                catch(Exception e)
//                                {
//                                System.out.println(sc.next()+" can't be fitted anywhere.");
//                                }
//
//                                }