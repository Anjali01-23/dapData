trigger bookingTri on Booking__c (before insert,after Insert, after update) {
    if(Trigger.isBefore && Trigger.isInsert){
        handlerTrain.method1(Trigger.new);
       
    }
    else if(Trigger.isAfter && Trigger.isInsert){
       handlerTrain.method2(Trigger.new);
         handlerTrain.submitForApproval(Trigger.new);
    }
    else if(Trigger.isAfter && Trigger.isUpdate){
       handlerTrain.method2(Trigger.new);
        handlerTrain.method3(Trigger.new);
    }
    
}