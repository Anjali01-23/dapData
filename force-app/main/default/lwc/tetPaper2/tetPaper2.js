import { LightningElement, wire } from 'lwc';
import getData from '@salesforce/apex/getRecordsWire.getRecords1';
import { NavigationMixin } from "lightning/navigation";

export default class TetPaper2 extends NavigationMixin(LightningElement) {

    columns=[
    {label:'Sr.No.',fieldName:'serial'},
    {label:'Appointment Name',fieldName:'Name'},
    {label:'Appointment Type',fieldName:'Appointment_Type__c'},
    {label:'Status',fieldName:'Appointment_Status__c'},
    {label:'Appointment Date',fieldName:'Appointment_Date__c'},
    {
      label: "Account Name",
      type: "button",
      fieldName: "accId",
      typeAttributes: {
        label: {
          fieldName: "AccountName"
        },
        name: "view_account",
        variant: "base"
      }
    }
];

datass;

@wire(getData)records({data,error}){
    if(data){
        this.datass=data;
        console.log("Data",data);
        this.datass=data.map((rec,index)=>{
        return {
            ...rec,
            AccountName:rec.Account__r.Name?rec.Account__r.Name:'',
            accId:rec.Account__r?rec.Account__r.Id:'',
            serial:index+1
        }
    })
    }
    else{
       console.log(error);
    }
    
}

handleClick(){
        this[NavigationMixin.Navigate]({
                type: "standard__navItemPage",
                attributes: {
                    apiName:"Account_Data"
                },
                state:{ 
                c__recordId: this.accountIdd
                } 
            });
    }
accountIdd;

    handleRowAction(event){
        const actionname=event.detail.action.name;
        const rowData=event.detail.row;
        console.log(JSON.stringify(rowData));
        switch (actionname) {
         case 'view_account':
            this.accountIdd=rowData.accId
            console.log('Acuuu',this.accountIdd);
            this.handleClick();
    }
       

}

}