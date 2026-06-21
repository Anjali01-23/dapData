public with sharing class DemoController {

    @AuraEnabled
    public static void startProcess() {

        System.enqueueJob(
            new DemoQueuable()
        );
        
    }
}