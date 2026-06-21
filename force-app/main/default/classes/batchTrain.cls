global class batchTrain implements Database.Batchable<wrapper2> , Database.Stateful{
  
    public List<wrapper2> wrap;
    
    
    public batchTrain(List<wrapper2>listt){
        wrap=listt;      
    }
    
    public Iterable<wrapper2> start(Database.BatchableContext bc){
        return wrap;
    }
    public void execute(Database.BatchableContext bc,List<wrapper2>wrap){
      List<Booking__c>bookings=new List<Booking__c>();
      Set<String> emails = new Set<String>();
      Set<String> pass = new Set<String>();
      Set<String> phones = new Set<String>();
        Set<String>trainNo =new  Set<String>();
      for(wrapper2 w : wrap){
        emails.add(w.email);
        pass.add(w.passengerName);
        phones.add(w.mobile);
        trainNo.add(w.trainNumber);
      }
      Map<String,Id> passMap = new Map<String, Id>();
      Map<String,Train11__c> trainMap = new Map<String, Train11__c>();  
      for(Passenger11__c p : [
       SELECT Id, Email__c
       FROM Passenger11__c
       WHERE Email__c IN :emails and Name IN :pass and Phone__c IN :phones
      ]){
         passMap.put(p.Email__c, p.Id);
       }
        
        for(Train11__c p : [
       SELECT Id, SourceStation__c, DestinationStation__c,Name
       FROM Train11__c
       WHERE Name IN :trainNo
      ]){
         trainMap.put(p.Name, p);
       }
        
        
        for(wrapper2 w:wrap){
            Booking__c b=new Booking__c();
            b.Passenger11__c=passMap.containsKey(w.email) ? passMap.get(w.email) : null;
            b.Journey_Date__c=w.journeyDate;
            b.Quota__c=w.quota;
            b.Seat_Count__c=w.seatCount;
            b.active__c=true;
            Train11__c trains=trainMap.containsKey(w.trainNumber) ? trainMap.get(w.trainNumber) : null;
            b.Train11__c=trains.Id;
            b.Source__c=trains.SourceStation__c;
            b.Destination__c=trains.DestinationStation__c;
            bookings.add(b);
        }
        insert bookings;
    }
        
               
    public void finish(Database.BatchableContext bc){  
        
    }
    
}