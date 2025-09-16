public class PaymentReceiptNumber {

    @InvocableMethod(label='Increment Receipt Number ')
    public static List<decimal> incrementNumber()
    {
        List<decimal> currentReceiptNumber = new List<decimal>();
        ReceiptNumber__c ct = ReceiptNumber__c.getOrgDefaults();
        currentReceiptNumber.add(ct.LastReceiptNumber__c);
        ct.LastReceiptNumber__c += 1;
        update ct;
        
        return currentReceiptNumber;
    }
}