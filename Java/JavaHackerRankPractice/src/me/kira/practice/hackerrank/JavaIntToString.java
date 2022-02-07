package me.kira.practice.hackerrank;

import java.util.*;
import java.security.*;

public class JavaIntToString {
   public static void main(String[] args) {
      DoNotTerminate.forbidExit();
      try {
         Scanner in = new Scanner(System.in);
         int n = in .nextInt();
         in.close();
         //String s=???; Complete this line below

         //Start my code
         String s = ""+n;

         //End my code


         if (n == Integer.parseInt(s)) {
            System.out.println("Good job");
         } else {
            System.out.println("Wrong answer.");
         }
      } catch (DoNotTerminate.ExitTrappedException e) {
         System.out.println("Unsuccessful Termination!!");
      }
   }

   //The following class will prevent you from terminating the code using exit(0)!

   /**
    * This code was provided by HackerRank for this exercise.
    */
   private static class DoNotTerminate {

      public static class ExitTrappedException extends SecurityException {

         private static final long serialVersionUID = 1;
      }

      public static void forbidExit() {
         final SecurityManager securityManager = new SecurityManager() {
            @Override
            public void checkPermission(Permission permission) {
               if (permission.getName().contains("exitVM")) {
                  throw new ExitTrappedException();
               }
            }
         };
         System.setSecurityManager(securityManager);
      }
   }
}


