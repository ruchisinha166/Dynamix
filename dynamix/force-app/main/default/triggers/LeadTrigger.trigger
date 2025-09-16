trigger LeadTrigger on Lead (after insert) {
    LeadTriggerHandler.convertLeadtoEnquiry(trigger.new);
}