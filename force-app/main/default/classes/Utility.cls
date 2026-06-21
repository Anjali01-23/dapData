public class Utility {
 public static String GetCRONExpression(Datetime dt) {
   return ('' + dt.second() + ' ' + dt.minute() + ' ' + dt.hour() + ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year());
}
}