trigger BookingTrigger on Movie_Booking__c (before insert) {
    if(Trigger.isInsert && Trigger.isBefore){
      // System.Database.executeBatch(new batchMovie(Trigger.new),200);
       Handler.method1(Trigger.new);
       Handler.method2(Trigger.new);
    
      //  Set<Id>bookingIds=new Set<Id>();
        Set<Id>couponCode=new Set<Id>();
        for(Movie_Booking__c m:Trigger.new){
            if(m.Coupon__c!=null){
                couponCode.add(m.Coupon__c);
            }       
        }
        if(!couponCode.isEmpty()){
            Handler.method3(Trigger.new,couponCode);
        }
        
    }
}