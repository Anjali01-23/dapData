public class transactionHandler {

    public static void method11(List<Transaction1__c>listTrans){
        for(Transaction1__c t: listTrans){
            if(t.Amount__c < 0){
                t.addError('Transaction could never be negative');
            }
            if(t.Date__c > Date.today()){
                t.addError('Transaction can never be in future');
            }
        }
        
    }
    
    public static void method22(List<Transaction1__c>listTrans){
  
        List<Id>userId=new List<Id>();
        for(Transaction1__c t: listTrans){
            userId.add(t.CreatedById);
        }
        List<AggregateResult>income=[SELECT SUM(Amount__c) , CreatedById FROM Transaction1__c WHERE  Type__c = 'Income' and CreatedById IN :userId Group By CreatedById];
        List<AggregateResult>expense=[SELECT SUM(Amount__c) , CreatedById FROM Transaction1__c WHERE  Type__c = 'Expense' and CreatedById IN :userId Group By CreatedById];
        Map<Id,Decimal>incomeMap=new Map<Id,Decimal>();
        Map<Id,Decimal>expenseMap=new Map<Id,Decimal>();
        
        for(AggregateResult a : income){
            incomeMap.put((Id)a.get('CreatedById'),(Decimal)a.get('expr0'));
        }
        for(AggregateResult a : expense){
            expenseMap.put((Id)a.get('CreatedById'),(Decimal)a.get('expr0'));
        }
        for(Transaction1__c t: listTrans){
            if(t.Type__c=='Expense'){
                Decimal incomeAmt=incomeMap.get(t.CreatedById);
                Decimal expenseAmt=expenseMap.get(t.CreatedById);
                expenseAmt+=t.Amount__c;
                if(incomeAmt<expenseAmt){
                    t.addError('Expense cannot be more than Income');
                }
            }
        }
        
    }
}