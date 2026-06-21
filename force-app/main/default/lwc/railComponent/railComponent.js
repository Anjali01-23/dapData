import { LightningElement, wire, track } from "lwc";
import getm1 from "@salesforce/apex/railClass.method1";
import getm2 from "@salesforce/apex/railClass.method2";
import getm3 from "@salesforce/apex/railClass.method3";
import getm4 from "@salesforce/apex/railClass.method4";
import getm5 from "@salesforce/apex/railClass.method5";
import getm6 from "@salesforce/apex/railClass.method6";
import getm7 from "@salesforce/apex/railClass.method7";
import getm8 from "@salesforce/apex/railClass.method8";
import getm9 from "@salesforce/apex/railClass.method9";
import { refreshApex } from '@salesforce/apex';
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getRemainingSeats
from '@salesforce/apex/railClass.getRemainingSeats';
export default class RailComponent extends NavigationMixin(LightningElement) {
  data0=0;
  data1=0;
  data2=0;
  data3=0;
  data4=0;
  data5=0;
  data6=0;
  data7=0;
  data8;

columns=[
    {label:'Reservation Number', fieldName:'Name'},
    {label:'Passenger Name', fieldName:'passName'},
    {label:'Train Number', fieldName:'trainNo'},
    {label:'Journey Date', fieldName:'Journey_Date__c', type:'date'},
    {label:'Status', fieldName:'Status__c'},
    {label:'Reservation Amount', fieldName:'Amount__c', type:'currency'},
    {label:'Action',  
         type: 'button',

         typeAttributes: {
             iconName: 'utility:preview',
             name: 'view_details',
             label: 'View',
             variant: 'border-filled'
         }
     } ,
]

    a0=[];
    pagelength=5;
    currentPage=1;
    totalPages=0;
    paginatedData;
    remainingSeats = 0;
  @wire(getm1) res1(result) {
    this.a0=result;
    if (result.data) {
      this.data0 = result.data;
      console.log("data", this.data0);
    } else {
      console.log(result.error);
    }
  }
handleTrainChange(event){
    const trainId = event.detail.value;
    const idss=trainId[0];
    console.log('Trainnn',JSON.parse(JSON.stringify(trainId)));
    getRemainingSeats({trainId: idss })
        .then(result => {
            this.remainingSeats = result;
        })
        .catch(error => {
            console.log(error);
        });
}

  @wire(getm2) res2({ data, error }) {
    if (data) {
      this.data1 = data;
      this.totalPages=Math.ceil(this.data1/this.pagelength);
      console.log("data", this.data1);
    } else {
      console.log(error);
    }
  }

  @wire(getm3) res3({ data, error }) {
    if (data) {
      this.data2 = data;
      console.log("data", this.data2);
    } else {
      console.log(error);
    }
  }

  @wire(getm4) res4({ data, error }) {
    if (data) {
      this.data3 = data;
      console.log("data", this.data3);
    } else {
      console.log(error);
    }
  }

  @wire(getm5) res5({ data, error }) {
    if (data) {
      this.data4 = data;
      console.log("data", this.data4);
    } else {
      console.log(error);
    }
  }

  @wire(getm6) res6({ data, error }) {
    if (data) {
      this.data5 = data;
      console.log("data today", this.data5);
    } else {
      console.log(error);
    }
  }

  @wire(getm7) res7({ data, error }) {
    if (data) {
      this.data6 = data;
      console.log("data", this.data6);
    } else {
      console.log(error);
    }
  }

  @wire(getm8) res8({ data, error }) {
    if (data) {
      this.data7 = data;
      console.log("data", this.data7);
    } else {
      console.log(error);
    }
  }
  val1='';
  val2='';
  handle1(event){
    this.val1=event.detail.value;
  }

  handle2(event){
    this.val2=event.detail.value;
  }
@track wholeData=[];
  @wire(getm9,{TrainNo : '$val1', BookingId : '$val2',pagesize: '$pagelength', current: '$currentPage'}) res9(result) {
    this.wholeData=result;
    if (result.data) {
      this.paginatedData= result.data.map(rec=>{
        return{
            ...rec,
            passName:rec.Passenger11__c ? rec.Passenger11__r.Name :'',
            trainNo:rec.Train11__c ? rec.Train11__r.Name: ''
        }
      })
      console.log("data", this.data8);
    } else {
      console.log(result.error);
    }
  }

  async handleRefreshAll() {
          const refreshPromises = [];
          if (this.a0) {
              refreshPromises.push(refreshApex(this.a0));
          }
        //   if (this.a1) {
        //       refreshPromises.push(refreshApex(this.a1));
        //   }
        //   if (this.a2) {
        //       refreshPromises.push(refreshApex(this.a2));
        //   }
        //   if (this.a3) {
        //       refreshPromises.push(refreshApex(this.a3));
        //   }
        //   if (this.diffData) {
        //       refreshPromises.push(refreshApex(this.diffData));
        //   }
  
          try {
          await Promise.all(refreshPromises);
          console.log('Refresh complete');
        } catch (error) {
          console.error('Error refreshing data', error);
        }
      }

      connectedCallback(){
         const intervalId = setInterval(() => {
          this.handleRefreshAll();
        }, 30000);
      }

      refresh1(){
        this.handleRefreshAll();
      }

      refresh2(){
        return refreshApex(this.wholeData);
      }
   isEditModal=false;
    openModal(){
      this.isEditModal=true;
    }

    closeModaledit() {
    this.isEditModal = false;
  }



  savehandle() {
    this.isEditModal = false;

    refreshApex(this.wholeData).then(() => {
      const event = new ShowToastEvent({
        title: "Success",
        message: "Record Updated",
        variant: "success"
      });
      this.dispatchEvent(event);
    });
  }

  errorhandle() {
    this.isEditModal = false;
    const event = new ShowToastEvent({
      title: "Failed",
      message: "Record Updation Failed",
      variant: "error"
    });
    this.dispatchEvent(event);
  }
 
  handleClick(){
    
  }

  // handleRowAction(event) {
       
  //       const actionName = event.detail.action.name;
        
        
  //       const rowId = event.detail.row.Id;

        
  //       switch (actionName) {
  //           case 'view_details':
  //               this[NavigationMixin.Navigate]({
  //                           type: 'standard__recordPage',
  //                           attributes: {
  //                               recordId: rowId,
  //                               objectApiName: "Booking__c",
  //                               actionName: "view"
  //                           }
  //                       });
  //               break;
  //           default:
  //               break;
  //       }
  //   }





    disconnectedCallback() {
    clearInterval(this.intervalId);
}





    

handlePrevious() {
        if (this.currentPage > 1) {
            this.currentPage--;
            
        }

    }

    handleNext() {
        if (this.currentPage < this.totalPages) {
            this.currentPage++;
        }
    }

    get isPreviousDisabled() {
        return this.currentPage === 1;
    }

    get isNextDisabled() {
        return this.currentPage === this.totalPages;
    }




    handleRowAction(event) {

 
        const rowId = event.target.dataset.id;

        
       
                this[NavigationMixin.Navigate]({
                            type: 'standard__recordPage',
                            attributes: {
                                recordId: rowId,
                                objectApiName: "Booking__c",
                                actionName: "view"
                            }
                        });
                
        }
    
}

