trigger partOrderTrigger on PartOrder__c (before insert, before update, after insert, after update) {
if(Trigger.isInsert && Trigger.isBefore){
        OrderClassHandler.method2(Trigger.new);
    }
    else if(Trigger.isUpdate && Trigger.isBefore){
        OrderClassHandler.method2(Trigger.new);
    }
    else if(Trigger.isInsert && Trigger.isAfter){
        OrderClassHandler.method6(Trigger.new);
    }
    else if(Trigger.isUpdate && Trigger.isAfter){
        OrderClassHandler.method6(Trigger.new);
    }
  
}