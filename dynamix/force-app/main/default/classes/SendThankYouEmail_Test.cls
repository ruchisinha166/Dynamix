@isTest (SeeAllData=true)
public class SendThankYouEmail_Test {

    @isTest static void sendThanksEmailTest(){
        
         Id PersonRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        Account accountObject = new Account();
        accountObject.FirstName = 'test';
        accountObject.LastName = 'Account';
        accountObject.BillingCountry = 'India';
        accountObject.Phone = '455546565';
        accountObject.RecordTypeId = PersonRecId;
        accountObject.PersonEmail = 'dynamix.project@gmail.com';
        accountObject.Aadhar_Uploaded__pc = true;
        accountObject.PAN_Card_Uploaded__pc = true;
        insert accountObject;
        
        
        
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate limit 1];
        
        
        List<SendThankYouEmail.Requests>  sendEmailList = New List<SendThankYouEmail.Requests>();
        
        SendThankYouEmail.Requests SendEmail = New SendThankYouEmail.Requests();
        SendEmail.accountId = accountObject.Id;
        SendEmail.emailTemplateId = emailTemplate.Id;
        SendEmail.personEmailAddress = accountObject.PersonEmail;
        sendEmailList.add(SendEmail);
        
        Test.startTest();
        SendThankYouEmail.execute(sendEmailList);
        SendThankYouEmail.SendEmail(accountObject.Id, accountObject.OwnerId, emailTemplate.Id);
        Test.stopTest();
        
    }
}