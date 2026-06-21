trigger contentTrigger on ContentVersion (before insert) {
    if(Trigger.isInsert && Trigger.isBefore){
        claimClass.newMethod(Trigger.new);
    }
}