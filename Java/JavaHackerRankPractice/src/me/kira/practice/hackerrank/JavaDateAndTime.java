package me.kira.practice.hackerrank;

import javax.xml.transform.Result;
import java.io.*;
import java.time.DayOfWeek;
import java.time.Instant;
import java.time.temporal.TemporalAccessor;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

/**
 * This class was created to solve the following HackerRank Exercise:
 *
 * You are given a date. You just need to write the method, findDay, which returns the day on that date. To simplify your
 * task, we have provided a portion of the code in the editor.
 *
 * Example
 * month = 8
 * day = 14
 * year  = 2017
 * The method should return MONDAY as the day on that date
 */
public class JavaDateAndTime {

   /*
    * Complete the 'findDay' function below.
    *
    * The function is expected to return a STRING.
    * The function accepts following parameters:
    *  1. INTEGER month
    *  2. INTEGER day
    *  3. INTEGER year
    */

   public static String findDay(int month, int day, int year) {
      Calendar c = Calendar.getInstance();
      c.set(Calendar.MONTH, month-1);
      c.set(Calendar.DAY_OF_MONTH, day);
      c.set(Calendar.YEAR, year);
      return c.getDisplayName(Calendar.DAY_OF_WEEK, Calendar.LONG, Locale.US).toUpperCase();
   }

   public static void main(String[] args) throws IOException {

      String res = findDay(8,5,2015);
      System.out.println(res);
   }
}
