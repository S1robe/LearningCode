package me.kira.practice.hackerrank;

import java.util.Scanner;

/**
 * The purpose of self class is to solve the following problem:
 *We use the integers a, b, and n to create the following series:
 *          (a + 2^0*b) ... (a + 2^(n-1)*b)
 * You are given 'q' queries in the form of a, b, and n. For each query, print the series corresponding to the given a, b,
 * and n values as a single line of  space-separated integers.
 */
public class JavaLoops2 {

    public static void main(String[] args) {
        Scanner in = new Scanner(System.in);
        int q=in.nextInt();
        StringBuilder builder = new StringBuilder();
        for(; q > 0; q--) {
            int a = in.nextInt();
            int b = in.nextInt();
            int n = in.nextInt();

            int p = 0;

            for(int i = 0; i< n;i++){
                p += Math.pow(2, i);
                builder.append((a + (p*b))).append(" ");
            }
            builder.append("\n");
        }
        System.out.println(builder);




    }
}