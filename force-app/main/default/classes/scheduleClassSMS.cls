public class scheduleClassSMS implements Schedulable{
    Id meetId;
    public scheduleClassSMS(Id meet){
        meetId=meet;
    }
    public void execute(SchedulableContext sc) {
         Meeting__c m=[Select Id , Name , Meeting_Time__c , Meeting_URL__c from Meeting__c where ID = :meetId];
        List<Meet_Junction__c>junObj=[Select Account__r.Phone from Meet_Junction__c where Meeting__c =:m.Id];
        List<String>phoneNo=new List<String>();
        for(Meet_Junction__c m1:junObj){
            phoneNo.add(String.valueOf(m1.Account__r.Phone));
        }
        
        apiSMS.method(m.Name,m.Meeting_URL__c,m.Meeting_Time__c,phoneNo);
    }
}