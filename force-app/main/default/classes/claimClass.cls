public class claimClass {

    public static void method1(List<Claim__c>claims){
      List<Id>idss= new List<Id>();
        for(Claim__c c:claims){
            idss.add(c.Policy__c);
        }
        List<Policy__c>policyData=[SELECT Id , Status__c , Policy_Amount__c FROM Policy__c where ID IN :idss];
        Map<Id,String>mapp=new Map<Id,String>();
        Map<Id,Decimal>mpp=new Map<Id,Decimal>();
        for(Policy__c p: policyData){
            mapp.put(p.Id,p.Status__c);
            mpp.put(p.Id,p.Policy_Amount__c);
        }
        
        for(Claim__c c: claims){
            if(mapp.containsKey(c.Policy__c)){
                if(mapp.get(c.Policy__c)!='Active'){
                    c.addError('Policy is not Active');
                }
            }    
            if(mpp.containsKey(c.Policy__c)){
               if(mpp.get(c.Policy__c)<c.Claim_Amount__c){
                    c.addError('Claim Amount is larger than Policy Amount');
                } 
            }
            
            c.Claim_Status__c='Pending';
        }
    }
    
    public static void method2(List<Claim__c>claims){
        List<Id>customers=new List<Id>();
        List<Id>policies=new List<Id>();
        List<Id>delRec=new List<Id>();
        for(Claim__c c:claims){
            customers.add(c.Account__c);
            policies.add(c.Policy__c);
        }
        List<Claim__c>claimss=[Select Id , Account__c , Policy__c , Claim_Amount__c from Claim__c where Policy__c IN :policies and  Account__c IN :customers and CreatedDate = LAST_N_DAYS:30];
        
        Map<Id,Id>mppNew=new Map<Id,Id>();
        Map<Id,Id>map1=new Map<Id,Id>();
        Map<Id,Claim__c>map2=new Map<Id,Claim__c>();
        for(Claim__c c:claimss){
            mppNew.put(c.Account__c,c.Policy__c);
            map1.put(c.Account__c,c.Id);
            map2.put(c.Account__c,c);
        }
        
        for(Claim__c c:claims){
            if(mppNew.containsKey(c.Account__c)){
                if(mppNew.get(c.Account__c)==c.Policy__c){
                    delRec.add(map1.get(c.Account__c));
                    Claim__c c1=map2.get(c.Account__c);
                    c.Claim_Amount__c+=c1.Claim_Amount__c;
                }
            }
        }
        List<Claim__c>claimDel=[Select Id , Claim_Amount__c, Policy__c from Claim__c where ID IN :delRec];
        delete claimDel;
    }
    
  /*  public static void method3(List<Claim__c>claims){
        Map<Id,Decimal>mpp=new Map<Id,Decimal>();
        List<Id>polyId=new List<Id>();
        for(Claim__c c:claims){
            mpp.put(c.Policy__c,c.Claim_Amount__c);
            polyId.add(c.Policy__c);
        }
        List<Policy__c>poly=[Select Policy_Amount__c , Id from Policy__c where ID IN :polyId];
        for(Policy__c p:poly){
            if(mpp.containsKey(p.Id)){
                p.Policy_Amount__c-=mpp.get(p.Id);
            }
        }
        update poly;
    }*/
    
   /* public static void method4(List<Claim__c>claims){
        Map<Id,Decimal>mpp=new Map<Id,Decimal>();
        List<Id>delIds=new List<Id>();
        for(Claim__c c:claims){
            delIds.add(c.Id);
        }
        List <Claim__c>claimsNew=[Select Id , Claim_Amount__c, Policy__c from Claim__c where ID IN :delIds ];
        for(Claim__c c:claimsNew){
            if(mpp.containsKey(c.Policy__c)){
                mpp.put(c.Policy__c,mpp.get(c.Policy__c)+c.Claim_Amount__c);
            }
            else{
                mpp.put(c.Policy__c,c.Claim_Amount__c);
            }
        }
        List<Policy__c>polyData=[Select Policy_Amount__c , Id from Policy__c where ID IN :mpp.keySet()];
        for(Policy__c p:polyData){
            if(mpp.containsKey(p.Id)){
                P.Policy_Amount__c+=mpp.get(p.Id);
            }
        }
        
        update polyData;
    } */
    
    public static void method5(List<Claim__c>claims){
        List<Id>customers=new List<Id>();
        List<Id>policies=new List<Id>();
        List<String>hos=new List<String>();
         for(Claim__c c:claims){
            customers.add(c.Account__c);
            policies.add(c.Policy__c);
            hos.add(c.Hospital__c);
        }
        List<Policy__c>pData=[Select Id, Policy_Amount__c , Policy_Activation_Date__c from Policy__c where ID IN :policies];
        List<Account>cusData=[Select Id , Age__c, Previous_Fraud_History__c from Account where ID IN :customers];
        Map<Id,Policy__c>mpp=new Map<Id,Policy__c>();
        Map<Id,Account>acc=new Map<Id,Account>();
        for(Policy__c p:pData){
            mpp.put(p.Id,p);
        }
        for(Account a:cusData){
            acc.put(a.Id,a);
        }
        List<Id>claimIdss=new List<Id>();
        Map<Id,Policy__c>mppMain=new Map<Id,Policy__c>();
        Map<Id,Account>mppMain2=new Map<Id,Account>();
        for(Claim__c c:claims){
            mppMain.put(c.Policy__c,mpp.get(c.Policy__c));
            mppMain2.put(c.Account__c,acc.get(c.Account__c));
            claimIdss.add(c.Id);
        }
        List<ContentVersion>contentList=[Select Id ,  Title , FirstPublishLocationId from ContentVersion where FirstPublishLocationId IN : claimIdss];
        Map<Id,List<ContentVersion>> contentMap=new Map<Id,List<ContentVersion>> ();
        for(ContentVersion con:contentList){
            if(!contentMap.containsKey(con.FirstPublishLocationId)){
            contentMap.put(con.FirstPublishLocationId,new List<ContentVersion>{con});                
            }else{
                contentMap.get(con.FirstPublishLocationId).add(con);
            }
        }
        List<Claim__c>claim6=[Select Id from Claim__c where Account__c IN :customers and CreatedDate= LAST_N_MONTHS:6];
        List<Claim__c>claim7=[Select Id , 	Hospital__c from Claim__c where Account__c IN :customers and Hospital__c IN :hos];
        Map<Id,Integer>mppCount=new Map<Id,Integer>();
        Map<Id,List<String>>hosData=new Map<Id,List<String>>();
        for(Claim__c c:claim7){
            if(hosData.containsKey(c.Account__c)){
                hosData.get(c.Account__c).add(c.Hospital__c);
            }
            else{
                hosData.put(c.Account__c,new List<String>{c.Hospital__c});
            }
        }
        for(Claim__c c:claim6){
            if(mppCount.containsKey(c.Account__c)){
                mppCount.put(c.Account__c,mppCount.get(c.Account__c)+1);
            }
            else{
                mppCount.put(c.Account__c,1);
            }
        }
        
        for(Claim__c c :claims){
            Integer score=0;
            String level='';
            String pri='';
            Policy__c p=mppMain.get(c.Policy__c);
            Account a=mppMain2.get(c.Account__c);
            Integer diff=p.Policy_Activation_Date__c.daysBetween(Date.today());
            List<ContentVersion>cList=new List<ContentVersion>();
            if(contentMap.containsKey(c.Id)){
               cList=contentMap.get(c.Id); 
            }
            
            List<String>namess=new List<String>();
            if(!cList.isEmpty()){
                for(ContentVersion cV:cList){
                namess.add(cv.Title);
                }
            }
            
            List<String> mandatoryDocs = new List<String>{'Aadhaar','PAN','Medical Report', 'Hospital Invoice'};
                for(String m: mandatoryDocs){
                    
                    if(!namess.contains(m)){
                        score+=20;
                        System.debug('1');
                        break;
                    }
                }
            Datetime dt = System.now();
            String dtIST = dt.format('yyyy-MM-dd HH:mm:ss', 'IST');
            System.debug('dtIST-' + dtIST);

            Time time12Am = Time.newInstance(0, 0, 0, 0);
            Time time1Am  = Time.newInstance(1, 0, 0, 0);

            // Extract the exact IST time component
            Datetime tempIstDt = Datetime.valueOfGmt(dtIST);
            Time currentIstTime = tempIstDt.timeGmt();


            if(c.Claim_Amount__c> 500000){
                score+=30;
                System.debug('2');

            }
            if(diff <=15){
                score+=40;
                System.debug('3');
            }
            
            if(mppCount.get(c.Account__c)>3){
                score+=25;
                System.debug('4');
            }
            
            if(a.Age__c>60){
                score+=15;
                System.debug('5');
            }
            
            if(a.Previous_Fraud_History__c==true){
                score+=50;
                System.debug('6');
            }
            if(hosData.containsKey(a.Id)){
             if(!hosData.get(a.Id).isEmpty()){
                if(hosData.get(a.Id).contains(c.Hospital__c)){
                     score+=10;
                     System.debug('7');
                }
               
            }
            }
            
            
            if (currentIstTime >= time12Am && currentIstTime < time1Am) {
                score+=10;
                System.debug('8');
             }
            
            
            
            if(score>=0 && score <=30){
                level='Low-Risk';
            }
            else if(score >=31 && score <=60){
                level='Medium Risk';
            }
            else if(score > 60){
                level='High Risk';
            }
            
            if(level=='Low-Risk'){
                pri='Low';
            }
            else if(level=='Medium Risk'){
               pri='Medium'; 
            }
            else {
                pri='High';
            }
            c.Risk_Score__c=score;
            c.RiskLevel__c=level;
            c.Priority__c=pri;
            
            
            
        }
    }
    
    public static void method6(List<Claim__c>claims){
         List<Platform2__e> list1=new List<Platform2__e>();
        for(Claim__c c:claims){
             if(c.RiskLevel__c=='High Risk' || c.Claim_Amount__c>700000){             
                Platform2__e p1=new Platform2__e();
                p1.ClaimId__c=c.Id;
                p1.CustomerId__c=c.Account__c;
                p1.PolicyId__c=c.Policy__c;
                list1.add(p1);
            }
        }
        EventBus.publish(list1);
       
    }
    
    
    public static void submitForApproval(List<Claim__c> claimss){

    List<Approval.ProcessSubmitRequest> reqs =new List<Approval.ProcessSubmitRequest>();

    for(Claim__c c : claimss){
        if(c.Claim_Status__c != 'Frozen'){

            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setObjectId(c.Id);
            req.setComments('Submitted via Apex');
            reqs.add(req);
        }
    }

    if(!reqs.isEmpty()){
        Approval.ProcessResult[] results = Approval.process(reqs);
    }
}
    
    
    public static void methodUpdate(List<Claim__c>claims){
        Map<Id,Decimal>mpp=new Map<Id,Decimal>();
        List<Id>polyId=new List<Id>();
        for(Claim__c c:claims){
            if(c.Claim_Status__c=='Approved'){
                 mpp.put(c.Policy__c,c.Claim_Amount__c);
                 polyId.add(c.Policy__c);
            }       
        }
        List<Policy__c>poly=[Select Policy_Amount__c , Id from Policy__c where ID IN :polyId];
        for(Policy__c p:poly){
            if(mpp.containsKey(p.Id)){
                p.Policy_Amount__c-=mpp.get(p.Id);
            }
        }
        update poly;
    }
    
    public static void newMethod(List<ContentVersion>fileList){
        Set<id> currentUploadNames = new Set<id>();
        Set<String> titles = new Set<String>();
        Set<String> existingNames = new Set<String>();
        set<id>existingid=new set<id>();
        for(ContentVersion cv : fileList){
            currentUploadNames.add(cv.FirstPublishLocationId);            
        }
        
        List<ContentVersion> existingFiles =[select Id,Title,FirstPublishLocationId from ContentVersion where FirstPublishLocationId IN :currentUploadNames];
        for(ContentVersion cv : existingFiles){
            titles.add(cv.title);
            existingid.add(cv.FirstPublishLocationId);
        }
        for(ContentVersion cv : fileList){
            system.debug(cv);
            system.debug(cv.FirstPublishLocationId);
            if(cv.PathOnClient != null && !cv.PathOnClient.toLowerCase().endsWith('.pdf')
            ){
                cv.addError('Only PDF documents are allowed');
            }
            if(cv.ContentSize > 5000000){
                cv.addError('Document size cannot exceed 5 MB');

            }
            if(titles.contains(cv.Title)&&existingid.contains(cv.FirstPublishLocationId)){
                cv.addError( 'Duplicate document uploaded');
            }
			

            if(existingNames.contains(cv.Title)){
                cv.addError('Document already exists');
            }
        }
    }
    
}