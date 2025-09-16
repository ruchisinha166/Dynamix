public class BankLoanDetailsTriggerHandler {
    public static Boolean isExecutingUpdateLoanClosure = false;
    public static Boolean isExecutingUpdateLoanStatus = false;
    public static void UpdateLoanDate1(List<Bank_Loan_Details__c> listOfBooking){
        for(Bank_Loan_Details__c bookObj : listOfBooking){
            if(bookObj.Bank_Returned_NOC_Uploaded__c == true && bookObj.Bank_Returned_ROC_Uploaded__c == true && bookObj.Loan_Closure_Letter_Uploaded__c == true){
                bookObj.Loan_Closed_Date__c = System.now();
            }
            //if(bookObj.Sanction_Status__c == 'Sanctioned' || bookObj.Sanction_Status__c == 'Rejected'){
            //bookObj.Loan_Closed_Date__c = System.now();
            //System.debug('bookObj.Loan_Closed_Date__c---------->'+bookObj.Loan_Closed_Date__c);
            //Commented this lines because client requirement is that Loan_Closed_Date__c should be update when this document will be uploaded i.e Bank Returned NOC, Bank Returned ROC,Loan Closure Letter Uploaded.
            // In this condition whenever the last document will be uploaded then Loan Closed Date Auto-populate. 8/11/2023
            //}
        }
    }
    public static void UpdateLoanDate(List<Bank_Loan_Details__c> listOfBooking,Map<Id,Bank_Loan_Details__c> oldMapBooking){
        for(Bank_Loan_Details__c bookObj : listOfBooking){
            if((bookObj.Sanction_Status__c == 'Sanctioned' || bookObj.Sanction_Status__c == 'Rejected') && bookObj.Sanction_Status__c != oldMapBooking.get(bookObj.Id).Sanction_Status__c){
                //bookObj.Loan_Closed_Date__c = System.now();
                //System.debug('bookObj.Loan_Closed_Date__c---------->'+bookObj.Loan_Closed_Date__c);
            }
        }
    }
    public static void SanctionedValidation(List<Bank_Loan_Details__c> listOfBooking, Map<Id,Bank_Loan_Details__c> oldMap){
        Boolean check = false;
        set<Id> BankLoanIdSet = new set<Id>();
        for(Bank_Loan_Details__c objBankDetail : listOfBooking){
            if(objBankDetail.Sanction_Status__c == 'Sanctioned' && oldMap.get(objBankDetail.Id).Sanction_Status__c != 'Sanctioned'){
                BankLoanIdSet.add(objBankDetail.Id);
                System.debug('BankLoanIdSet---------->'+BankLoanIdSet);
            }
        }
        List<Bank_Loan_Details__c> LoanList = [Select Id,Name, Booking__c, Booking__r.Primary_Loan_Details__c,Booking__r.Secondary_Loan_Details__c From Bank_Loan_Details__c Where Id in : BankLoanIdSet];
        for(Bank_Loan_Details__c objLoan : LoanList){
            if(objLoan.Booking__r.Primary_Loan_Details__c != null && objLoan.Booking__r.Secondary_Loan_Details__c != null){
                check = true; 
            }
        }
        if(check == true){
            for(Bank_Loan_Details__c objBankDetail : listOfBooking){
                objBankDetail.addError('Sanction limit exceeded');
            }
        }
    }
    public static void updateLoanClosure(List<Bank_Loan_Details__c> loan) {
        if (!isExecutingUpdateLoanClosure) {
            isExecutingUpdateLoanClosure = true;
            List<Bank_Loan_Details__c> recordsToUpdateList = New List<Bank_Loan_Details__c>();
            Set<Id> recordsToUpdate = new Set<Id>();
            for (Bank_Loan_Details__c bnLoan : loan) {
                System.debug('bnLoan--' + bnLoan);
                if (bnLoan.Loan_Remarks__c != null && 
                    bnLoan.Loan_Closure_Reason__c!= null && 
                    bnLoan.Loan_Status__c != 'Closed' &&
                    bnLoan.Bank_Returned_NOC_Uploaded__c == true &&
                    bnLoan.Bank_Returned_ROC_Uploaded__c == true &&
                    bnLoan.Loan_Closure_Letter_Uploaded__c == true) 
                {
                    bnLoan.Loan_Closed_Date__c = System.now();
                    bnLoan.Loan_Status__c = 'Closed';
                    recordsToUpdateList.add(bnLoan);
                    System.debug('recordsToUpdateList---->'+recordsToUpdateList);
                }else if (bnLoan.Loan_Closure_Reason__c == null || bnLoan.Loan_Remarks__c == null) {
                    if (bnLoan.Loan_Status__c == 'Closed') {
                        bnLoan.addError('Please add values in Loan Closure Reason and Remark.');
                    }
                }
                
            }
        }
    }
    public static void updateLoanStatus(List<Bank_Loan_Details__c> loans, Map<id,Bank_Loan_Details__c> mapOfOldLoan) {
        if (!isExecutingUpdateLoanStatus) {
            isExecutingUpdateLoanStatus = true;
            List<Bank_Loan_Details__c> loansToUpdate = new List<Bank_Loan_Details__c>();
            
            for (Bank_Loan_Details__c loan : loans) {
                system.debug('status-- '+loan.Loan_Status__c);
                if(mapOfOldLoan.get(loan.id).Sanction_Status__c != loan.Sanction_Status__c )
                {
                    if (loan.Sanction_Status__c == 'Sanctioned') {
                        // Bank_Loan_Details__c bankloan  = New Bank_Loan_Details__c();
                        loan.Loan_Status__c = 'Sanctioned'; 
                        loansToUpdate.add(loan);
                        System.debug('loan.Loan_Status__c ---->'+loan.Loan_Status__c);
                    }
                    if (loan.Sanction_Status__c == 'In Progress') {
                        loan.Loan_Status__c = 'In Progress';
                        loansToUpdate.add(loan);
                    }
                    if (loan.Sanction_Status__c == 'Rejected' ) {
                        loan.Loan_Status__c = 'Rejected'; 
                        loansToUpdate.add(loan);
                    } 
                }
                
            }
            if (!loansToUpdate.isEmpty()) {
                //update loansToUpdate;
            }
            // isExecuting = false;
        }
    }
    public static void handleLoanStatus(List<Bank_Loan_Details__c> newLoans  /*, Map<Id, Bank_Loan_Details__c> oldMap*/) {
        
        Set<Id> bookingIds = new Set<Id>();
        
        for(Bank_Loan_Details__c det: newLoans){
            bookingIds.add(det.Booking__c);
        }
        
        List<Bank_Loan_Details__c> loans = [
            SELECT Booking__c, Id, Pari_Passu__c,Loan_Status__c
            FROM Bank_Loan_Details__c 
            WHERE Booking__c IN :bookingIds
        ];
        
        Map<Id,List<Integer>> bookingLoanmap = new Map<Id,List<Integer>>();
        
        for (Bank_Loan_Details__c loan : loans) {
            system.debug('loan--'+loan);
            if(bookingLoanmap.containsKey(loan.Booking__c)){
                if(loan.Loan_Status__c == 'Sanctioned'){
                    bookingLoanmap.get(loan.Booking__c)[1]+=1;
                    System.debug('bookingLoanmap-------->'+bookingLoanmap);
                }
                if(loan.Pari_Passu__c == True){
                    bookingLoanmap.get(loan.Booking__c)[0]=1;
                    System.debug('bookingLoanmap-------->'+bookingLoanmap);
                }
            }
            else{
                if(loan.Loan_Status__c == 'Sanctioned' && loan.Pari_Passu__c == True){
                    bookingLoanmap.put(loan.Booking__c,new List<Integer>{1,1});
                    System.debug('bookingLoanmap-------->'+bookingLoanmap);
                }
                else if(loan.Loan_Status__c == 'Sanctioned'){
                    bookingLoanmap.put(loan.Booking__c,new List<Integer>{0,1});
                    System.debug('bookingLoanmap-------->'+bookingLoanmap);
                }
                else if(loan.Pari_Passu__c == True){
                    bookingLoanmap.put(loan.Booking__c,new List<Integer>{1,0});
                    System.debug('bookingLoanmap-------->'+bookingLoanmap);
                }
                else{
                    bookingLoanmap.put(loan.Booking__c,new List<Integer>{0,0});
                    System.debug('bookingLoanmap-------->'+bookingLoanmap);
                }                
            }
        }
        
        for(Bank_Loan_Details__c loan: newLoans){
            if(loan.Loan_Status__c == 'Sanctioned'){
                if(!bookingLoanmap.containsKey(loan.Booking__c)){
                    continue;
                }
                
                if(bookingLoanmap.get(loan.Booking__c)[0] == 0){
                    if(bookingLoanmap.get(loan.Booking__c)[1] >= 1){
                        loan.addError('You can have only one "Sanctioned" loan record for this Booking when "Pari Passu" is not checked.');
                    }
                }
                if(bookingLoanmap.get(loan.Booking__c)[0] == 1){
                    if(bookingLoanmap.get(loan.Booking__c)[1] >= 2){
                        loan.addError('The booking has two active loan records, kindly close a loan record to proceed.');
                    }
                }                
            }
            if(loan.Pari_Passu__c == True){
                if(!bookingLoanmap.containsKey(loan.Booking__c)){
                    continue;
                    System.debug('bookingLoanmap-------->'+bookingLoanmap);
                }
                
                if(bookingLoanmap.get(loan.Booking__c)[0] == 1){
                    loan.addError('You cannot add another Pari Passu loan');
                }                
            }
        }
        
    }
    public static void handleLoanStatusUpdate(List<Bank_Loan_Details__c> newLoans , Map<Id, Bank_Loan_Details__c> oldMap) {
        
        Set<Id> bookingIds = new Set<Id>();
        
        for(Bank_Loan_Details__c det: newLoans){
            bookingIds.add(det.Booking__c);
        }
        
        List<Bank_Loan_Details__c> loans = [
            SELECT Booking__c, Id, Pari_Passu__c,Loan_Status__c
            FROM Bank_Loan_Details__c 
            WHERE Booking__c IN :bookingIds
        ];
        
        Map<Id,List<Integer>> bookingLoanmap = new Map<Id,List<Integer>>();
        
        for (Bank_Loan_Details__c loan : loans) {
            system.debug('loan--'+loan);
            if(bookingLoanmap.containsKey(loan.Booking__c)){
                if(loan.Loan_Status__c == 'Sanctioned'){
                    bookingLoanmap.get(loan.Booking__c)[1]+=1;
                }
                if(loan.Pari_Passu__c == True){
                    bookingLoanmap.get(loan.Booking__c)[0]=1;
                }
            }
            else{
                if(loan.Loan_Status__c == 'Sanctioned' && loan.Pari_Passu__c == True){
                    bookingLoanmap.put(loan.Booking__c,new List<Integer>{1,1});
                }
                else if(loan.Loan_Status__c == 'Sanctioned'){
                    bookingLoanmap.put(loan.Booking__c,new List<Integer>{0,1});
                }
                else if(loan.Pari_Passu__c == True){
                    bookingLoanmap.put(loan.Booking__c,new List<Integer>{1,0});
                }
                else{
                    bookingLoanmap.put(loan.Booking__c,new List<Integer>{0,0});
                }                
            }
        }
        
        for(Bank_Loan_Details__c loan: newLoans){
            if(loan.Pari_Passu__c == True && oldMap.get(loan.Id).Pari_Passu__c != True){
                if(bookingLoanmap.get(loan.Booking__c)[0] == 1){
                    loan.addError('You cannot add another Pari Passu loan');
                }                
            }
            if(loan.Pari_Passu__c != True && oldMap.get(loan.Id).Pari_Passu__c == True){
                Id userId = userinfo.getUserId();
                User userDetails =[SELECT Id, Name, Email, Profile.Name, UserRole.Name FROM User where Id=:userId ];
                if(userDetails.Profile.Name != 'System Administrator'){
                    loan.addError('You cannot update Pari Passu ... Contact your admin');
                }else{
                    if(bookingLoanmap.get(loan.Booking__c)[1] >= 2){
                        loan.addError('You cannot remove Pari Passu as there are two sanctioned loans');
                    }   
                }                
            }
            
            if(loan.Loan_Status__c == 'Sanctioned' && oldMap.get(loan.Id).Loan_Status__c != 'Sanctioned'){
                system.debug('updated--'+loan);
                if(bookingLoanmap.get(loan.Booking__c)[0] == 0){
                    if(bookingLoanmap.get(loan.Booking__c)[1] >= 1){
                        loan.addError('You can have only one "Sanctioned" loan record for this Booking when "Pari Passu" is not checked.');
                    }
                }
                if(bookingLoanmap.get(loan.Booking__c)[0] == 1){
                    if(bookingLoanmap.get(loan.Booking__c)[1] >= 2){
                        loan.addError('The booking has two active loan records, kindly close a loan record to proceed.');
                    }
                }                
            }
        }
    }
   
}