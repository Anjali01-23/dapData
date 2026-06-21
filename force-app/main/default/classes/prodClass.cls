public with sharing class prodClass {
    
    @AuraEnabled(cacheable=true)
        public static List<Category__c> method1(){
            return [Select Name, Id from Category__c];
        }
    

         @AuraEnabled(cacheable=true)
        public static List<CategoryProduct__c> method3(List<Id>catList){
            if(!catList.isEmpty()){
            return [Select Name from CategoryProduct__c where Category1__c IN :catList and Product__r.isActive= true ];
            }
            else {
            return [Select Name from CategoryProduct__c  where Product__r.isActive= true ];
            }
        }
}

