public with sharing class apexClassNew {
    @AuraEnabled(cacheable=true)
    public static void apexClassNew() {
      HttpRequest req=new HttpRequest();
      req.setEndPoint('https://newsdata.io/api/1/latest?apikey=pub_36f70396c13d435b988c56a379539984');
      req.setMethod('GET');
      HttpResponse res=new HttpResponse();
      Http htp=new Http();
      res=htp.send(req);
    }
}