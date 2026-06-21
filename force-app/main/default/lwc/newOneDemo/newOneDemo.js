import LightningModal from 'lightning/modal';
import { api } from 'lwc';
export default class NewOneDemo extends LightningModal {
    header='Movie Details';
    valuess='';
    @api details;
    closeIt(){
        this.close();
     }
    
    
}