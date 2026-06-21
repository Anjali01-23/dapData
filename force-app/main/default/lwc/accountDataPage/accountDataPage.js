import { LightningElement , wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import fetchData from '@salesforce/apex/getRecordsWire.getRecords2';
import fetchData1 from '@salesforce/apex/getRecordsWire.getRecordsLess';
import fetchData2 from '@salesforce/apex/getRecordsWire.getRecordsMore';
import { refreshApex } from '@salesforce/apex';

export default class AccountDataPage extends LightningElement {
  
    recordId;
    accData;
    mainData;

    data1;
   // data2;
   value;
    wiredResult;

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.recordId = currentPageReference.state.c__recordId;
            console.log('Recordddd',this.recordId);
        }
    }
    data11;
    @wire(fetchData, {accId:'$recordId'})
    wiredData(result) {
        this.wiredResult=result;
        if (result.data) {
            this.data11=result.data;
            console.log('Datass',result.data);
            this.accData = this.data11[0];

            console.log('accccc',this.accData);
        } else if (result.error) {
            console.error(error);
        }
    }



    connectedCallback(){
        this.value=true;
        fetchData1({accId:this.recordId}).then(data=>{
            this.data1=data;
            console.log(this.data1);
        }).catch(error=>{
            console.log(error);
        })
    }

    viewAll(){
        fetchData2({accId:this.recordId}).then(data=>{
            this.data1=[];
            this.data1=data;
            console.log(this.data1);
        }).catch(error=>{
            console.log(error);
        })
        this.value=false;
    }

    hideAll(){
        fetchData1({accId:this.recordId}).then(data=>{
            this.data1=[];
            this.data1=data;
            console.log(this.data1);
        }).catch(error=>{
            console.log(error);
        })
        this.value=true;
    }

    istype=false;
    typeChange(){
     this.istype=true;
     console.log('type',this.istype);
    }

    handleSuccess(){
        this.istype=false;
        this.handleRefresh();
    }

    closeModaledit(){
        this.istype=false;
    }

    fields;
    istype1=false;
    typeChange1(event){
     this.istype1=true;
     console.log('type',this.istype1);
      this.fields=event.target.dataset.val;
    }

    handleSuccess1(){
        this.istype1=false;
        this.handleRefresh();
    }

    closeModaledit1(){
        this.istype1=false;
    }


    handleRefresh(){
        refreshApex(this.wiredResult);
    }

    saveData(){
        console.log('kkkkkk');
        this.template.querySelector('.editform').submit();
    }


//     handleOutsideClick(){
//     this.saveData();
// }

stopPropagation(event){
    event.stopPropagation();
}

}