global class csvAccounts implements Database.Batchable<Account>, Database.Stateful {
   
    global String csvColumnHeader;
    global List<String> csvRowValues = new List<String>();
    global Map<String,String>mpp;
    global List<Account>scope;
    public csvAccounts(Map<String,String>errorMap, List<Account>accounts){
        mpp=errorMap;
        scope=accounts;
    }
    global Iterable<Account> start(Database.BatchableContext BC){
        return scope;
    }
   
    global void execute(Database.BatchableContext BC, List<Account> scope){
        //Process retrieved Account records and format field values.
        for(Account acc : scope){
            String Name = acc.Name!=null?acc.Name:'';
            String Id = acc.Id!=null?acc.Id:'';
            String Phone = acc.Phone!=null?acc.Phone:'';
            String error = mpp.get(Name)!=null?mpp.get(Name):'';
            String rowStr = Name + ',' + Id + ',' + Phone + ','+ error;
            csvRowValues.add(rowStr);
        }
    }
   
    global void finish(Database.BatchableContext BC){
        String documentName = 'AccountsNew-'+ Datetime.now().format('MMM') + Datetime.now().year();
        csvColumnHeader = 'Name,Id,Phone,Error\n';
        String csvFile = csvColumnHeader + String.join(csvRowValues,'\n');
        ContentVersion cv = new ContentVersion();
        cv.Title=documentName;
        cv.ContentLocation = 'S';
        cv.PathOnClient = 'Accounts.csv';
        cv.VersionData = Blob.valueOf(csvFile);
        insert cv;
        
        
        OrgWideEmailAddress owea =[SELECT Id FROM OrgWideEmailAddress WHERE Address = 'anjaligoyal4102@gmail.com' LIMIT 1];

        try{
        Messaging.EmailFileAttachment csvAttachment = new Messaging.EmailFileAttachment();
        Blob csvBlob = blob.valueOf(csvFile);
        String csvName = 'CsvFileName.csv';
        csvAttachment.setFileName(csvName);
        csvAttachment.setBody(csvBlob);
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[]{'anjaligoyal@cyntexa.com'};
        String subject = 'CSV Data Email';
        email.setSubject(subject);
        email.setToAddresses(toAddresses);
        email.setPlainTextBody('Test CSV Email');
        email.setOrgWideEmailAddressId(owea.Id);
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttachment});
        Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
        if (r[0].success) {
            System.debug('The email was sent successfully.');
           
        } else {
            System.debug('The email failed to send: ' + r[0].errors[0].message);
        }
    }
    catch(Exception EX)
    {
        System.debug('The email failed to send: ' + Ex.getMessage());
    }

 
    }
}