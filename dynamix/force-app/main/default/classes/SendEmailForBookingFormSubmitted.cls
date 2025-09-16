public class SendEmailForBookingFormSubmitted {
    @InvocableMethod(label='Send Email For BookingForm Submitted by Customer')
    public static void execute(List<Request> Requests){
        Booking__c bookingRcd = [select Id, Name,Unit_Number__c,Primary_Applicant__c,Project_Name_Formulla__c,Primary_Applicant__r.PersonMobilePhone,Related_Opportunity__c,Related_Opportunity__r.Owner.Name,Related_Opportunity__r.Owner.Email,Related_Opportunity__r.Owner.Id,Project_Name__c,Owner.Email,Owner.Id,Owner.Name,Primary_Applicant_Name_Formulla__c FROM Booking__c WHERE Id=: Requests[0].bookingRecodId];
        System.debug('bookingRcd:'+bookingRcd);
        
        // Get the Id for our custom notification type
        CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='Booking_Form_Notification']; 
        String notificationTitle='Booking Form Submitted';
        String notificationBody='Booking Form has been Submitted by Customer for Booking: '+ bookingRcd.Name;
        String targetId=bookingRcd.Id;
        Set <String> recipientIds= new Set <String> ();
        
        EmailTemplate emailTemplate = [select Id,Name, Subject, HtmlValue, Body,DeveloperName from EmailTemplate where DeveloperName = 'Booking_Form_Submitted_Email' LIMIT 1];
        System.debug('emailTemplate:'+emailTemplate);
        
        if(bookingRcd.Project_Name__c!=null){
            Project__c projectRecod=[Select Id,Name,Site_Head__c,Site_Head__r.Id,Site_Head__r.Email,Site_Head__r.Name From Project__c Where Id=:bookingRcd.Project_Name__c];
            //For Send Bell Notification to Site Head                             
            if(projectRecod.Site_Head__r.Id!=null){
                recipientIds.add(projectRecod.Site_Head__r.Id);
            } 
            
            //for send email to Site Head
            if(emailTemplate!=null && projectRecod.Site_Head__r.Email!=null){
                String htmlBody2 = emailTemplate.HtmlValue;
                htmlBody2 = htmlBody2.replace('{!Name}', bookingRcd.Name);
                if(projectRecod.Site_Head__r.Name != null){
                    htmlBody2 = htmlBody2.replace('{!User}', projectRecod.Site_Head__r.Name);
                }
                if(bookingRcd.Project_Name_Formulla__c != null){
                    htmlBody2 = htmlBody2.replace('{!Project}', bookingRcd.Project_Name_Formulla__c);
                }
                if(bookingRcd.Unit_Number__c != null){
                    htmlBody2 = htmlBody2.replace('{!Unit}', bookingRcd.Unit_Number__c);
                }
                String plainBody2 = emailTemplate.Body;
                plainBody2 = plainBody2.replace('{!Name}', bookingRcd.Name); 
                if(projectRecod.Site_Head__r.Name != null){
                    plainBody2 = plainBody2.replace('{!User}', projectRecod.Site_Head__r.Name);
                }
                if(bookingRcd.Project_Name_Formulla__c != null){
                    plainBody2 = plainBody2.replace('{!Project}', bookingRcd.Project_Name_Formulla__c); 
                }
                if(bookingRcd.Unit_Number__c != null){
                    plainBody2 = plainBody2.replace('{!Unit}', bookingRcd.Unit_Number__c);
                }
                if(emailTemplate!=null && projectRecod.Site_Head__r.Email!=null){                
                    List<String> emailList2=new List<String>();           
                    emailList2.add(projectRecod.Site_Head__r.Email);            
                    SendEmailandBellNotificationUtility.SendEmail(emailTemplate.Id,htmlBody2,plainBody2,emailList2,null);           
                }
            }
        }
        
        //For Send Bell Notification to SM (Opportunity Owner)
        if(bookingRcd.Related_Opportunity__r.Owner.Id!=null){
            recipientIds.add(bookingRcd.Related_Opportunity__r.Owner.Id);
        }     
        //For Send Bell Notification to RM (Booking Owner)
        if(bookingRcd.Owner.Id!=null){
            recipientIds.add(bookingRcd.Owner.Id);
        }                 
        if(recipientIds.size()>0){
            SendEmailandBellNotificationUtility.SendBellNotification(notificationType.Id, notificationTitle, notificationBody, targetId, recipientIds);
        }
        
        //for send email to booking Owner (RM)
        if(emailTemplate!=null && bookingRcd.Owner.Email!=null){
            String htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{!Name}', bookingRcd.Name);
            if(bookingRcd.Owner.Name != null){
                htmlBody = htmlBody.replace('{!User}', bookingRcd.Owner.Name);
            }
            if(bookingRcd.Project_Name_Formulla__c != null){
                htmlBody = htmlBody.replace('{!Project}', bookingRcd.Project_Name_Formulla__c);
            }
            if(bookingRcd.Unit_Number__c != null){
                htmlBody = htmlBody.replace('{!Unit}', bookingRcd.Unit_Number__c);
            }
            String plainBody = emailTemplate.Body;
            plainBody = plainBody.replace('{!Name}', bookingRcd.Name); 
            if(bookingRcd.Owner.Name != null){
                plainBody = plainBody.replace('{!User}', bookingRcd.Owner.Name);
            }
            if(bookingRcd.Project_Name_Formulla__c != null){
                plainBody = plainBody.replace('{!Project}', bookingRcd.Project_Name_Formulla__c); 
            }
            if(bookingRcd.Unit_Number__c != null){
                plainBody = plainBody.replace('{!Unit}', bookingRcd.Unit_Number__c);
            }
            if(emailTemplate!=null && bookingRcd.Owner.Email!=null){                
                List<String> emailList=new List<String>();           
                emailList.add(bookingRcd.Owner.Email);            
                SendEmailandBellNotificationUtility.SendEmail(emailTemplate.Id,htmlBody,plainBody,emailList,null);           
            }
        }
        //for send email to Opportunity Owner (SM)
        if(emailTemplate!=null && bookingRcd.Related_Opportunity__r.Owner.Email!=null){
            
            String htmlBody1 = emailTemplate.HtmlValue;
            htmlBody1 = htmlBody1.replace('{!Name}', bookingRcd.Name);
            if(bookingRcd.Related_Opportunity__r.Owner.Name != null){
                htmlBody1 = htmlBody1.replace('{!User}',bookingRcd.Related_Opportunity__r.Owner.Name);
            }
            if(bookingRcd.Project_Name_Formulla__c != null){
                htmlBody1 = htmlBody1.replace('{!Project}', bookingRcd.Project_Name_Formulla__c);
            }
            if(bookingRcd.Unit_Number__c != null){
                htmlBody1 = htmlBody1.replace('{!Unit}', bookingRcd.Unit_Number__c);
            }
            String plainBody1 = emailTemplate.Body;
            plainBody1 = plainBody1.replace('{!Name}', bookingRcd.Name); 
            if(bookingRcd.Related_Opportunity__r.Owner.Name != null){
                plainBody1 = plainBody1.replace('{!User}', bookingRcd.Related_Opportunity__r.Owner.Name);
            }
            if(bookingRcd.Project_Name_Formulla__c != null){
                plainBody1 = plainBody1.replace('{!Project}', bookingRcd.Project_Name_Formulla__c); 
            }
            if(bookingRcd.Unit_Number__c != null){
                plainBody1 = plainBody1.replace('{!Unit}', bookingRcd.Unit_Number__c);
            }
            if(emailTemplate!=null && bookingRcd.Related_Opportunity__r.Owner.Email!=null){                
                List<String> emailList1=new List<String>();           
                emailList1.add(bookingRcd.Related_Opportunity__r.Owner.Email);            
                SendEmailandBellNotificationUtility.SendEmail(emailTemplate.Id,htmlBody1,plainBody1,emailList1,null);           
            }
        }
        
        //Email to S&M Head
        //String SMHeadUserName = Label.S_M_Head;
        //User SMHeadRoleObjUser = [Select Id,Name,Email From User Where UserName =: SMHeadUserName AND UserRoleId =: [select id,Name,DeveloperName from UserRole where DeveloperName =: 'S_M_Head'].Id AND isActive =: true Limit 1];
        List<User> SMHeadRoleObjUserList = [Select Id,Name,Email,UserRole.DeveloperName From User Where UserRole.DeveloperName =: 'S_M_Head' AND isActive =: true];
        System.debug('SMHeadRoleObjUserList'+SMHeadRoleObjUserList);
        List<String> smHeadUsersEmailList=new List<String>();
        if(SMHeadRoleObjUserList.size()>0){
            for(User userRcd:SMHeadRoleObjUserList){
                if(userRcd.Email!=null){
                    smHeadUsersEmailList.add(userRcd.Email);
                }
            } 
        }
        System.debug('smHeadUsersEmailList===>'+smHeadUsersEmailList);
        if(emailTemplate!=null && smHeadUsersEmailList.size()>0){            
            String htmlBody1 = emailTemplate.HtmlValue;
            htmlBody1 = htmlBody1.replace('{!Name}', bookingRcd.Name);
            //if(SMHeadRoleObjUser.Name != null){
            htmlBody1 = htmlBody1.replace('{!User}','S&M Head User');
            //}
            if(bookingRcd.Project_Name_Formulla__c != null){
                htmlBody1 = htmlBody1.replace('{!Project}', bookingRcd.Project_Name_Formulla__c);
            }
            if(bookingRcd.Unit_Number__c != null){
                htmlBody1 = htmlBody1.replace('{!Unit}', bookingRcd.Unit_Number__c);
            }
            String plainBody1 = emailTemplate.Body;
            plainBody1 = plainBody1.replace('{!Name}', bookingRcd.Name); 
            //  if(SMHeadRoleObjUser.Name != null){
            plainBody1 = plainBody1.replace('{!User}', 'S&M Head User');
            // }
            if(bookingRcd.Project_Name_Formulla__c != null){
                plainBody1 = plainBody1.replace('{!Project}', bookingRcd.Project_Name_Formulla__c); 
            }
            if(bookingRcd.Unit_Number__c != null){
                plainBody1 = plainBody1.replace('{!Unit}', bookingRcd.Unit_Number__c);
            }
            // if(emailTemplate!=null && SMHeadRoleObjUser.Email!=null){                
            //      List<String> emailList1=new List<String>();           
            //      emailList1.add(SMHeadRoleObjUser.Email);            
            SendEmailandBellNotificationUtility.SendEmail(emailTemplate.Id,htmlBody1,plainBody1,smHeadUsersEmailList,null);           
            // }
        }
        
        //For Send WhatsApp Message
        communicat_o__Registered_Template__mdt regWhatEmailTemp=[Select Id,QualifiedApiName,label From communicat_o__Registered_Template__mdt Where label=:'WhatsApp Booking Form Submit' Limit 1];
        System.debug('regWhatEmailTemp:'+regWhatEmailTemp);
        if(regWhatEmailTemp!=null){
            String recipientAddress=bookingRcd.Primary_Applicant__r.PersonMobilePhone;
            String recipientId=bookingRcd.Primary_Applicant__c;
            String emailTemplateId=String.valueOf(regWhatEmailTemp.Id).substring(0, 15);
            String relatedToId=bookingRcd.Id;
            System.debug('emailTemplateId:'+emailTemplateId);
            if(recipientAddress!=null && recipientId!=null && emailTemplateId!=null){
                SendWhatsAppMessageUtility.SendMessage(recipientAddress, recipientId, emailTemplateId,relatedToId);
            }
        }
        //for Send SMS
        EmailTemplate smsEmailTemp=[Select Id,Name,HtmlValue From EmailTemplate Where Name='SMS Booking Form Submit' Limit 1];
        if(smsEmailTemp!=null && bookingRcd.Primary_Applicant__r.PersonMobilePhone!=null){
            String templateBody=smsEmailTemp.HtmlValue;
            String mobileNumber=bookingRcd.Primary_Applicant__r.PersonMobilePhone;
            templateBody = templateBody.replace('{{{Booking__c.Primary_Applicant_Name_Formulla__c}}}',bookingRcd.Primary_Applicant_Name_Formulla__c);
            templateBody = templateBody.replace('{{{Booking__c.Booking_Owner_Email__c}}}',bookingRcd.Owner.Email);
            templateBody=templateBody.stripHtmlTags();
            System.debug('templateBody:'+templateBody);
            SendSMSUtility.sendSMS(templateBody,mobileNumber,'DYNAMX');
        }
        
    }
    public class Request {
        @InvocableVariable(label='Booking Record Id' required=true)
        public Id bookingRecodId;
    }
}