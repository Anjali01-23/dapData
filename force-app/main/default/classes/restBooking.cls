@RestResource(urlMapping='/newBooking')
global class restBooking {
 @HttpPost
    global static void method(){
        RestRequest req=RestContext.request;
        String str=req.requestBody.toString(); 
        List<wrapper2>WrapperList=(List<wrapper2>)JSON.deserialize(str,List<wrapper2>.class);
        System.Database.executeBatch(new batchTrain(WrapperList),200);       
    }
}