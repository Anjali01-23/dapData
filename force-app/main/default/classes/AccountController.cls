public with sharing class AccountController {
    @AuraEnabled
    public static void doSomething() {
        
        Account acc = [SELECT Id, Name FROM Account where Name='Acc1' LIMIT 1];
        acc.Description = 'Updated from Action';
        update acc;
    }
}