public with sharing class getRecordsWire {
    @AuraEnabled(cacheable=true)
    public static List<sObject> getRecords(String industry) {
      return [Select Id, Name,Industry from Account where Industry=:industry];
    }

    @AuraEnabled(cacheable=true)
    public static List<sObject> getRecords1() {
      return [Select Id, Name,Appointment_Status__c, Appointment_Date__c, Appointment_Type__c , Account__r.Name , Account__r.Id from Appointment__c ORDER BY Appointment_Date__c DESC];
    }


    @AuraEnabled(cacheable=true)
    public static List<sObject> getRecords2(String accId) {
      return [Select Id , AccountNumber , BillingCity , BillingCountry, ShippingCity, ShippingCountry , BillingStreet , ShippingStreet , Name , Email__c , Phone , Website, AnnualRevenue , SLAExpirationDate__c , Type__c ,Subtype__c  , LastModifiedDate from Account where ID = :accId];
    }

    @AuraEnabled
    public static List<sObject> getRecordsLess(String accId) {
      return [Select Id , Appointment_Type__c,  CreatedDate from Appointment__c where Account__c = :accId LIMIT 2];
    }

    @AuraEnabled
    public static List<sObject> getRecordsMore(String accId) {
      return [Select Id , Appointment_Type__c,  CreatedDate from Appointment__c where Account__c = :accId];
    }

}