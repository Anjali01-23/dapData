trigger claimTrigger1 on Claim__c (before insert, before delete , after insert, after update) {
    if(Trigger.isInsert && Trigger.isBefore){
claimClass.method1(Trigger.new);  
        claimClass.method2(Trigger.new);
      //  claimClass.method3(Trigger.new);
        claimClass.method5(Trigger.new);
    }
   /* else if(Trigger.isDelete && Trigger.isBefore){
        claimClass.method4(Trigger.old);
    } */
    else if(Trigger.isInsert && Trigger.isAfter){
        claimClass.method6(Trigger.new);
        claimClass.submitForApproval(Trigger.new);
    }
    
    else if(Trigger.isUpdate && Trigger.isAfter){
        claimClass.methodUpdate(Trigger.new);
    }
    
    
}