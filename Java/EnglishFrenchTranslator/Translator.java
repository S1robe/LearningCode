import java.util.*;
import java.util.concurrent.ThreadLocalRandom;
import java.util.concurrent.TimeUnit;

public class Translator {

   //Populate on runtime
   private static final HashMap<String, String> englishToFrenchMap = new HashMap<>();
   private static final List<List<String>> englishToFrenchList = new ArrayList<>();


   //Benchmarking
   private static long startTime;
   private static long endTime;

   /**
    * Finds an english -> French word from a french dictionary.
    *
    *   dict -> {yes : oui} ... {z : zzadwd}
    *
    *   search1(dict, "yes") -> "oui"
    *
    */

   /**
    * Translates an English word into French from the provided dicitonary.
    *
    * @param englishToFrench The dictionary to parse
    * @param k The english word we are translating
    * @return The french translation of {@param k}
    */
   static String search1(List<List<String>> englishToFrench, String k){
      startTime = System.currentTimeMillis();
      for(List<String> french : englishToFrench) {
         for(String s : french) {
            if(s.equalsIgnoreCase(k))
               return s;
         }
      }
      return "";
   }

   static String search2(HashMap<String, String> dict, String k){
      startTime = System.currentTimeMillis();
      return dict.get(k);
   }

   static void populate(){
      for(int i = 0; i <= 10000000; i++){
         String k = "" + i;
         String v = "" + ThreadLocalRandom.current().nextInt(0, 10000000);
         englishToFrenchMap.put(k, v);
         pushToListList(k, v);
      }
      Collections.shuffle(englishToFrenchList, new Random());
      randomizeHashMap();
   }
   static void pushToListList(String $1, String $2){
      englishToFrenchList.add(new ArrayList<>(2));
      englishToFrenchList.get(englishToFrenchList.size() - 1).add($1);
      englishToFrenchList.get(englishToFrenchList.size() - 1).add($2);
   }
   static void randomizeHashMap(){
      List<Map.Entry<String, String>> hash = new ArrayList<>(englishToFrenchMap.entrySet());
      Collections.shuffle(hash);
      englishToFrenchMap.clear();
      hash.forEach(entry -> englishToFrenchMap.put(entry.getKey(), entry.getValue()));
   }

   public static void main(String[] args) {
      populate();
      String key = englishToFrenchList.get(ThreadLocalRandom.current().nextInt(0, 10000000)).get(0)
      search1(englishToFrenchList, key);
      endTime = System.currentTimeMillis();
      System.out.println("search1 (LoLi): " + (endTime - startTime));

      search2(englishToFrenchMap, key);
      endTime = System.currentTimeMillis();
      System.out.println("search2 (dict): " + (endTime - startTime));
   }
}
