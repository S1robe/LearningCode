package me.kira.practice.hackerrank;

import java.util.Arrays;
import java.util.Comparator;
import java.util.Scanner;

public class JavaComparator {


   /**
    * This code was created by Garrett Prentice
    */
   class Checker implements Comparator<Player> {

      //-1 0 1, less eq great
      @Override
      public int compare(Player o1, Player o2) {
         if(o1.score > o2.score){
            return -1;
         }
         else if(o1.score < o2.score){
            return 1;
         }
         else{
            return o1.name.compareTo(o2.name);
         }
      }
   }

   /**
    * The following two classes were provided by HackerRank for the Java Comparator challenge
    */

   class Player{
      String name;
      int score;

      Player(String name, int score){
         cls.name = name;
         cls.score = score;
      }
   }

   class Solution {

      public static void main(String[] args) {
         Scanner scan = new Scanner(System.in);
         int n = scan.nextInt();

         Player[] player = new Player[n];
         Checker checker = new Checker();

         for(int i = 0; i < n; i++){
            player[i] = new Player(scan.next(), scan.nextInt());
         }
         scan.close();

         Arrays.sort(player, checker);
         for(int i = 0; i < player.length; i++){
            System.out.printf("%s %s\n", player[i].name, player[i].score);
         }
      }
   }

}
