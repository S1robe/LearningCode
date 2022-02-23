package Annotations;

import java.lang.annotation.*;
import java.text.SimpleDateFormat;
import java.util.Date;

@Argument
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.FIELD)
@Value(name = "${name}", value = "${value}", type = Date.class, factory = SimpleDateFormat.class, factoryMethod = "parse")
@Value(name = "factoryArgument", value = "${format}")
public @interface DateValue {
   String name();
   String value();
   String format() default "yyyy-MM-dd'T'HH:mm:ss.SSSZ"; // example: 2001-07-04T12:08:56.235-0700
}
