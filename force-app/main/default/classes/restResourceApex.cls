@RestResource(urlMapping='/newDatas')
global class restResourceApex {
 @HttpPost
    global static string method(){
        RestRequest req=RestContext.request;
        String str=req.requestBody.toString();
        String str1=str.replaceAll('__c','_c');
        List<wrapperClass1>WrapperList=(List<wrapperClass1>)JSON.deserialize(str1,List<wrapperClass1>.class);
        System.Database.executeBatch(new BatchClass2(WrapperList),200);   
        
        Map<String,Object>mpp=new Map<String,Object>();
        mpp.put('Total number of records processed ',WrapperList.size());
        Integer success=0;
        Integer fail=0;
        List<String>namess=new List<String>();
        for(wrapperClass1 w:WrapperList){
            if(String.isEmpty(w.Account.External_last_modified_datetime) || String.isEmpty(w.Account.company_external_system_id_c)){
                fail++;
            }
            else{
                success++;
                namess.add(w.Account.name);
            }
        }
        mpp.put('Successful Records',success);
        mpp.put('Failed Records',fail);
        mpp.put('Name',namess);
        String res=JSON.serialize(mpp);
        return res;
        
    }
}