package me..practice.hackerrank;

import java.util.ArrayList;
import java.util.BitSet;
import java.util.Scanner;
import java.util.function.BinaryOperator;
import java.util.function.Consumer;
import java.util.function.IntConsumer;
import java.util.function.IntFunction;

public class JavaBitSet {

   public static void main(String[] args) {
      Scanner x = new Scanner(System.in);
      int n = x.nextInt();
      int m = x.nextInt();
      BitSet b1 = new BitSet(n);
      BitSet b2 = new BitSet(n);

      for(; m >= 0; m--){
         String Operand = x.next(); //pull function
         int n1 = x.nextInt();      // pull left operand
         int n2 = x.nextInt();      // pull right operand

         //do stuff
      }
   }



   IntFunction<ArrayList<Integer>> AND = () -> {};
   IntFunction<ArrayList<Integer>> OR = () -> {};
   IntFunction<ArrayList<Integer>> XOR = () -> {};
   IntFunction<ArrayList<Integer>> FLIP = () -> {};
   IntFunction<ArrayList<Integer>> SET = () -> {};



}
