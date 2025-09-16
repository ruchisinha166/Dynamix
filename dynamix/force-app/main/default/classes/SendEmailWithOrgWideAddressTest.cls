@isTest
public class SendEmailWithOrgWideAddressTest {
    @isTest
    static void testSendEmail() {
        EmailTemplate testEmailTemplate = new EmailTemplate(
            DeveloperName = 'Test_Email_Template',
            Subject = 'Test Subject',
            FolderId = UserInfo.getUserId(), 
            TemplateType = 'text',
            Name = 'Test Email Template', 
            Body = 'Test Plain Body' 
        );
        insert testEmailTemplate;

        String emailTempId = testEmailTemplate.Id;
        String htmlBody = '<html><body>Test HTML Body</body></html>';
        String plainBody = 'Test Plain Body';
        List<String> toMailList = new List<String>{'test@example.com'};
        List<String> ccMailList = new List<String>{'cc_test@example.com'};
        OrgWideEmailAddress orgWideAddress = [SELECT Id FROM OrgWideEmailAddress LIMIT 1];

        Test.startTest();
        SendEmailWithOrgWideAddress.SendEmail(emailTempId, htmlBody, plainBody, toMailList, ccMailList, orgWideAddress.Id);
        Test.stopTest();
    }
}