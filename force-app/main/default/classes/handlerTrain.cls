public class handlerTrain {

    public static void method1(List<Booking__c>books){
        List<Id>trainss=new List<Id>();
        List<String>quotas=new List<String>();
        List<Date>datess=new List<Date>();
        for(Booking__c b: books){
            trainss.add(b.Train11__c);
            quotas.add(b.Quota__c);
            datess.add(b.Journey_Date__c);
        }
        List<AggregateResult>previous=[Select COUNT(Id) total, Passenger11__c from Booking__c where Train11__c IN :trainss and Quota__c IN :quotas and Journey_Date__c IN :datess and active__c=true  Group By Passenger11__c];
        Map<Id,Integer>mpp=new Map<Id,Integer>();
        for(AggregateResult a: previous){
            mpp.put((Id)a.get('Passenger11__c'),(Integer)a.get('total'));    
        }
        
        for(Booking__c b: books){
            if(mpp.containsKey(b.Passenger11__c)){
                if(mpp.get(b.Passenger11__c)>0){
                    b.addError('Already active Booking exist');
                }
            }
        }
        
        List<Train11__c>trainData=[Select id, bookingWindow__c, isActive__c, General_Quota__c, AC_seats__c,  Sleeper_seats__c from train11__c where ID IN :trainss];
        Map<Id,Train11__c>mpp3=new Map<Id,Train11__c>();
        Map<Id,Boolean>mpp1=new Map<Id,Boolean>();
        Map<Id,Boolean>mpp2=new Map<Id,Boolean>();
        for(Train11__c t:trainData){
            mpp1.put(t.Id,t.isActive__c);
            mpp2.put(t.Id,t.bookingWindow__c);
            mpp3.put(t.Id,t);
        }
        List<Platform3__e>pList=new List<Platform3__e>();
        for(Booking__c b: books){
            Train11__c t1=mpp3.get(b.Train11__c);
            if(mpp1.containsKey(b.Train11__c)){
                if(mpp1.get(b.Train11__c)==false){
                    b.addError('Train need to be active');
                }
            }
             if(mpp2.containsKey(b.Train11__c)){
                if(mpp2.get(b.Train11__c)==true){
                    b.addError('Train window is Closed');
                }
            }
            
            
            if(b.Journey_Date__c<=Date.today()){
                b.addError('Journey Date needs to be in future');
            }
            
            
            
               
            
            if(b.Quota__c=='General'){
                Platform3__e p1=new Platform3__e();
                    p1.JourneyDates__c=b.Journey_Date__c;
                    p1.Destination__c=b.Destination__c;
                    p1.Source__c=b.Source__c;
                    p1.PassId__c=b.Passenger11__c;
                    p1.TrainId__c=b.Train11__c;
                    p1.Quota__c=b.Quota__c;
                if(t1.General_Quota__c==0){
                    p1.SeatCount__c=b.Seat_Count__c;
                    EventBus.publish(p1);
                    b.addError('You are added into Waiting List');
                }
                else if(t1.General_Quota__c!=0 && b.Seat_Count__c>t1.General_Quota__c){
                    
                    p1.SeatCount__c=b.Seat_Count__c-t1.General_Quota__c;
                    b.Seat_Count__c=t1.General_Quota__c;
                    EventBus.publish(p1);
                }
            }     
               
            if(b.Quota__c=='Sleeper'){
                Platform3__e p1=new Platform3__e();
                    p1.JourneyDates__c=b.Journey_Date__c;
                    p1.Destination__c=b.Destination__c;
                    p1.Source__c=b.Source__c;
                    p1.PassId__c=b.Passenger11__c;
                    p1.TrainId__c=b.Train11__c;
                    p1.Quota__c=b.Quota__c;
                if(t1.Sleeper_seats__c==0){
                    p1.SeatCount__c=b.Seat_Count__c;
                    EventBus.publish(p1);
                    b.addError('You are added into Waiting List');
                }
                else if(t1.Sleeper_seats__c!=0 && b.Seat_Count__c>t1.Sleeper_seats__c){
                    p1.SeatCount__c=b.Seat_Count__c-t1.Sleeper_seats__c;
                    b.Seat_Count__c=t1.Sleeper_seats__c;
                    EventBus.publish(p1);
                }
            }   
            if(b.Quota__c=='AC'){
                Platform3__e p1=new Platform3__e();
                    p1.JourneyDates__c=b.Journey_Date__c;
                    p1.Destination__c=b.Destination__c;
                    p1.Source__c=b.Source__c;
                    p1.PassId__c=b.Passenger11__c;
                    p1.TrainId__c=b.Train11__c;
                    p1.Quota__c=b.Quota__c;
                if(t1.AC_seats__c==0){
                    p1.SeatCount__c=b.Seat_Count__c;
                    EventBus.publish(p1);
                    b.addError('You are added into Waiting List');
                }
                else if(t1.AC_seats__c!=0 && b.Seat_Count__c>t1.AC_seats__c){
                    p1.SeatCount__c=b.Seat_Count__c-t1.AC_seats__c;
                    b.Seat_Count__c=t1.AC_seats__c;
                    EventBus.publish(p1);
                }
            }   
            if(b.Seat_Count__c>20){
                b.Status__c='Pending';
            }
            else{
                b.Status__c='Confirmed';
            }
            
            
        }
    }
    
   /* public static void method2(List<Booking__c>books){
        List<Id>trainss=new List<Id>();
        for(Booking__c b: books){
            trainss.add(b.Train11__c);
        }
        List<Train11__c>trainData=[Select id, bookingWindow__c, isActive__c, General_Quota__c, Sleeper_seats__c, AC_seats__c from train11__c where ID IN :trainss];
        Map<Id,Decimal>mpp1=new Map<Id,Decimal>();
        for(Booking__c b: books){
            if(mpp1.containsKey(b.Train11__c)){
                mpp1.put(b.Train11__c,mpp1.get(b.Train11__c)+b.Seat_Count__c);
            }
            else{
                mpp1.put(b.Train11__c,b.Seat_Count__c);
            }
        }
        
        for(Train11__c t: trainData){
            
        }
        
        
    } */
    
    public static void method2(List<Booking__c> books){

    Set<Id> trainIds = new Set<Id>();

    for(Booking__c b : books){
        trainIds.add(b.Train11__c);
    }
    List<Train11__c>trainData=new List<Train11__c>();
    Map<Id,Train11__c> trainMap = new Map<Id,Train11__c>(
        [SELECT Id,
                AC_seats__c,
                Sleeper_seats__c,
                General_Quota__c
         FROM Train11__c
         WHERE Id IN :trainIds]
    );

    for(Booking__c b : books){
        if(b.Status__c=='Confirmed'){

        Train11__c t = trainMap.get(b.Train11__c);

        if(b.Quota__c == 'AC'){
            t.AC_seats__c -= b.Seat_Count__c;
        }
        else if(b.Quota__c == 'Sleeper'){
            t.Sleeper_seats__c -= b.Seat_Count__c;
        }
        else if(b.Quota__c == 'General'){
            t.General_Quota__c -= b.Seat_Count__c;
        }
        trainData.add(t);
        }
    }
        if(!trainData.isEmpty()){
            update trainData;
        }
    
}
    
     public static void method3(List<Booking__c>bookRecord){
        List<Id>ids=new List<Id>();
         List<String>emails=new List<String>();
    OrgWideEmailAddress owea =[SELECT Id FROM OrgWideEmailAddress WHERE Address = 'anjaligoyal4102@gmail.com' LIMIT 1];

         
        for(Booking__c b:bookRecord){
            if(b.Status__c=='Canceled'){
                ids.add(b.Passenger11__c);
            }
        }
         List<Passenger11__c> pas=[Select Id, Refund__c , Email__c from Passenger11__c where ID IN :ids];
         for(Passenger11__c p: pas){
             emails.add(p.Email__c);
         }
         
        List<Passenger11__c>passRec=new List<Passenger11__c>();
        Map<Id,Passenger11__c>mpp=new Map<Id,Passenger11__c>([Select Id, Refund__c from Passenger11__c where ID IN :ids]);
        for(Booking__c b:bookRecord){
            if(b.Status__c!='Canceled'){
                return;
            }
            Integer diff=Date.today().daysBetween(b.Journey_Date__c);
            Passenger11__c p=mpp.containsKey(b.Passenger11__c)?mpp.get(b.Passenger11__c):null;            
            if(diff>7){
             p.Refund__c=0.9*b.Amount__c;                
            }
            else if(diff >=3 && diff <=7){
             p.Refund__c=0.75 *b.Amount__c;     
            }else if(diff>=1 && diff <=3){
              p.Refund__c=0.5*b.Amount__c;    
            }else{
              p.Refund__c=0;    
            }
            passRec.add(p);
        }
         Messaging.SingleEmailMessage sem=new Messaging.SingleEmailMessage();
        sem.toaddresses=emails;
         sem.setOrgWideEmailAddressId(owea.Id);
        sem.setSubject('Booking is Cancelled');
        sem.plaintextbody='Hii, your booking is canceled';
        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{sem});
         update passRec;
    }
    
    public static void submitForApproval(List<Booking__c> books){

    List<Approval.ProcessSubmitRequest> reqs =new List<Approval.ProcessSubmitRequest>();

    for(Booking__c b : books){
        if(b.Status__c == 'Pending'){

            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setObjectId(b.Id);
            req.setComments('Submitted via Apex');
            reqs.add(req);
        }
    }

    if(!reqs.isEmpty()){
        Approval.ProcessResult[] results = Approval.process(reqs);
    }
}

}