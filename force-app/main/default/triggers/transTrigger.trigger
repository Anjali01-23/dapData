trigger transTrigger on Transaction1__c (before insert, after insert) {
    if(Trigger.isInsert && Trigger.isBefore){
        transactionHandler.method11(Trigger.new);
    }
    else if(Trigger.isInsert && Trigger.isAfter){
        transactionHandler.method22(Trigger.new);
    }
}