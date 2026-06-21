public with sharing class transApex {

    
    @AuraEnabled(cacheable=true)
    public static String method0() { 
    Id userId = UserInfo.getUserId(); 
    User u=[Select name from User where Id = :userId];
    return u.name;
    }

    @AuraEnabled(cacheable=true)
    public static Decimal method1() {
    Id userId = UserInfo.getUserId();
    List<AggregateResult> income = [SELECT SUM(Amount__c) FROM Transaction1__c WHERE Type__c = 'Income' and CreatedById = :userId Group By CreatedById];
    Decimal income1 = income.isEmpty() ? 0 : (Decimal)income[0].get('expr0');
    return income1 == null ? 0 : income1;
    }

    @AuraEnabled(cacheable=true)
    public static Decimal method2() {
    Id userId = UserInfo.getUserId();
    List<AggregateResult> expense = [SELECT SUM(Amount__c) , CreatedById FROM Transaction1__c WHERE Type__c = 'Expense' and CreatedById = :userId Group By CreatedById];
    Decimal expense1 = expense.isEmpty() ? 0 : (Decimal)expense[0].get('expr0');
    return expense1 == null ? 0 : expense1;
    }

    @AuraEnabled(cacheable=true)
    public static List<Transaction1__c> method3() {
    Id userId = UserInfo.getUserId();
    return [Select Id , Name , Amount__c , Date__c , Type__c from Transaction1__c where CreatedById = :userId Order By CreatedDate DESC LIMIT 3];
    }

    @AuraEnabled(cacheable=true)
    public static Decimal method4() {
    Id userId = UserInfo.getUserId();
    List<AggregateResult> income = [SELECT SUM(Amount__c) FROM Transaction1__c WHERE Type__c = 'Income' and CreatedById = :userId Group By CreatedById];
    List<AggregateResult> expense = [SELECT SUM(Amount__c) , CreatedById FROM Transaction1__c WHERE Type__c = 'Expense' and CreatedById = :userId Group By CreatedById];
    Decimal expense1 = expense.isEmpty() ? 0 : (Decimal)expense[0].get('expr0');
    Decimal income1 = income.isEmpty() ? 0 : (Decimal)income[0].get('expr0');
    income1 = income1 == null ? 0 : income1;
    expense1 = expense1 == null ? 0 : expense1;
    return income1 - expense1;
    }

    @AuraEnabled 
    public static Id createTrans( String names, Decimal amt, String type, Date datess){
    Transaction1__c t1 = new Transaction1__c();
    t1.name=names;
    t1.Amount__c=amt;
    t1.Type__c=type;
    t1.Date__c=datess;
    try{
        insert t1;
        return t1.Id;
    }
    catch(Exception e){
        throw new AuraHandledException(e.getMessage());
    }
}




}