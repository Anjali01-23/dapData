import { LightningElement} from 'lwc';
import doSomething from '@salesforce/apex/AccountController.doSomething';

export default class MyAction extends LightningElement {
 

    connectedCallback() {
        doSomething()
            .then(() => {
                console.log('Success');
            })
            .catch(error => {
                console.error(error);
            });
    }
}