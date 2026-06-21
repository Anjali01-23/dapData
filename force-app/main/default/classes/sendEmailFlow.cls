public class sendEmailFlow {

  /*  public class InputWrapper{
        
        @InvocableVariable(required=true)
        public Id contactId;
    }

    @InvocableMethod(label='Send Email Action')
    public static void method(List<InputWrapper> inputs){

        Set<Id> conIds = new Set<Id>();

        for(InputWrapper inp : inputs){
            conIds.add(inp.contactId);
        }

        List<Contact> conList = [
            SELECT Id, Name, Email
            FROM Contact
            WHERE Id IN :conIds
        ];

        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        for(Contact c : conList){

            if(c.Email != null){

                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

                mail.setToAddresses(new List<String>{c.Email});
                mail.setSubject('Test Email From Flow');
                mail.setPlainTextBody('Hello ' + c.Name + ', Email sent successfully from Flow + Apex.');

                emails.add(mail);

                System.debug('Email Prepared For: ' + c.Email);
            }
        }

        if(!emails.isEmpty()){
            Messaging.sendEmail(emails);
            System.debug('Emails Sent Successfully');
        }
    }*/

    @InvocableMethod(label='Send Email Action')
    public static void method(List<Id>contactId){

        List<Contact> conList = [
            SELECT Id, Name, Email
            FROM Contact
            WHERE Id IN :contactId
        ];

        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        for(Contact c : conList){

            if(c.Email != null){

                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

                mail.setToAddresses(new List<String>{c.Email});
                mail.setSubject('Test Email From Flow');
                mail.setPlainTextBody('Hello ' + c.Name + ', Email sent successfully from Flow + Apex.');

                emails.add(mail);

                System.debug('Email Prepared For: ' + c.Email);
            }
        }

        if(!emails.isEmpty()){
            Messaging.sendEmail(emails);
            System.debug('Emails Sent Successfully');
        }
    }
}