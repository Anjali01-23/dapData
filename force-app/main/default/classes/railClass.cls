public with sharing class railClass {

    @AuraEnabled(cacheable=true)
    public static Integer method1(){
      Integer a= [Select Count() from Train11__c ];
      if(a==null){
        a=0;
      }
      return a;
    }

    @AuraEnabled(cacheable=true)
    public static Integer method2(){
      Integer a= [Select Count() from Booking__c ];
      if(a==null){
        a=0;
      }
      return a;
    }

    @AuraEnabled(cacheable=true)
    public static Integer method3(){
      Integer a= [Select Count() from Booking__c where Status__c='Confirmed' ];
      if(a==null){
        a=0;
      }
      return a;
    }

    @AuraEnabled(cacheable=true)
    public static Integer method4(){
      Integer a= [Select Count() from Waiting1__c];
      if(a==null){
        a=0;
      }
      return a;
    }

     @AuraEnabled(cacheable=true)
    public static Integer method5(){
      Integer a= [Select Count() from Booking__c where Status__c='Canceled' ];
      if(a==null){
        a=0;
      }
      return a;
    }
    

    @AuraEnabled(cacheable=true)
    public static Integer method6(){
      Date today = Date.today();
      Integer a= [Select Count() from Train11__c where JourneyDate__c = :today];
       System.debug('Today = ' + today);
    System.debug('Count = ' + a);
      return a;
    }

     @AuraEnabled(cacheable=true)
    public static Decimal method7(){
      List<AggregateResult> a1= [Select SUM(General_Quota__c)sum1 from Train11__c ];
      List<AggregateResult> a2=[Select SUM(Sleeper_Seats__c)sum2 from Train11__c ];
      List<AggregateResult> a3= [Select SUM(AC_Seats__c)sum3 from Train11__c ];


      Decimal a11=a1.isEmpty() ? 0 : (Decimal)a1[0].get('sum1');
      Decimal a12=a2.isEmpty() ? 0 : (Decimal)a2[0].get('sum2');
      Decimal a13=a3.isEmpty() ? 0 : (Decimal)a3[0].get('sum3');
      
      
      Decimal ans=a11+a12+a13;
      return ans;
    }

     @AuraEnabled(cacheable=true)
    public static Decimal method8(){
      List<String>statuss=new List<String>{'Confirmed','Pending'};
      List<AggregateResult>aggData= [Select  SUM(Seat_Count__c) summ from Booking__c where Status__c IN :statuss ];
      Decimal a10=aggData.isEmpty() ? 0 : (Decimal)aggData[0].get('summ');
      List<AggregateResult> a1= [Select SUM(General_Quota__c)sum1 from Train11__c ];
      List<AggregateResult> a2=[Select SUM(Sleeper_Seats__c)sum2 from Train11__c ];
      List<AggregateResult> a3= [Select SUM(AC_Seats__c)sum3 from Train11__c ];


      Decimal a11=a1.isEmpty() ? 0 : (Decimal)a1[0].get('sum1');
      Decimal a12=a2.isEmpty() ? 0 : (Decimal)a2[0].get('sum2');
      Decimal a13=a3.isEmpty() ? 0 : (Decimal)a3[0].get('sum3');
      
      
      Decimal ans=a11+a12+a13;
      Decimal occupy=(a10/ans)*100;
      Decimal shortValue = occupy.setScale(1, System.RoundingMode.HALF_UP);
      return shortValue;
    }


     @AuraEnabled(cacheable=true)
    public static List<Booking__c> method9(String TrainNo, String BookingId , Integer pagesize , Integer current ){
      String trainNoTrim = TrainNo == null ? '' : TrainNo.trim();
      String bookingIdTrim = BookingId == null ? '' : BookingId.trim();
      Integer offsetVal=(current-1)*pagesize;
      if(String.isBlank(trainNoTrim) && String.isBlank(bookingIdTrim)){
          return [Select Id, Status__c, Name, Train11__c, Train11__r.Name, Passenger11__r.Name, Passenger11__c, Journey_Date__c, Amount__c from Booking__c LIMIT :pagesize OFFSET :offsetVal];
      }
      else if(!String.isBlank(trainNoTrim) && String.isBlank(bookingIdTrim)){
          return [Select Id, Status__c, Name, Train11__c, Train11__r.Name, Passenger11__r.Name, Passenger11__c, Journey_Date__c, Amount__c from Booking__c where Train11__r.Name LIKE :('%' + trainNoTrim + '%') LIMIT :pagesize OFFSET :offsetVal];
      }
      else if(String.isBlank(trainNoTrim) && !String.isBlank(bookingIdTrim)){
          return [Select Id, Status__c, Name, Train11__c, Train11__r.Name, Passenger11__r.Name, Passenger11__c, Journey_Date__c, Amount__c from Booking__c where Name LIKE :('%' + bookingIdTrim + '%') LIMIT :pagesize OFFSET :offsetVal];
      }
      else{
          return [Select Id, Status__c, Name, Train11__c, Train11__r.Name, Passenger11__r.Name, Passenger11__c, Journey_Date__c, Amount__c from Booking__c where Train11__r.Name LIKE :('%' + trainNoTrim + '%') and Name LIKE :('%' + bookingIdTrim + '%') LIMIT :pagesize OFFSET :offsetVal];
      }

      
    }


    @AuraEnabled
public static Decimal getRemainingSeats(Id trainId){
    if(trainId == null){
        return 0;
    }

    Train11__c t = [
        SELECT Remaining_Seats__c
        FROM Train11__c
        WHERE Id = :trainId
        LIMIT 1
    ];

    return t.Remaining_Seats__c;
}


}










// @AuraEnabled(cacheable=true)
// public static List<Booking__c> method9(String TrainNo, String BookingId){

//     String trainNoTrim = String.isBlank(TrainNo) ? '' : TrainNo.trim();
//     String bookingIdTrim = String.isBlank(BookingId) ? '' : BookingId.trim();

//     String query =
//         'SELECT Id, Status__c, Name, Train11__c, Train11__r.Name,' +
//         ' Passenger11__r.Name, Passenger11__c, Journey_Date__c, Amount__c' +
//         ' FROM Booking__c WHERE Id != null';

//     if(!String.isBlank(trainNoTrim)){
//         query += ' AND Train11__r.Name LIKE \'%' +
//                  String.escapeSingleQuotes(trainNoTrim) +
//                  '%\'';
//     }

//     if(!String.isBlank(bookingIdTrim)){
//         query += ' AND Name LIKE \'%' +
//                  String.escapeSingleQuotes(bookingIdTrim) +
//                  '%\'';
//     }

//     return Database.query(query);
// }