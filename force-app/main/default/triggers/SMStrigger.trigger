trigger smsTrigger on Meeting__c (after insert) {
    
    for(Meeting__c m:Trigger.new){
        scheduleClassSMS s=new scheduleClassSMS(m.Id);
        Datetime executeTime=m.Meeting_Time__c.addMinutes(-10);
        String cronE=Utility.GetCRONExpression(executeTime);
        Double random=Math.random();
        System.schedule('ScheduleJob'+random,cronE,s);
    }
}