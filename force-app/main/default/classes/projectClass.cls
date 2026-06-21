public with sharing class projectClass {
    @AuraEnabled(cacheable=true)
    public static List<AggregateResult> method() {
      return [SELECT SUM(Budget__c) from Projectt__c where Due_Date__c = LAST_N_DAYS:30 ];
    }

    @AuraEnabled(cacheable=true)
    public static Integer method1() {
      return [SELECT count() from Projectt__c where Due_Date__c = LAST_N_DAYS:30 ];
    }

    @AuraEnabled(cacheable=true)
    public static List<AggregateResult> method2() {
      return [SELECT SUM(Assigned_Hours__c) from Projectt__c where Due_Date__c = LAST_N_DAYS:30    ];
    }

     @AuraEnabled(cacheable=true)
    public static List<AggregateResult> method3() {
      return [SELECT SUM(Hours_Spent__c) from Time_Entry__c  where Project__r.Due_Date__c  = LAST_N_DAYS:30    ];
    }

  /*   @AuraEnabled(cacheable=true)
    public static List<Projectt__c> method4() {
      return [Select Id , Name, Project_Manager__c,Due_Date__c, Status__c from Projectt__c where Due_Date__c  = LAST_N_DAYS:30  LIMIT 5 ];
    }*/

  @AuraEnabled
public static List<Projectt__c> method4(
    Integer limitSize,
    Integer offset,
    String managerId,
    String status
) {

    if(String.isBlank(managerId) && String.isBlank(status)) {

        return [
            SELECT Id, Name, Project_Manager__c,
                   Project_Manager__r.Name,
                   Due_Date__c, Status__c
            FROM Projectt__c
            WHERE Due_Date__c = LAST_N_DAYS:30
            LIMIT :limitSize
            OFFSET :offset
        ];
    }

    else if(!String.isBlank(managerId) && String.isBlank(status)) {

        return [
            SELECT Id, Name, Project_Manager__c,
                   Project_Manager__r.Name,
                   Due_Date__c, Status__c
            FROM Projectt__c
            WHERE Due_Date__c = LAST_N_DAYS:30
            AND Project_Manager__c = :managerId
            LIMIT :limitSize
            OFFSET :offset
        ];
    }

    else if(String.isBlank(managerId) && !String.isBlank(status)) {

        return [
            SELECT Id, Name, Project_Manager__c,
                   Project_Manager__r.Name,
                   Due_Date__c, Status__c
            FROM Projectt__c
            WHERE Due_Date__c = LAST_N_DAYS:30
            AND Status__c = :status
            LIMIT :limitSize
            OFFSET :offset
        ];
    }

    else {

        return [
            SELECT Id, Name, Project_Manager__c,
                   Project_Manager__r.Name,
                   Due_Date__c, Status__c
            FROM Projectt__c
            WHERE Due_Date__c = LAST_N_DAYS:30
            AND Project_Manager__c = :managerId
            AND Status__c = :status
            LIMIT :limitSize
            OFFSET :offset
        ];
    }
}

@AuraEnabled
public static Integer getCount(
    String managerId,
    String status
){

    if(String.isBlank(managerId) && String.isBlank(status)) {

        return [
            SELECT Count()
            FROM Projectt__c
            WHERE Due_Date__c = LAST_N_DAYS:30
        ];
    }

    else if(!String.isBlank(managerId) && String.isBlank(status)) {

        return [
            SELECT Count()
            FROM Projectt__c
            WHERE Due_Date__c = LAST_N_DAYS:30
            AND Project_Manager__c = :managerId
        ];
    }

    else if(String.isBlank(managerId) && !String.isBlank(status)) {

        return [
            SELECT Count()
            FROM Projectt__c
            WHERE Due_Date__c = LAST_N_DAYS:30
            AND Status__c = :status
        ];
    }

    else {

        return [
            SELECT Count()
            FROM Projectt__c
            WHERE Due_Date__c = LAST_N_DAYS:30
            AND Project_Manager__c = :managerId
            AND Status__c = :status
        ];
    }
}


    @AuraEnabled(cacheable=true)
public static List<User> getManagers(){

    return [
        SELECT Id, Name
        FROM User
        WHERE Id IN (
            SELECT Project_Manager__c
            FROM Projectt__c
            WHERE Project_Manager__c != null
        )
    ];
}


@AuraEnabled(cacheable=true)
public static Map<String,Integer> getOverallProgress(){

    Map<String,Integer> result = new Map<String,Integer>();

    Integer completed =
        [SELECT Count()
         FROM Projectt__c
         WHERE Status__c = 'Completed'];

    Integer delayed =
        [SELECT Count()
         FROM Projectt__c
         WHERE Status__c = 'Delayed'];

    Integer ongoing =
        [SELECT Count()
         FROM Projectt__c
         WHERE Status__c = 'Ongoing'];

    Integer total =
        [SELECT Count()
         FROM Projectt__c];

    result.put('Completed', completed);
    result.put('Delayed', delayed);
    result.put('Ongoing', ongoing);
    result.put('Total', total);

    return result;
}


}



