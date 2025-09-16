public class SDRControllerClass {
    
    public string recordId {get;set;}
    public Booking__c bookObj {get;set;}
    public String ProjectName {get;set;}
    public Decimal Total {get;set;}
    public Decimal Stamp {get;set;}
    public Project__c project{get;set;}
    Public User currentUser{get;set;}
    Public string ProjectHeader{get;set;}
    Public string ProjectFooter{get;set;}
    public String imageURLT{get;set;}
    public String imageURLB{get;set;}
    public decimal stampDutyPer{get;set;}
    public List<Pricing_Plan_Components__c>PricingPlan{get;set;}
    public SDR_Agent__c sdrAgentRcd {get;set;}
    
    public Decimal AgreementValue {get;set;}
    public Decimal StampDutyRoundOffValue {get;set;}
    public Decimal registraionChargedRoundOffValue {get;set;}
    public Decimal totalRoundOffValue {get;set;}
    public SDRControllerClass(){
        
    }
    /*public PageReference SDRControllerClass1() {

//recordId=ApexPages.currentPage().getParameters().get('id');
recordId='a0CC4000005SDQrMAO';
stampDutyPer=0;
loadDataInVfPage(recordId);  
}*/
    public PageReference SDRControllerClass1(){
        recordId=ApexPages.currentPage().getParameters().get('id');
        //recordId='a0CC4000008Ec42MAC';
        stampDutyPer=0;
        bookObj = new Booking__c();
        bookObj = [Select Id,Name,Registration_Charges__c,Floor_No__c,Unit_Number__c,Agreement_Value__c,Project_Name__c,Stamp_Duty__c,Related_Suggested_Property__c,Related_Suggested_Property__r.Unit__c,Related_Suggested_Property__r.Unit__r.Index__c,Related_Suggested_Property__r.Discount__c,Related_Opportunity__c,SDR_Agent__c From Booking__c where Id =: recordId];
        System.debug('bookObj:'+bookObj);
        system.debug('AgreementValue'+Integer.valueof(bookObj.Agreement_Value__c));
       AgreementValue =  roundOFFFigure(bookObj.Agreement_Value__c);
        //for get Stamp Duty percentage
        PricingHelper.PriceInfo priceInfo = PricingHelper.getPricing(bookObj.Related_Suggested_Property__r.Unit__c, bookObj.Related_Opportunity__c, null, new Map<String, Decimal>{ 'Basic Price' => bookObj.Related_Suggested_Property__r.Discount__c});
        system.debug('PriceInfo SDR Letter '+ priceInfo);
        PricingPlan = PriceInfo.PricingPlan;
        for(Pricing_Plan_Components__c p :PricingPlan)
        {
            if(p.Name=='Stamp Duty')
            {
                stampDutyPer =p.Price_age__c;
            }
            
        }
        
        //Stamp = (bookObj.Agreement_Value__c * 5)/100;
        //If Agreement value is higher than index value of Property
        if(bookObj.Related_Suggested_Property__r.Unit__r.Index__c<=bookObj.Agreement_Value__c){
            Stamp = (bookObj.Agreement_Value__c * stampDutyPer)/100;
        }
        //If Index value of property is higher than agreement value of booking
        else{
            Stamp = (bookObj.Related_Suggested_Property__r.Unit__r.Index__c * stampDutyPer)/100;
        }
        Stamp=Math.round(Stamp);
        StampDutyRoundOffValue =  roundOFFFigure(Stamp);
        registraionChargedRoundOffValue = roundOFFFigure(bookObj.Registration_Charges__c);
        //Total = bookObj.Agreement_Value__c + Stamp + bookObj.Registration_Charges__c;
        /* commented on 9-sept-2023
        Total = Stamp + bookObj.Registration_Charges__c;*/
        totalRoundOffValue = StampDutyRoundOffValue + registraionChargedRoundOffValue;
        Map<Id,Project__c> mapIdToProject = new Map<Id,Project__c>([Select Id,Name From Project__c]);
        if(mapIdToProject.size() > 0 && mapIdToProject.containsKey(bookObj.Project_Name__c)){
            ProjectName = mapIdToProject.get(bookObj.Project_Name__c).Name;
        }
        
        if(bookObj!=null && bookObj.Project_Name__c != null){
            project = [select Id,Project_Header__c,Project_Footer__c,Name,Builder_Organization__r.name,Postal_Code__c,Location__c,Sublocation__c,City__c,State__c,Project_Email__c,Project_Phone__c from Project__c where Id =:bookObj.Project_Name__c ];
        } 
        
        //for set SDR Agent Details
        if(bookObj!=null && bookObj.SDR_Agent__c != null){
            sdrAgentRcd=[Select Id,Name,Bank_Name__c,Branch_Name__c,Account_No__c,Account_Name__c,IFSC_Code__c,Account_Type__c From SDR_Agent__c Where Id=:bookObj.SDR_Agent__c ];
        }
        
        
        if(project <> null)
        {
            if(bookObj!=null && bookObj.Project_Name__c != null){                
                if(project.Project_Header__c!='')
                {
                    ProjectHeader=project.Project_Header__c; 
                }
                if(project.Project_Footer__c!='')
                {
                    ProjectFooter =project.Project_Footer__c; 
                }
            }            
        }   
        //get price details for update stamp duty amount
        Price_Details__c priceDeatilsRcd=[Select Id,Name,Booking__c,Amount__c,Charge_Group__c From Price_Details__c Where Booking__c=: recordId AND Charge_Group__c Like '%Stamp Duty%'];
        if(priceDeatilsRcd!=null){
            if(priceDeatilsRcd.Amount__c!=Stamp){
                System.debug('priceDeatilsRcd'+priceDeatilsRcd);
                Price_Details__c updatePriceDeatilsRcd=new Price_Details__c(Id=priceDeatilsRcd.Id);
                updatePriceDeatilsRcd.Amount__c=Stamp;
                if(updatePriceDeatilsRcd != null)
                {
                    try{
                        update updatePriceDeatilsRcd;
                    }
                      catch(Exception ex)
                      {
                          system.debug('Error'+ex.getMessage());
                      }
                }
              
            }
        }
        return null;
    }
    public Decimal roundOFFFigure(Decimal originalNumber )
    {
        String lastDigitString = String.valueof(originalNumber).substringBefore('.');
        system.debug('lastDigitString'+lastDigitString);
        lastDigitString = lastDigitString.right(2);
        system.debug('lastDigitString'+lastDigitString);
        
        Integer lastDigit =  Integer.valueof(lastDigitString);
        system.debug('lastDigit'+lastDigit);
        if(lastDigit < 50 && lastDigit != 00  )
        {
            originalNumber = originalNumber + 50;
            system.debug('originalNumber'+originalNumber);
            
        }    
        Decimal roundedNumber = Math.round(originalNumber / 100) * 100;
        system.debug('roundedNumber'+roundedNumber);
        return roundedNumber;
    }
  
    
}