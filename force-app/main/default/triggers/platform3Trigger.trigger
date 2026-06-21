trigger platform3Trigger on Platform3__e (after Insert) {
if(Trigger.isInsert && Trigger.isAfter){
 List<Waiting1__c>waits=new List<Waiting1__c>();
        for(Platform3__e p1: Trigger.new){
            Waiting1__c w=new Waiting1__c();
            w.Passenger11__c=p1.PassId__c;
            w.Train11__c=p1.TrainId__c;
            w.SeatCount__c=p1.SeatCount__c;
            w.Quotas__c=p1.Quota__c;
            w.JourneyDate__c=p1.JourneyDates__c;
            w.Source__c=p1.Source__c;
            w.Destination__c=p1.Destination__c;
            waits.add(w);
        }
        System.debug('WAITINGGGG'+waits);
        try{
        insert (waits);
        }
        catch(Exception e){
        System.debug(e.getMessage());
        }
        
}
}