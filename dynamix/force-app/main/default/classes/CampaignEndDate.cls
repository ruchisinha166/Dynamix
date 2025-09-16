public class CampaignEndDate implements Schedulable {
    public void execute(SchedulableContext sc) {
        List<Campaign> campList = [Select Id,Name,Project__r.Name,StartDate,EndDate,Source__c from Campaign];
        UserRole urole = [SELECT Id, DeveloperName FROM UserRole where DeveloperName = 'Marketing_Executive'];
        User usr = [SELECT Id, Username, Email, UserRoleId FROM User where UserRoleId =: urole.Id];
        for(Campaign camp:campList){
            if(camp.EndDate == system.today()){
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                // Set the recipients of the email
                email.setToAddresses(new List<String>{usr.Email});
                // Set the email subject
                email.setSubject('Campaign Close Date');
                // Set the body of the email
                string body = 'This Email is generated to remind you that Campaign: '+camp.Name+' has reached its closed date today.';
                body += '<style>table {border-collapse: collapse;} th, td {border: 1px solid black;padding: 8px;}</style>';
                body += '<table><tr><th colspan=2>Campaign Details</th></tr> <br><tr><td> Name: </td><td>'+camp.Name+'</td></tr><br><tr><td>Project: </td><td>'+camp.Project__r.Name+'</td></tr><br>';
                body += '<tr><td>Start Date: </td><td>'+dateFormat(camp.StartDate)+'</td></tr><br><tr><td>End Date: </td><td>'+dateFormat(camp.EndDate)+'</td></tr><br><tr><td>Source: </td><td>'+camp.Source__c+'</td></tr></table>';
                email.setHtmlbody(body);
                // Send the email
                Messaging.SendEmailResult[] sendResults = Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ email });
                // Check if the email was sent successfully
                if (sendResults[0].isSuccess()) {
                    System.debug('Email sent successfully.');
                } else {
                    System.debug('Email sending failed. Error: ' + sendResults[0].getErrors()[0].getMessage());
                }
                CustomNotificationType notificationType = 
                    [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='Campaign_End_Date_Notification'];
                
                // Create a new custom notification
                Messaging.CustomNotification notification = new Messaging.CustomNotification();
                
                // Set the contents for the notification
                notification.setTitle('Apex Custom Notification');
                notification.setBody('The notifications are coming from INSIDE the Apex!');
                
                // Set the notification type and target
                notification.setNotificationTypeId(notificationType.Id);
                notification.setTargetId(camp.id);
                
                // Actually send the notification
                try {
                    notification.send(new Set<String>{usr.Id});
                    System.debug('Notification Sent Successfully');
                }
                catch (Exception e) {
                    System.debug('Problem sending notification: ' + e.getMessage());
                }
            }
        }
    }
    
    public static string dateFormat(Date dt){
        String dateFull  = String.valueOf(dt);
        String[] DOBDate     = dateFull.split('-');
        String yyyy = DOBDate[0]; 
        String mm = DOBDate[1];
        String dd = DOBDate[2];
        system.debug('DOBDate'+yyyy+ '/'+mm+'/'+dd);
        string dob = dd+ '/'+mm+'/'+yyyy;
        return dob;
    }
}