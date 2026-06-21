@RestResource(urlMapping='/newData')
global class restAPINew {
 @HttpPost
    global static void method(){
        RestRequest req=RestContext.request;
        String str=req.requestBody.toString(); 
        List<WrapperClass>WrapperList=(List<WrapperClass>)JSON.deserialize(str,List<WrapperClass>.class);
        System.Database.executeBatch(new BatchClass1(WrapperList),200);       
    }
}