@RestResource(urlMapping='/createOrder')
global class orderRestApi {
@HttpPost
    global static void methodd(){
        RestRequest req=RestContext.request;
        String str=req.requestBody.toString();
        Map<String,Object>mpp=(Map<String,Object>)json.deserializeUntyped(str);
        if(!String.isBlank(String.valueOf(mpp.get('Order Id')))){
            Order1__c oldorder=[Select Id, Order_Date__c , Order_Status__c , Total_Amount__c, Customer__c, Name from Order1__c where Name = :String.valueOf(mpp.get('Order Id')) LIMIT 1];
            oldOrder.Order_Date__c=Date.valueOf(String.valueOf(mpp.get('Order Date')));
            oldOrder.Total_Amount__c=Decimal.valueOf((String.valueOf(mpp.get('Total Amount'))));
            String Acc=String.valueOf(mpp.get('Customer'));
            Account a;
            if(!String.isBlank(Acc)){
               a=[Select Id from Account where Name =:Acc LIMIT 1];           
            }
            oldOrder.Customer__c=String.isBlank(Acc)?null:a.Id;
            update oldOrder;
        }
        else{
            Order1__c ordernew=new Order1__c();
            ordernew.Order_Date__c=Date.valueOf(String.valueOf(mpp.get('Order Date')));
            ordernew.Total_Amount__c=Decimal.valueOf((String.valueOf(mpp.get('Total Amount'))));
            String Acc=String.valueOf(mpp.get('Customer'));
            Account a;
            if(!String.isBlank(Acc)){
               a=[Select Id from Account where Name =:Acc LIMIT 1];           
            }
            ordernew.Customer__c=String.isBlank(Acc)?null:a.Id;
            insert ordernew;
        }

    }
}