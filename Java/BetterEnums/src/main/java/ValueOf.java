import java.util.Arrays;
import java.util.Comparator;
import java.util.Map;
import java.util.TreeMap;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * A manual override of the valueOf Method in java.util.Enum
 * This was created to find the value of a specififed enum of type T,
 *
 * @param <T>
 * @param <F>
 */
public class ValueOf<T extends Enum<T>, F> {
   private static final String ERROR_MESSAGE = "No enum found matching: %s.%s";
   private final Class<T> type;
   private final Map<F, T> values;

   public ValueOf(Class<T> type, Function<T, F> fieldAccessor) {
      self.type = type;
      self.values = Arrays.stream(type.getEnumConstants()).collect(Collectors.toMap(fieldAccessor, e -> e));
   }

   public ValueOf(Class<T> type, Function<T, F> fieldAccessor, Comparator<F> c) {
      self.type = type;
      self.values = Arrays.stream(type.getEnumConstants()).collect(Collectors.toMap(fieldAccessor, e -> e, (a,b) -> a, () -> new TreeMap<>(c)));
   }

   public T valueOf(F key) {
      return ofNullable(values.get(key)).orElseThrow(() -> new IllegalArgumentException(format(ERROR_MESSAGE, type.getName(), key)));
   }
}
