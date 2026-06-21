global class csvContacts implements Database.Batchable<Contact>, Database.Stateful {
   
    global String csvColumnHeader;
    global List<String> csvRowValues = new List<String>();
    global Map<String,String>mpp;
    global List<Contact>scope;
    public csvContacts(Map<String,String>errorMap, List<Contact>conn){
        mpp=errorMap;
        scope=conn;
        System.debug('AAOOO'+errorMap);
        System.debug('iiii'+mpp);
    }
   
    global Iterable<Contact> start(Database.BatchableContext BC){
        System.debug('SCOPE is this'+scope);
        return scope;
    }
   
    global void execute(Database.BatchableContext BC, List<Contact> scope){
        //Process retrieved Account records and format field values.
        for(Contact con : scope){
            String Name = con.LastName!=null?con.LastName:'';
            String Id = con.Id!=null?String.valueOf(con.Id):'';
            String Phone = con.MobilePhone!=null?con.MobilePhone:'';
            String Email = con.Email!=null?con.Email:'';
            String error = mpp.get(Name)!=null?mpp.get(Name):'';
            String rowStr = Name + ',' + Id + ',' + Phone + ',' +Email+','+error;
            csvRowValues.add(rowStr);
        }
    }
   
    global void finish(Database.BatchableContext BC){
        String documentName = 'ContactsNew -'+ Datetime.now().format('MMM') + Datetime.now().year();
        csvColumnHeader = 'Name,Id,Phone,Email,Error\n';
        String csvFile = csvColumnHeader + String.join(csvRowValues,'\n');
        ContentVersion cv = new ContentVersion();
        cv.Title=documentName;
        cv.ContentLocation = 'S';
        cv.PathOnClient = 'Contacts.csv';
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