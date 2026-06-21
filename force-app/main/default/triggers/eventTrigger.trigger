trigger eventTrigger on Platform1__e (after Insert) {
 if(Trigger.isAfter && Trigger.isInsert){
 List<Waiting__c> wait=new List<Waiting__c>();
 Set<Id>sets=new Set<Id>();
 Map<Id,Decimal>mpp=new Map<Id,Decimal>();
 for(Platform1__e p:Trigger.new){
 sets.add(p.Attendee__c);
 Waiting__c w=new Waiting__c();
 w.Status__c='Waiting';
 w.Attendee__c=p.Attendee__c;
 w.Eventt__c=p.Event__c;
 
 mpp.put(p.Attendee__c,p.Registration_Fees__c);
 
 wait.add(w);

 }
 insert(wait);
 
 List<Attendee__c>listt=[Select  Amount__c , Id from Attendee__c where ID IN :sets ]; 
 
 
 for(Attendee__c a:listt){
 
 a.Amount__c=a.Amount__c-mpp.get(a.Id);

 }
 System.debug('ERRRRRRR'+listt);
 update listt;
 

 
 }
 
}