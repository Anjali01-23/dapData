public with sharing class csvUploaderController {
  @AuraEnabled
  public static List<String> createRecordsFromCSV(List<Employee_Performance__c>dataList) {
   List<String> errorList = new List<String>();
   List<Database.UpsertResult>results=System.Database.upsert(dataList,Employee_Performance__c.Employee_Performance_Name__c,false);


   for(Integer i = 0; i < results.size(); i++) {

            if(!results[i].isSuccess()) {

                for(Database.Error err : results[i].getErrors()) {

                    errorList.add(
                        'Row ' + (i + 2) + ' : ' + err.getMessage()
                    );
                }
            }
        }

        return errorList;
  
  }

  @AuraEnabled
  public static List<Employee_Performance__c> updateData(List<Employee_Performance__c>dataList){
    List<String>names=new List<String>();
    for(Employee_Performance__c e:dataList){
      names.add(e.Employee_Performance_Name__c);
    }
    List<Employee_Performance__c>datass=[SELECT Id , Employee_Performance_Name__c, Pressure_Management__c, Attendance__c , Problem_Solving_Skills__c, Productivity__c, Overall_Performance__c FROM Employee_Performance__c where Employee_Performance_Name__c IN :names];

    for(Employee_Performance__c e:datass){
      e.Overall_Performance__c=(e.Pressure_Management__c)*0.3 + (e.Problem_Solving_Skills__c)*0.3 + (e.Attendance__c)*0.2 + (e.Productivity__c)*0.2;
    }
    update datass;
    return datass;
  }


  
}