public class batchExpire implements Database.Batchable<sObject>,Schedulable,Database.Stateful{
    public Decimal seatcount=0;
    public Database.QueryLocator start(Database.BatchableContext bc){
        DateTime timeVal=DateTime.now().addMinutes(-15);
        return System.Database.getQueryLocator('Select Id, Name , Seat_Count__c , Status__c,CreatedDate from Movie_Booking__c where Status__c=\'Pending\' and CreatedDate<= :timeVal  ');
    }
    public void execute(Database.BatchableContext bc,List<Movie_Booking__c>movieList){
        System.debug(movieList.size());
        for(Movie_Booking__c a: movieList){
            a.Status__c='Expired';
        }
       List<Database.saveResult> saves=System.Database.update(movieList,false);
       Integer j=0;
       for(Integer i=0; i<saves.size();i++){
            if(saves[i].isSuccess()){
                Movie_Booking__c mm=movieList[j];
                seatcount+=mm.Seat_Count__c;
                j++;
            }  
           else{
               j++;
           }
        }
    }
    public void finish(Database.BatchableContext bc){  
        System.debug('Final Seats which are recovered'+seatcount);
    }
    public void execute(SchedulableContext sc){
        batchExpire bae=new batchExpire();
        System.Database.executeBatch(bae,200);
    }
}