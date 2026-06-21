import { LightningElement } from 'lwc';

import startProcess1
from '@salesforce/apex/DemoController.startProcess';
import { unsubscribe }
from 'lightning/empApi';
import { subscribe }
from 'lightning/empApi';

import { ShowToastEvent }
from 'lightning/platformShowToastEvent';

export default class PlatformEventDemo extends LightningElement {

    channelName = '/event/Job_Status__e';

    subscription = {};

    message = 'Waiting...';

    connectedCallback() {

        this.subscribeEvent();
    }

    subscribeEvent() {

        subscribe(
            this.channelName,
            -1,
            (response) => {

                console.log(response);

                this.message =
                response.data.payload.Message__c;

                this.dispatchEvent(
                    new ShowToastEvent({
                        title:'Success',
                        message:this.message,
                        variant:'success'
                    })
                );
            }
        ).then((response) => {

            this.subscription = response;

            console.log('Subscribed');
        });
    }

    async startProcess() {

        await startProcess1();
    }


    unsubscribeEvent() {

    unsubscribe(
        this.subscription,
        (response)=>{

            console.log(
                'Unsubscribed'
            );

        }
    );

    this.message='Waiting'

}
}