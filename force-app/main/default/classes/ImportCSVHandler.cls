public with sharing class ImportCSVHandler {    

    @AuraEnabled
    public static List<Employee_Performance__c> ReadCSVFile(String base64Data) {
        String data=JSON.deserializeUntyped(base64Data).toString();
        List<Employee_Performance__c> lstAcc = new List<Employee_Performance__c>();
        List<String> lstCSVLines = data.split('\n');
        for(Integer i = 1; i < lstCSVLines.size(); i++){           
            String csvLine = lstCSVLines[i];
            String prevLine = csvLine;
            Integer startIndex;
            Integer endIndex;
            
            while(csvLine.indexOf('"') > -1){            
                if(startIndex == null){
                    startIndex = csvLine.indexOf('"');
                    csvLine = csvLine.substring(0, startIndex) + ':quotes:' + csvLine.substring(startIndex+1, csvLine.length());
                }else{
                    if(endIndex == null){
                        endIndex = csvLine.indexOf('"');
                        csvLine = csvLine.substring(0, endIndex) + ':quotes:' + csvLine.substring(endIndex+1, csvLine.length());
                    }
                }
                
                if(startIndex != null && endIndex != null){
                    String sub = csvLine.substring(startIndex, endIndex);
                    sub = sub.replaceAll(',', ':comma:');
                    csvLine = csvLine.substring(0, startIndex) + sub + csvLine.substring(endIndex, csvLine.length());
                    startIndex = null;
                    endIndex = null;
                }
            }
            
            List<String> csvRowData = new List<String>();
            for(String column : csvLine.split(',')){
                column = column.replaceAll(':quotes:', '').replaceAll(':comma:', ',');
                csvRowData.add(column);
            }         
            
            lstAcc.add(new Employee_Performance__c(
                	Employee_Performance_Name__c = csvRowData[0],
                Productivity__c=Decimal.valueOf(csvRowData[1]),
                Attendance__c=Decimal.valueOf(csvRowData[2]),
                Problem_Solving_Skills__c=Decimal.valueOf(csvRowData[3]),
                Pressure_Management__c=Decimal.valueOf(csvRowData[4])   
            ));
        }       
        return lstAcc;       
    }

    @AuraEnabled
    public static string SaveFile(string jsonString){
        string sMessage='';
        try {
            List<Employee_Performance__c> lstACCToInsert=(List<Employee_Performance__c>)JSON.deserialize(jsonString, List<Employee_Performance__c>.class);
            //insert lstACCToInsert;
            sMessage='SUCCESS';
        } catch (Exception e) {
            sMessage=e.getMessage();
        }
        return sMessage;
    }
 }