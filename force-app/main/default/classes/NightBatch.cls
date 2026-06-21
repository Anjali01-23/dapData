global class NightBatch implements Database.Batchable<SObject>,
                                  Schedulable,
                                  Database.Stateful{

    global Database.QueryLocator start(Database.BatchableContext bc){

        return Database.getQueryLocator(
            'SELECT Id, Passenger11__c, Journey_Date__c, Amount__c,' +
            ' Paid__c, Train11__c, Status__c, CreatedDate ' +
            'FROM Booking__c ' +
            'WHERE Paid__c = false ' +
            'AND Status__c = \'Confirmed\''
        );
    }

    global void execute(Database.BatchableContext bc,
                        List<Booking__c> bookList){

        Set<Id> passIds = new Set<Id>();

        for(Booking__c b : bookList){
            if(b.Passenger11__c != null){
                passIds.add(b.Passenger11__c);
            }
        }

        Map<Id, Passenger11__c> passMap =
            new Map<Id, Passenger11__c>(
                [SELECT Id, Email__c, Name
                 FROM Passenger11__c
                 WHERE Id IN :passIds]
            );

        List<Booking__c> bookingsToUpdate = new List<Booking__c>();
        List<Messaging.SingleEmailMessage> emails =
            new List<Messaging.SingleEmailMessage>();

        for(Booking__c b : bookList){

            Integer diff =
                b.CreatedDate.date().daysBetween(Date.today());

            if(diff > 5){

                b.Status__c = 'Released';
                bookingsToUpdate.add(b);

            }else{

                Passenger11__c p =
                    passMap.get(b.Passenger11__c);

                if(p != null &&
                   String.isNotBlank(p.Email__c)){

                    Messaging.SingleEmailMessage mail =
                        new Messaging.SingleEmailMessage();

                    mail.setToAddresses(
                        new List<String>{p.Email__c}
                    );

                    mail.setSubject(
                        'Payment Pending For Train Booking'
                    );

                    mail.setPlainTextBody(
                        'Dear Passenger,\n\n' +
                        'Your booking payment is still pending.' +
                        ' Please complete payment before the booking is released.\n\n' +
                        'Booking Id: ' + b.Id
                    );

                    emails.add(mail);
                }
            }
        }

        if(!bookingsToUpdate.isEmpty()){
            update bookingsToUpdate;
        }

        if(!emails.isEmpty()){
            Messaging.sendEmail(emails);
        }
    }

    global void finish(Database.BatchableContext bc){


    }

    global void execute(SchedulableContext sc){

        Database.executeBatch(
            new NightBatch(),
            200
        );
    }
}