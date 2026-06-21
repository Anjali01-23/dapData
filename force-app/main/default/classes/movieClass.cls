public with sharing class movieClass {
    @AuraEnabled(cacheable=true)
    public static List<Show__c> getShows() {
      List<Show__c>showss=[Select Id, HouseFULL__c , FullDetails__c, Available_Seats__c,Rating__c,Movie_Name__c, Genre__c,Show_Time__c,Silver_Price__c,Gold_Price__c,Platinum_Price__c, Location__c , Name from Show__c ];
      return showss;
    }

    @AuraEnabled
    public static List<Show__c> accGenre(String gen,Date datess) {
      if(gen=='All' && datess==null){
      return  [Select Id, HouseFULL__c , FullDetails__c, Available_Seats__c,Rating__c,Movie_Name__c, Genre__c,Show_Time__c,Silver_Price__c,Gold_Price__c,Platinum_Price__c, Location__c from Show__c ];
      }
      else if(gen!='All' && datess==null){
      return  [Select Id, HouseFULL__c , FullDetails__c, Available_Seats__c,Rating__c,Movie_Name__c, Genre__c,Show_Time__c,Silver_Price__c,Gold_Price__c,Platinum_Price__c, Location__c from Show__c where Genre__c =:gen];
      }
      else if(gen=='All' && datess!=null){
      return  [Select Id, HouseFULL__c , FullDetails__c, Available_Seats__c,Rating__c,Movie_Name__c, Genre__c,Show_Time__c,Silver_Price__c,Gold_Price__c,Platinum_Price__c, Location__c from Show__c where DAY_ONLY(Show_Time__c) =:datess];       
      }
      else {
      return  [Select Id, HouseFULL__c , FullDetails__c, Available_Seats__c,Rating__c,Movie_Name__c, Genre__c,Show_Time__c,Silver_Price__c,Gold_Price__c,Platinum_Price__c, Location__c from Show__c where DAY_ONLY(Show_Time__c) =:datess and Genre__c =:gen];       
      }
    }

    @AuraEnabled
    public static List<Show__c> getShow(String naam) {
      return  [Select Id, HouseFULL__c , FullDetails__c, Available_Seats__c,Rating__c,Movie_Name__c, Genre__c,Show_Time__c,Silver_Price__c,Gold_Price__c,Platinum_Price__c, Location__c  from Show__c where Name =:naam];
      
    }

}