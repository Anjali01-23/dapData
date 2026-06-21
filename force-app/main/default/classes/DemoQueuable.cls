public class DemoQueuable implements Queueable {

    public void execute(QueueableContext qc) {

        // Simulate processing

        Integer total = 0;

        for(Integer i=1;i<=10000;i++){
            total += i;
        }

        Job_Status__e evt = new Job_Status__e(
            Message__c = 'Processing Completed Successfully'
        );

        EventBus.publish(evt);
    }
}