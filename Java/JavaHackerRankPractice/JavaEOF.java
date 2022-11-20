package me.kira.practice.hackerrank;

import java.io.InputStreamReader;
import java.util.Scanner;

/**
 * This class was created to solve the following problem:
 * The challenge here is to read 'n' lines of input until you reach EOF, then number and print all 'n' lines of content.
 *
 * Input Format
 *
 * Read some unknown 'n' lines of input from stdin(System.in) until you reach EOF; each line of input contains a non-empty String.
 *
 * Output Format
 *
 * For each line, print the line number, followed by a single space, and then the line content received as input.
 *
 */
public class JavaEOF {

   public static void main(String[] args) {
      Scanner in = new Scanner(System.in);
      for(int n = 1; in.hasNextLine(); n++)
         System.out.print(n + " " + in.nextLine()+"\n");
   }

}
