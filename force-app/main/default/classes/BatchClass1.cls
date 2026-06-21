global class BatchClass1 implements Database.Batchable<WrapperClass> , Database.Stateful{
    global Map<String,String>errorMap=new Map<String,String>();
    global Map<String,String>errorMap1=new Map<String,String>();
    global List<Account>accDataMain=new List<Account>() ;
    global List<Contact>conListMain=new List<Contact>();
    
    public List<WrapperClass> accConList;
    public BatchClass1(List<WrapperClass>accList){
        accConList=accList;
    }
    
    public Iterable<WrapperClass> start(Database.BatchableContext bc){
        return accConList;
    }
    public void execute(Database.BatchableContext bc,List<WrapperClass>accConList){
       List<Account>accData=new List<Account>() ;
        for(WrapperClass w:accConList){
            Account a=new Account();
            a.Name=w.Name;
            a.Phone=w.Phone;
            
            accData.add(a);
        }
        
        List<Database.saveResult>saves=System.Database.insert(accData,false);
        Integer i=0;
        for(Database.saveResult s:saves){
            if(!s.isSuccess()){
                errorMap.put(accData[i].Name,s.getErrors()[0].getMessage());
            }
            i++;
        }
        Map<String,String>mpp=new Map<String,String>();
        for(Account a:accData){
            mpp.put(a.Name,a.Id);
        }
        
       
        List<Contact>conList=new List<Contact>();
        for(WrapperClass w:accConList){
            List<WrapperClass.ContactWrapper> con =w.Contacts;
            String accId=mpp.get(w.Name);
            for(WrapperClass.ContactWrapper wc:con){
              Contact c=new Contact();
              c.LastName= wc.LastName;
              c.Email=wc.Email;
              c.MobilePhone=wc.MobilePhone;
              c.AccountId=accId;
              conList.add(c);          
            }
        }
        
        List<Database.saveResult>saves1=System.Database.insert(conList,false);
        Integer i1=0;
        for(Database.saveResult s:saves1){
            if(!s.isSuccess()){
                String err='';
                for(Database.error e:s.getErrors()){
                    err+=e.getMessage();
                }
                errorMap1.put(conList[i1].LastName,err);
            }
            i1++;
        }
        
        for(Account a:accData){
            accDataMain.add(a);
        }
        
        for(Contact c: conList){
            conListMain.add(c);
        }
       
    }
    public void finish(Database.BatchableContext bc){  
         System.debug('ErrorMap0'+errorMap);
        System.debug('ErrorMap1'+errorMap1);
        System.debug('Scope is'+conListMain);
        csvAccounts obj1=new csvAccounts(errorMap,accDataMain);
        System.Database.executeBatch(obj1,200);
        
        csvContacts obj2=new csvContacts(errorMap1,conListMain);
        System.Database.executeBatch(obj2,200);
    }
    
}