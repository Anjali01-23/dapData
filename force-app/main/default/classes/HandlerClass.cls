public class HandlerClass {

    public static void method1(List<Event_Attendee_Junction__c>junObj){
        Set<Id>eventIds=new Set<Id>();
        
        for(Event_Attendee_Junction__c e:junObj){
            eventIds.add(e.Eventt__c);
        }
        
        List<AggregateResult>agg=[Select Count(Id) counts, Eventt__c from Event_Attendee_Junction__c where Eventt__c  IN :eventIds and Status__c='Registered' GROUP BY Eventt__c];
        Map<Id,Integer>mpp=new Map<Id,Integer>();
        for(AggregateResult a:agg){
            mpp.put((Id)a.get('Eventt__c'),(Integer)a.get('counts'));
        }
        
        for(Event_Attendee_Junction__c c: junObj){
            if(mpp.get(c.Eventt__c)>=1){
                List<Platform1__e> list1=new List<Platform1__e>();
                Platform1__e p1=new Platform1__e();
                p1.Registration_Fees__c=c.Eventt__r.Registration_Fees__c;
                p1.Attendee__c=c.Attendee__c;
                p1.Event__c=c.Eventt__c;                
                list1.add(p1);
                EventBus.publish(list1);
                c.addError('You can not register for this event. You have been added to the waiting list');
            }
        }
        
    }
}