@RestResource(urlMapping='/newTrain')
global class restTrain {
 @HttpPost
    global static string method(){
        RestRequest req=RestContext.request;
        String str=req.requestBody.toString();
        List<wrapper1>WrapperList=(List<wrapper1>)JSON.deserialize(str,List<wrapper1>.class);
        List<String>sources=new List<String>();
        List<String>destinations=new List<String>();  
        List<Date>datess=new List<Date>(); 
        
        for(wrapper1 w:WrapperList){
            sources.add(w.sourceStation);
            destinations.add(w.destinationStation);
            datess.add(w.journeyDate);
        }
        
      List<Train11__c>trainData=[Select  id ,TrainName__c, Name,  ArrivalTime__c,General_Quota__c, AC_seats__c, Sleeper_seats__c,  Departure_Time__c , JourneyDate__c from Train11__c where SourceStation__c IN :sources AND DestinationStation__c IN :destinations and JourneyDate__c IN :datess];
       
       
            Map<String,Object> m1=new Map<String,Object>();
           if(trainData.isEmpty()){
              m1.put('failure',true);
                m1.put('trains',null);
            }
            else{
               Map<String,Object>mNew=new Map<String,Object>();
                mNew.put('trainNumber',trainData[0].Name);
                 mNew.put('trainName',trainData[0].TrainName__c);
                 mNew.put('departureTime',trainData[0].Departure_Time__c);
                 mNew.put('arrivalTime',trainData[0].ArrivalTime__c);
                Decimal total=trainData[0].General_Quota__c+trainData[0].AC_seats__c+trainData[0].Sleeper_seats__c;
                mNew.put('Available seats',total);
               m1.put('success',true); 
               m1.put('trains',mNew);
            }
            
          
        String res=JSON.serialize(m1);
        return res; 
        
    }
}