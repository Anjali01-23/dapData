public class OrderClassHandler {
 
    public static void method1(List<Order1__c>orders){
        for(Order1__c o:orders){
            if(o.Order_Date__c > System.TODAY()){
                o.addError('Order Date cannot be set in the future');
            }
        }
    }
    
    public static void method2(List<PartOrder__c>Partorders){
        for(PartOrder__c o:Partorders){
            if(o.Price__c< 0){
                o.addError('Price cannot be negative');
            }
        }
    }
    
    public static void method3(List<Part__c>parts){
      //  List<Part__c>partUpdate=[Select Stock_Quantity__c, Warehouse__c from Part__c where ID IN :parts];
      
        Map<Id,Decimal>mapp=new Map<Id,Decimal>();
        List<Id>warehouseIds=new List<Id>();
        for(Part__c p:parts){
            if(p.Warehouse__c!=null){
                warehouseIds.add(p.Warehouse__c);
            if(mapp.containsKey(p.Warehouse__c)){
                mapp.put(p.Warehouse__c,mapp.get(p.Warehouse__c)+p.Stock_Quantity__c);
            }
            else{
                mapp.put(p.Warehouse__c,p.Stock_Quantity__c);
            }       
            }
        }
        List<AggregateResult>result=[Select Warehouse__c , SUM(Stock_Quantity__c)sum from Part__c where Warehouse__c IN:warehouseIds AND ID NOT IN :parts GROUP BY Warehouse__c ];
        List<Warehouse__c>ware=[Select ID, Capacity__c from Warehouse__c where ID IN : warehouseIds];
        
        Map<Id,Decimal>mpp=new Map<Id,Decimal>();
        for(AggregateResult ar: result){
            mpp.put((Id)ar.get('Warehouse__c'),(Decimal)ar.get('sum'));
        }
        List<Id>lists=new List<Id>();
        for(Warehouse__c w:ware){
            Decimal existing=0;
            Decimal neww=0;
            if(mapp.containsKey(w.Id)){
               neww= mapp.get(w.Id);
            }
            if(mpp.containsKey(w.Id)){
               existing= mpp.get(w.Id);
            }
            if(existing+ neww > w.Capacity__c){
                lists.add(w.Id);
            }
        }
        
        for(Part__c p:parts){
            if(lists.contains(p.Warehouse__c)){
                p.addError('Inventory Total should be less than Warehouse Capacity');
            }
        }
        
    }
    
    public static void method4(List<Part__c>parts){
       List<Id>warehouseIds=new List<Id>();
        for(Part__c p:parts){
            if(p.Warehouse__c!=null){
                warehouseIds.add(p.Warehouse__c); 
            }
        }
        List<Warehouse__c>ware=[Select ID, Location__c from Warehouse__c where ID IN : warehouseIds];
        Map<Id, String>mapp=new Map<Id, String>();
        for(Warehouse__c w:ware){
            mapp.put(w.Id,w.Location__c);
        }
       
        for(Part__c p:parts){
            p.Warehouse_Location__c=mapp.get(p.Warehouse__c);
        }        
    }
    
    public static void method5(List<Order1__c>orders){
        for(Order1__c o:orders){
            o.Order_Status__c='Pending';
        }
    }
    
    public static void method6(List<PartOrder__c>partss){
        Map<Id,Decimal>mpp=new Map<Id,Decimal>();
        for(PartOrder__c p:partss){
            if(mpp.containsKey(p.Part__c)){
                mpp.put(p.Part__c,mpp.get(p.Part__c)+p.Quantity__c);
            }
            else{
                mpp.put(p.Part__c,p.Quantity__c);
            }
        }
        List<Part__c>parts=[Select ID , Stock_Quantity__c from Part__c where ID IN :mpp.keySet()];
        for(Part__c p:parts){
            p.Stock_Quantity__c-=mpp.get(p.Id);
        }
        update parts;
    }
    
    public static void method7(List<Part__c>parts){
        CustomNotificationType cnType = [SELECT Id FROM CustomNotificationType WHERE DeveloperName = 'CustomNotification'];
        Id userId = Userinfo.getUserId();
        List<Id>wareIds=new List<Id>();
        for(Part__c p:parts){
            wareIds.add(p.Warehouse__c);
        }
        List<Warehouse__c>ware=[Select Manager__c ,Manager__r.CreatedById,  Id from Warehouse__c where ID IN :wareIds];
        Map<Id,Id>mpp=new Map<Id,Id>();
        for(Warehouse__c w:ware){
            mpp.put(w.Id,w.Manager__r.CreatedById);
        }
        
        for(Part__c p:parts){
            if(p.Stock_Quantity__c<p.Minimum_Stock_Level__c){
                Messaging.CustomNotification customNotificationObj = new Messaging.CustomNotification();
                customNotificationObj.setBody('Please check the details');
                customNotificationObj.setTitle('Stock level is less than Minimum Level !!');
                customNotificationObj.setNotificationTypeId(cnType.id);
                customNotificationObj.setSenderId(userId);
                customNotificationObj.setTargetId(p.Id);
                customNotificationObj.send(new Set<String> {mpp.get(p.Warehouse__c)});
                System.debug('Custom'+ customNotificationObj);
                System.debug('Id'+ mpp.get(p.Warehouse__c));
                
            }
        }   
    }
    
    public static void method8(List<Part__c>parts){
        Id userId = Userinfo.getUserId();
        List<Id>wareIds=new List<Id>();
        for(Part__c p:parts){
            wareIds.add(p.Warehouse__c);
        }
        List<Warehouse__c>ware=[Select Manager__c ,Manager__r.Email_Address__c,  Id from Warehouse__c where ID IN :wareIds];
        Map<Id,String>mpp=new Map<Id,String>();
        for(Warehouse__c w:ware){
            mpp.put(w.Id,w.Manager__r.Email_Address__c);
        }
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        OrgWideEmailAddress owea =[SELECT Id FROM OrgWideEmailAddress WHERE Address = 'anjaligoyal4102@gmail.com' LIMIT 1];
        
        for(Part__c p:parts){
            if(p.Stock_Quantity__c<p.Minimum_Stock_Level__c){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new List<String>{mpp.get(p.Warehouse__c)});
                mail.setOrgWideEmailAddressId(owea.Id);
                System.debug('Owea'+owea);
                mail.setSubject('Stock Level Alert for '+p.Name);
                mail.setPlainTextBody('Dear Warehouse Manager,                                                                                                           '+
                                     'The stock level for the following part has fallen below the minimum stock level.                                                    '+              
                                     '- Part Name:'+ p.Name+'                                                                                                                 '+    
                                     '- Part Id:'+ p.Id+'                                                                                                                      '+
                                     '- Current Stock Quantity:'+ p.Stock_Quantity__c+'                                                                                            '+
                                     '- Minimum Stock Level:'+ p.Minimum_Stock_Level__c+'                                                                                           '+
                                     'Please take the necessary actions to reorder this part.                                                                                            '+
                                     'Thankyou                                                                                                                                          '+
                                     'TruckPartPro Inventory Management Team'
                                      );
                
                mails.add(mail);
            }
        }
        System.debug('Mails'+mails);
        try{
            
           Messaging.SendEmailResult[] results = Messaging.sendEmail( mails);
            System.debug(results);
        }
        catch(Exception e){
            System.debug(e.getMessage());
        }
        
    }
}