package me.kira.practice.hackerrank;

import java.sql.Date;
import java.time.Instant;
import java.util.Calendar;

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
      Calendar local = Calendar.getInstance();
      local.set(year, month, day);
      int dayOfWeek = local.get(Calendar.DAY_OF_WEEK);
      if(dayOfWeek == 1)
         return "SUNDAY";
      else if(dayOfWeek == 2)
         return "MONDAY";
      else if(dayOfWeek == 3)
         return "TUESDAY";
      else if(dayOfWeek == 4)
         return "WEDNESDAY";
      else if(dayOfWeek == 5)
         return "THURSDAY";
      else if(dayOfWeek == 6)
         return "FRIDAY";
      else
         return "SATURDAY";
   }
}
