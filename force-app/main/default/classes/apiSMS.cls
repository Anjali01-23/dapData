// public class apiSMS {

//     @future(callout=true)
//     public static void method(String Name, String Phone){
//         HttpRequest req=new HttpRequest();
//         req.setEndPoint('https://api.twilio.com/2010-04-01/Accounts/ACfacda2f4cc58f682d6edb3c6ad84091d/Messages'); //URL
//         req.setMethod('POST');//Method
//         Blob b=Blob.valueOf('ACfacda2f4cc58f682d6edb3c6ad84091d:773b4ed6a57821e893ddf9c129c805e0');
//         String str=EncodingUtil.base64Encode(b);
//         req.setHeader('Authorization','Basic '+str); //Authentication

//         //Request Parametersgg
//         String message='Hello'+Name;
//         String body='From='+EncodingUtil.urlEncode('+14092543962','UTF-8')+'&To='+EncodingUtil.urlEncode(Phone,'UTF-8')+'&Body='+EncodingUtil.urlEncode(message,'UTF-8');
//         req.setBody(body);

//         HttpResponse res=new HttpResponse();//For response

//         Http htp=new Http(); //Use to send Request
//         res=htp.send(req);

//     }
// }

public class apiSMS {
  @future(callout=true)
  public static void method(String Name, String Phone) {
    Twilio_Config__mdt config = Twilio_Config__mdt.getInstance('Label1');
    Twilio_Setting__c setting = Twilio_Setting__c.getOrgDefaults();
     if(config == null || setting == null){
            return;
        }
    HttpRequest req = new HttpRequest();
    req.setEndPoint(
      'callout:Twilio' +
        '/2010-04-01/Accounts/' +
        config.Account_SID__c +
        '/Messages'
    ); //URL
    req.setMethod('POST'); //Method
    Blob b = Blob.valueOf(config.Account_SID__c + ':' + setting.Auth_Token__c);
    String str = EncodingUtil.base64Encode(b);
    req.setHeader('Authorization', 'Basic ' + str); //Authentication

    //Request Parametersgg
    String message = 'Hello' + Name;
    String body =
      'From=' +
      EncodingUtil.urlEncode(config.From_Number__c, 'UTF-8') +
      '&To=' +
      EncodingUtil.urlEncode(Phone, 'UTF-8') +
      '&Body=' +
      EncodingUtil.urlEncode(message, 'UTF-8');
    req.setBody(body);

    HttpResponse res = new HttpResponse(); //For response

    Http htp = new Http(); //Use to send Request
    try {
      res = htp.send(req);
    } catch (Exception e) {
      System.debug(e.getMessage());
    }

    if (res.getStatusCode() == 201) {
      System.debug('SMS Sent Successfully');
    } else {
      System.debug('Error: ' + res.getStatusCode());

      System.debug(res.getBody());
    }
  }
}
