trigger partTrigger on Part__c (before insert, before update,after insert, after update) {
    if(Trigger.isBefore){
     OrderClassHandler.method3(Trigger.new);
     OrderClassHandler.method4(Trigger.new);	   
    }
    else if(Trigger.isAfter){
      OrderClassHandler.method7(Trigger.new);
      OrderClassHandler.method8(Trigger.new); 
    }   
}