package Annotations;

import java.lang.annotation.*;

@Argument
@Repeatable(CharValues.class)
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.FIELD)
public @interface CharValue {
   String name();
   char[] value();
}
