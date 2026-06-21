global class batchMovie implements Database.Batchable<Movie_Booking__c>{
  
    public List<Movie_Booking__c> bookings;
    public batchMovie(List<Movie_Booking__c>listt){
        bookings=listt;
    }
    
    public Iterable<Movie_Booking__c> start(Database.BatchableContext bc){
        return bookings;
    }
    public void execute(Database.BatchableContext bc,List<Movie_Booking__c>booking){
        List<Id>showss=new List<Id>();
        List<String>seatss=new List<String>();
        for(Movie_Booking__c m:booking){
            showss.add(m.Show__c);
            seatss.add(m.Seat_Type__c);
        }
        List<Movie_Booking__c>listData=[Select Id , Seat_Count__c, Seat_Type__c , Show__c , CreatedDate from Movie_Booking__c where Show__c IN :showss and Seat_Type__c IN :seatss ];
        Map<Id,Movie_Booking__c>map1=new Map<Id,Movie_Booking__c>();
        Map<Id,String>map2=new Map<Id,String>();
        Map<Id,DateTime>map3=new Map<Id,DateTime>();
        for(Movie_Booking__c m1:listData){
            map1.put(m1.Show__c,m1);
            map2.put(m1.Show__c,m1.Seat_Type__c);
            map3.put(m1.Show__c,m1.CreatedDate);
        }
        List<Movie_Booking__c>DeleteRec=new List<Movie_Booking__c>();
        List<Movie_Booking__c>updateRec=new List<Movie_Booking__c>();
        for(Movie_Booking__c m:booking){
            if(map2.containsKey(m.show__c)){
                if(map2.get(m.Show__c)==m.Seat_Type__c && map3.get(m.Show__c).date()==Date.today()){
                    DeleteRec.add(map1.get(m.Show__c));
                    Movie_Booking__c m22=map1.get(m.Show__c);
                    m.Seat_Count__c+=m22.Seat_Count__c;
                    updateRec.add(m);
                }
            }
        }
        
        List<Movie_Booking__c>delerec=[Select Id from Movie_Booking__c where ID IN :DeleteRec];
        System.debug('Delete Records are'+delerec);
        delete delerec;
        upsert updateRec;
    }
        
               
    public void finish(Database.BatchableContext bc){  
        
    }
    
}