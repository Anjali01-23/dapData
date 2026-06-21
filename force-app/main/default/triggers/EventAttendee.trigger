trigger EventAttendee on Event_Attendee_Junction__c (before insert) {
    if(Trigger.isInsert && Trigger.isBefore){
        HandlerClass.method1(Trigger.new);
    }
}