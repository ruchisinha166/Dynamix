trigger GeneratePublicURLTrigger on ContentDocument (after insert, after update) {
    if(trigger.isAfter && trigger.isUpdate){
        for(ContentDocument l:Trigger.new) {
       GeneratePublicURL.generatePublicLink(l.Id);
    }
    }
    
}