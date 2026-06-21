import LightningModal from 'lightning/modal';

export default class NewDemoModal extends LightningModal {
    header='Add Field';
    valuess='';

    closeIt(){
        this.valuess='';
        this.close();
     }
     forward(){
        this.close(this.valuess);
     }

     handleChange(event){
        this.valuess=event.target.value;
     }
}