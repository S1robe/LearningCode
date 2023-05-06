package me.kira.practice.hackerrank;


import java.util.Scanner;

/**
 * Static initialization blocks are executed when the class is loaded, and you can initialize static variables in those blocks.
 *
 * It's time to test your knowledge of Static initialization blocks. You can read about it here.
 *
 * You are given a class Solution with a main method. Complete the given code so that it outputs the area of a parallelogram
 * with breadth B and height H. You should read the variables from the standard input.
 *
 * If B or  H, the output should be "java.lang.Exception: Breadth and height must be positive" without quotes.
 */
public class JavaStaticInitBlock {

   private static final boolean flag;
   private static final int B = new Scanner(System.in).nextInt();
   private static final int H = new Scanner(System.in).nextInt();

   static{
      flag = B <= 0 || H <= 0;
      if(flag)
         System.out.println("java.lang.Exception: Breadth and height must be positive");
   }

   //This is an alternate answer, I have found that on a compiler the previous code works, but on a text interpreter does
   // not
   /*
         private static boolean flag = true;
         private static final int B;
         private static final int H;

         static{
            Scanner temp = new Scanner(System.in);
            B = temp.nextInt();
            H = temp.nextInt();
            if(B <= 0 || H <= 0) {
               System.out.println("java.lang.Exception: Breadth and height must be positive");
               flag = false;
            }
         }


    */

   /**
    * This code was provided by hacker rank, the focus of cls challenge is to write a static block for initialization
    *
    * @param args ignored;
    */
   public static void main(String[] args){
      if(flag){
         int area=B*H;
         System.out.print(area);
      }

   }//end of main

}//end of class
