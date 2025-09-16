public class EOI_CA_Number {
    @InvocableMethod(label='Increment EOI/CA Number')
    public static List<decimal> incrementNumber()
    {
        List<decimal> currentReceiptNumber = new List<decimal>();
        ReceiptNumber__c ct = ReceiptNumber__c.getOrgDefaults();
        currentReceiptNumber.add(ct.EOI_CA_Number__c);
        ct.EOI_CA_Number__c += 1;
        update ct;
        
        return currentReceiptNumber;
    }
    
}