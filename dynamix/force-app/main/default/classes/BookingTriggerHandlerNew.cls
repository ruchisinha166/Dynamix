public class BookingTriggerHandlerNew {
    
    public static void updateBrokerage(List<Booking__c> newBookings) {
        if (newBookings.isEmpty()) return;
        
        Set<Id> channelPartnerIds = new Set<Id>();
        Set<Id> projectIds = new Set<Id>();
        Set<Id> ladderIds = new Set<Id>();
        Set<Id> PrimaryApplicant = new Set<Id>();
        Set<Id> bookingIds = new Set<Id>();
        map <id,decimal> agreementMap  = new map <id,decimal> ();
        
        for (Booking__c bk : newBookings) {
            if (bk.Channel_Partner__c != null) {
                channelPartnerIds.add(bk.Channel_Partner__c);
            }
            if (bk.Project_Name__c != null) {
                projectIds.add(bk.Project_Name__c);
            }
            if (bk.Brokerage_Ladder__c != null) {
                ladderIds.add(bk.Brokerage_Ladder__c);
            }
            if(bk.Agreement_Value__c != null){
                agreementMap.put(bk.id,bk.Agreement_Value__c);
            }
            if (bk.Primary_Applicant__c != null) {
                PrimaryApplicant.add(bk.Primary_Applicant__c);
            }
            if (bk.Id != null){
                bookingIds.add(bk.Id);
            } 
        }
        
        if (channelPartnerIds.isEmpty() || projectIds.isEmpty() || ladderIds.isEmpty()) {
            return;
        }
        
        /* NRI code */
        Map<Id, Booking__c> bookingWithApplicantMap = new Map<Id, Booking__c>(
            [SELECT Id, Agreement_Value__c, Channel_Partner__c, Project_Name__c, Brokerage_Ladder__c,
             Primary_Applicant__r.NRI__c
             FROM Booking__c
             WHERE Id IN :bookingIds]
        );
        
        
        
        Map<String, Integer> cpProjectBookingCount = new Map<String, Integer>();
        for (AggregateResult ar : [
            SELECT Channel_Partner__c cpId, Project_Name__c projId, COUNT(Id) cnt
            FROM Booking__c
            WHERE Channel_Partner__c IN :channelPartnerIds
            AND Project_Name__c IN :projectIds
            AND Stage__c NOT IN (
                'Terminated',
                'Booking Cancelled – Refund Pending',
                'Booking Cancelled – Refund Ready',
                'Booking Cancelled -- Refund Done',
                'Cancellation Initiated'
            )
            GROUP BY Channel_Partner__c, Project_Name__c
        ]) {
            String key = String.valueOf(ar.get('cpId')) + '-' + String.valueOf(ar.get('projId'));
            cpProjectBookingCount.put(key, (Integer) ar.get('cnt'));
        }
        
        
        Map<Id, Brokerage_Ladder__c> ladderMap = new Map<Id, Brokerage_Ladder__c>(
            [SELECT Id, Percentage__c ,RecordType.Name, Brokerage_amount__c
             FROM Brokerage_Ladder__c 
             WHERE Id IN :ladderIds]
        );
        /* Active NRI ladders by CP */
        Map<Id, Brokerage_Ladder__c> activeNriLadders = new Map<Id, Brokerage_Ladder__c>(
            [SELECT Id, Percentage__c, RecordType.Name, Brokerage_amount__c
             FROM Brokerage_Ladder__c
             WHERE RecordType.Name = 'NRI'
             AND Active__c = true
            ]
        );
        
        Map<Id, List<Ladder_Band__c>> ladderBandMap = new Map<Id, List<Ladder_Band__c>>();
        for (Ladder_Band__c band : [
            SELECT Id, Minimum_Number__c, Maximum_Number__c, Additional_Brokerage__c, Brokerage_Ladder__c
            FROM Ladder_Band__c
            WHERE Brokerage_Ladder__c IN :ladderIds
            ORDER BY Minimum_Number__c ASC
        ]) {
            if (!ladderBandMap.containsKey(band.Brokerage_Ladder__c)) {
                ladderBandMap.put(band.Brokerage_Ladder__c, new List<Ladder_Band__c>());
            }
            ladderBandMap.get(band.Brokerage_Ladder__c).add(band);
        }
        
        List<Booking__c> bookingUpdates = new List<Booking__c>();
        List<Channel_Partner_Brokrage__c> cpInserts = new List<Channel_Partner_Brokrage__c>();
        
        Map<String, Channel_Partner_Brokrage__c> existingCPMap = new Map<String, Channel_Partner_Brokrage__c>();
        for (Channel_Partner_Brokrage__c cp : [
            SELECT Id, Booking__c, Channel_Partner__c, Project__c, Brokerage_Ladder__c
            FROM Channel_Partner_Brokrage__c
            WHERE Booking__c IN :bookingIds
        ]) {
            String key = cp.Booking__c + '-' + cp.Channel_Partner__c + '-' + cp.Project__c + '-' + cp.Brokerage_Ladder__c;
            existingCPMap.put(key, cp);
        }
        
        
        for (Booking__c bk : newBookings) {
            
            if (bk.Channel_Partner__c == null || bk.Project_Name__c == null || bk.Brokerage_Ladder__c == null) continue;
            
            String cpProjKey = String.valueOf(bk.Channel_Partner__c) + '-' + String.valueOf(bk.Project_Name__c);
            if (!cpProjectBookingCount.containsKey(cpProjKey)) continue;
            
            Integer totalBookings = cpProjectBookingCount.get(cpProjKey);
            
            Decimal ladderBasePct = (ladderMap.containsKey(bk.Brokerage_Ladder__c) && 
                                     ladderMap.get(bk.Brokerage_Ladder__c).Percentage__c != null) 
                ? ladderMap.get(bk.Brokerage_Ladder__c).Percentage__c 
                : 0;
            
            Decimal bandPct = 0;
            Id matchedBandId;
            
            if (ladderBandMap.containsKey(bk.Brokerage_Ladder__c)) {
                for (Ladder_Band__c band : ladderBandMap.get(bk.Brokerage_Ladder__c)) {
                    if (totalBookings >= band.Minimum_Number__c && totalBookings <= band.Maximum_Number__c) {
                        bandPct = (band.Additional_Brokerage__c != null) ? band.Additional_Brokerage__c : 0;
                        matchedBandId = band.Id;
                        break; 
                    }
                }
            }
            
            Decimal totalBrokeragePct = ladderBasePct + bandPct;
            bookingUpdates.add(new Booking__c(
                Id = bk.Id,
                Brokerage_Percentage__c = totalBrokeragePct
            ));
            
            if (matchedBandId != null) {
                String cpKey = bk.Id + '-' + bk.Channel_Partner__c + '-' + bk.Project_Name__c + '-' + bk.Brokerage_Ladder__c;
                system.debug('139');
                if (!existingCPMap.containsKey(cpKey) && bk.Agreement_Value__c != null && bk.Agreement_Value__c != 0) {
                    system.debug('141');
                    Decimal agreementval = agreementMap.get(bk.id);
                    system.debug('agreementval ======>'+agreementval);
                    Decimal bookingAmount = (bk.Agreement_Value__c != null) ? bk.Agreement_Value__c : 0;
                    Decimal totalBrokerageAmt = bookingAmount * (totalBrokeragePct / 100);
                    if(bk.Agreement_Value__c != null && bk.Agreement_Value__c != 0){
                        PreventRecursionClass.bookingBrokerageProcessed = true;
                        
                        Boolean isNRI = false;
                        if (bookingWithApplicantMap.containsKey(bk.Id) &&
                            bookingWithApplicantMap.get(bk.Id).Primary_Applicant__r != null &&
                            bookingWithApplicantMap.get(bk.Id).Primary_Applicant__r.NRI__c == true) {
                                isNRI = true;
                                
                            }    
                        
                        if (isNRI) {
                            for (Brokerage_Ladder__c nriLadder : activeNriLadders.values()) {
                                system.debug('nriLadder==>' +nriLadder);
                                // if (bk.Brokerage_Ladder__c == nriLadder.Id) {
                                Decimal nriPct = (nriLadder.Percentage__c != null) ? nriLadder.Percentage__c : 0;
                                Decimal nriAmt = bookingAmount * (nriPct / 100);
                                
                                String cpKey1 = bk.Id + '-'  + '-' + bk.Project_Name__c + '-' + nriLadder.Id;
                                if (!existingCPMap.containsKey(cpKey1)) {
                                    system.debug('cpKey1==>' +cpKey1);
                                    if(nriLadder.Percentage__c != null && nriLadder.Brokerage_amount__c == null){
                                        system.debug('line 173');
                                        cpInserts.add(new Channel_Partner_Brokrage__c(
                                            Channel_Partner__c         = bk.Channel_Partner__c,
                                            Booking__c                 = bk.Id,
                                            Brokerage_Ladder__c        = nriLadder.Id,
                                            Project__c                 = bk.Project_Name__c,
                                            Total_Brokerage__c         = nriPct,
                                            Total_Brokerage_Amount__c  = nriAmt,
                                            Type__c                    = 'NRI'
                                        ));
                                    }
                                    if(nriLadder.Percentage__c == null && nriLadder.Brokerage_amount__c != null){
                                        system.debug('line 176');
                                        cpInserts.add(new Channel_Partner_Brokrage__c(
                                            Channel_Partner__c         = bk.Channel_Partner__c,
                                            Booking__c                 = bk.Id,
                                            Brokerage_Ladder__c        = nriLadder.Id,
                                            Project__c                 = bk.Project_Name__c,
                                            // Total_Brokerage__c         = nriPct,
                                            Total_Brokerage_Amount__c  = nriLadder.Brokerage_amount__c,
                                            Type__c                    = 'NRI'
                                        ));
                                    }
                                    
                                }
                                // }
                            }
                        }
                        if (ladderMap.containsKey(bk.Brokerage_Ladder__c) && 
                            ladderMap.get(bk.Brokerage_Ladder__c).RecordType.Name == 'Launch') {
                                
                                Channel_Partner_Brokrage__c cpRecord = new Channel_Partner_Brokrage__c(
                                    Channel_Partner__c         = bk.Channel_Partner__c,
                                    Booking__c                 = bk.Id,
                                    Brokerage_Ladder__c        = bk.Brokerage_Ladder__c,
                                    Project__c                 = bk.Project_Name__c,
                                    Ladder_Band__c             = matchedBandId,
                                    Total_Brokerage__c         = totalBrokeragePct,
                                    Total_Brokerage_Amount__c  = totalBrokerageAmt,
                                    Type__c                    = ladderMap.get(bk.Brokerage_Ladder__c).RecordType.Name
                                );
                                cpInserts.add(cpRecord);
                            }
                    }
                }
            }
            
            
            
            
            if (!bookingUpdates.isEmpty()) {
                // update bookingUpdates;  // Uncomment if needed
            }
            
            if (!cpInserts.isEmpty()) {
                system.debug('182');
                insert cpInserts;
            }
        }
    }
}