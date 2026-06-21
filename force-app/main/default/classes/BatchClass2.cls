global class BatchClass2 implements Database.Batchable<wrapperClass1> , Database.Stateful{
  
    public List<wrapperClass1> wrap;
    public BatchClass2(List<wrapperClass1>listt){
        wrap=listt;
    }
    
    public Iterable<wrapperClass1> start(Database.BatchableContext bc){
        return wrap;
    }
    public void execute(Database.BatchableContext bc,List<wrapperClass1>wrap){
       List<Account>accData=new List<Account>();
        List<String>stringss=new List<String>();
        Map<String,String>nameMap=new Map<String,String>();
        for(wrapperClass1 w:wrap){ 
            if(w.Account!=null && !String.isEmpty(w.Account.company_external_system_id_c)){
              stringss.add(w.Account.company_external_system_id_c);
            }
        }
        List<Account>accList=[Select Id ,Name, Company_External_ID__c , LastModifiedDate from Account where Company_External_ID__c IN :stringss];
        Map<String,Account>mpp=new Map<String,Account>();
        for(Account a:accList){
            mpp.put(a.Company_External_ID__c,a);
        }
        for(wrapperClass1 w:wrap){           
            if(w.Account!=null && !String.isEmpty(w.Account.company_external_system_id_c)){
                if(!mpp.containsKey(w.Account.company_external_system_id_c)){
                   Account a=new Account();
                   a.Name=w.Account.name;
                   a.Company_External_ID__c=w.Account.company_external_system_id_c; 
                   accData.add(a);  
                }
                else{
                    Account a1=mpp.get(w.Account.company_external_system_id_c);
                    
                        if(Datetime.valueOfGmt(w.Account.External_last_modified_datetime.replace('T',' ').replace('Z',''))> a1.LastModifiedDate){
                        Account a2=new Account();
                        a2.Name=w.Account.name;
                        a2.Company_External_ID__c=w.Account.company_external_system_id_c;
                        accData.add(a2);
                    }
                }   
            }
            
        }
        
        System.Database.upsert(accData,Account.Company_External_ID__c,true);
         List<ContentVersion>conVer=new List<ContentVersion>();     
         List<Opportunity>oppList=new List<Opportunity>();
         for(wrapperClass1 w:wrap){  
            
            if(w.Account!=null && w.Account.Opportunities!=null){
                
                List<String>stringss1=new List<String>();
                for(wrapperClass1.Oppor w1:w.Account.Opportunities){
                    if(!String.isEmpty(w1.external_system_id_c)){
                        stringss1.add(w1.external_system_id_c);
                    }
                    
                }
                List<Opportunity>oppData=[Select Id , Name, StageName, Amount, LeadSource , ExternalId__c ,AccountId, LastModifiedDate from Opportunity where ExternalId__c IN :stringss1 ];
                Map<String,Opportunity>mpp1=new Map<String,Opportunity>();
                for(Opportunity o:oppData){
                    mpp1.put(o.ExternalId__c,o);
                }
                
                for(wrapperClass1.Oppor w1:w.Account.Opportunities){
                    if(!String.isEmpty(w1.external_system_id_c)){
                        if(!mpp1.containsKey(w1.external_system_id_c)){
                        nameMap.put(w1.external_system_id_c,w.Account.name);
                        Opportunity o11=new Opportunity();
                        o11.Name=w1.Name;
                        o11.CloseDate=Date.today().addDays(7);
                        Account accountReference = new Account(Company_External_ID__c=w.Account.company_external_system_id_c); 
                        o11.Account=accountReference;
                        o11.Amount=w1.Amount;
                        o11.ExternalId__c=w1.external_system_id_c;
                        o11.LeadSource=w1.LeadSource;
                        o11.StageName=w1.Stage;
                        oppList.add(o11);
                    }
                        else{
                        Opportunity o12=mpp1.get(w1.external_system_id_c);
                        if(Datetime.valueOfGmt(w1.external_last_modified_datetime_c.replace('T',' ').replace('Z',''))> o12.LastModifiedDate)
                        {
                            System.debug('SF LastModifiedDate = ' + o12.LastModifiedDate);
                        Opportunity o11=new Opportunity();
                        Account accountReference = new Account(Company_External_ID__c=w.Account.company_external_system_id_c); 
                        o11.Account=accountReference;
                        o11.Name=w1.Name;
                        o11.Amount=w1.Amount;
                        o11.ExternalId__c=w1.external_system_id_c;
                        o11.LeadSource=w1.LeadSource;
                        o11.StageName=w1.Stage;
                        oppList.add(o11); 
                        }
                    }
                    }
                    
                    
                }
                
            }
             
            
         }
        Set<String>lead=new Set<String>();
        List<Database.UpsertResult>upsertData=System.Database.upsert(oppList,Opportunity.ExternalId__c,true);
        for(Opportunity o:oppList){
            if(!String.isEmpty(o.LeadSource)){
                lead.add(o.LeadSource);
            }
        }
        Map<String,List<Contact>>mppNew=new Map<String,List<Contact>>();
        List<Contact>conDatass=[Select Lead_Source__c , Name , Email from Contact where Lead_Source__c IN : lead];
        for(Contact c:conDatass){
            if(mppNew.containsKey(c.Lead_Source__c)){
               mppNew.get(c.Lead_Source__c).add(c);
            }
            else{
                mppNew.put(c.Lead_Source__c,new List<Contact>{c});
            }
        }
        Map<Id,String>htmlMap=new Map<Id,String>();
        for(Opportunity o:oppList){
             String pdfContact='';            
            
            List<Contact>conNew=new List<Contact>();
            if(mppNew.containsKey(o.LeadSource)){
              conNew=mppNew.get(o.LeadSource);
            }
                
            for(Contact c:conNew){
                String new1='<p>Contact Name:'+c.Name+'</p><p>Contact email:'+c.Email+'</p>';
                pdfContact+=new1;
            }
            String htmlContent = '<html><body><h1>Hii'+nameMap.get(o.ExternalId__c)+'</h1> <p>A new opportunity is created in salesforce. Here are the details of it :- </p> <p>Opportunity Name:'+o.Name +'</p><p>Amount:-'+o.Amount+'</p><p>Created Date:'+Date.today()+'</p><p>Here are the details of the person you can contact:-</p>'+pdfContact+'</body></html>';

            htmlMap.put(o.Id,htmlContent);
        }
        for(Integer i=0;i<upsertData.size();i++){
            if(upsertData[i].isSuccess() && upsertData[i].isCreated()){
                ContentVersion cv=new ContentVersion();
                String htmlDatas=htmlMap.get(upsertData[i].getId());
                Blob pdfBlob = Blob.toPdf(htmlDatas);
                cv.Title ='DemoPDF.pdf';
                cv.PathOnClient='DemoPDF.pdf';
                cv.versionData = pdfBlob;
                cv.isMajorVersion = true;
                cv.FirstPublishLocationId =upsertData[i].getId();
                conVer.add(cv);
            }
        }
        System.debug(conVer);
        insert conVer;
        
    }
        
               
    public void finish(Database.BatchableContext bc){  
        
    }
    
}