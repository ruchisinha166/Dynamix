public class SFValidId {
    static String CHARS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ012345';
//System.debug(SFValidId.repairCasing('A0K1E00000BR5IBEAB'));
 public static List<Boolean> getBitPattern(String c)
{
    Integer index = CHARS.indexOf(c.toUpperCase());
    List<Boolean> result = new List<Boolean>();
    for (Integer bitNumber = 0; bitNumber < 5; bitNumber++)
        result.add((index & (1 << bitNumber)) != 0);
    return result;
}
 public static String repairCasing(String input)
{
    if (String.isBlank(input) || input.length() != 18) return input;

    List<Boolean> toUpper = new List<Boolean>();
    toUpper.addAll(getBitPattern(String.valueOf(input.substring(15, 16))));
    toUpper.addAll(getBitPattern(String.valueOf(input.substring(16, 17))));
    toUpper.addAll(getBitPattern(String.valueOf(input.substring(17, 18))));

    String output = '';
    for (Integer i = 0; i < 15; i++)
    {
        String c = String.valueOf(input.substring(i, i+1));
        output += toUpper[i] ? c.toUpperCase() : c.toLowerCase();
    }
    output += input.substring(15, 18).toUpperCase();
    return output;
}

}