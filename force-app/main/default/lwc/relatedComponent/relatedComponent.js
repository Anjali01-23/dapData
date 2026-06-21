import { LightningElement , api, wire ,track} from 'lwc';
import { getRecord , getFieldValue} from 'lightning/uiRecordApi';
import getRelated from '@salesforce/apex/relatedClass.getData';
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class RelatedComponent extends NavigationMixin(LightningElement) {
 
    @api recordId;
    @api objectApiName;
    relatedRecord;
    datas;
    newData=[];

    @wire(getRelated, {objectName: '$objectApiName', recordId:'$recordId'})
    relatedData(result) {
        console.log('Data is');
        console.log(result);
        if(result.data) {
            this.datas=result.data;
            console.log("data is");
            console.log(this.datas);
            this.datas.forEach(element => {
                this.newData.push(element.objectName);
            });

            this.datas=this.datas.map(rec=>{
                return{
                    ...rec,
                    records:rec.records.map((data1,index)=>{
                        return {
                            ...data1,
                            serial:index+1
                        }
                    })
                }
            })
    }
};

    @wire(getRecord, {
        recordId: '$recordId',
        fields: '$field'
    })
    record;

    get field(){
        return [`${this.objectApiName}.Name`];
    }

    get name(){
        return getFieldValue(this.record.data, this.field[0]);
    }
    @track activeSections=[];
    

    handletoggle(){
        console.log("New",this.newData);
        this.activeSections=[...this.newData];
        // console.log("All Sections are ",this.datas);
        // console.log("Active Sections ye h ",JSON.stringify(this.activeSections));
    }

    handleNavigation(event){
        console.log("Event",event);
     this[NavigationMixin.Navigate]({
        type: 'standard__objectPage',
        attributes: {
            objectApiName:event.target.dataset.object,
            actionName: 'list'
        },
        state: {
            filterName: 'Recent'
        }
    });
    }

    handleNew(event){
       this[NavigationMixin.Navigate]({
        type: 'standard__objectPage',
        attributes: {
            objectApiName:event.target.dataset.object,
            actionName: 'new'
        }
    }); 
    }

    handleEdit(event){
        console.log("RecordId",event.target.dataset.id);
        console.log("RecordId",event.target.dataset.name);
     this[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
        attributes: {
            objectApiName:event.target.dataset.name,
            actionName: 'edit',
            recordId:event.target.dataset.id
        }
    }); 
    }
    handleCopy(event){
      const baseUrl = window.location.origin;
      const recordId=event.target.dataset.id;
      const link=`${baseUrl}/${recordId}`;
      try {
            const textarea = document.createElement('textarea');
            textarea.value = link;
            document.body.appendChild(textarea);

            textarea.select();
            document.execCommand('copy');

            document.body.removeChild(textarea);
            this.showToast('Success','Link Copied','success');
        } catch (err) {
            console.error('Clipboard write failed:', err);
            this.showToast('Failure','Copy Failed','error');
        }
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title,
                message,
                variant
            })
        );
    }
    
}

// import { LightningElement, api } from 'lwc';
// import { ShowToastEvent } from 'lightningShowToastEvent';

// export default class RecordLinkCopier extends LightningElement {
//     @api recordId; // Captures the current record ID automatically

//     async handleCopyLink() {
//         if (!this.recordId) {
//             this.showToast('Error', 'Record ID not found.', 'error');
//             return;
//         }

//         // Generate the record URL
//         const baseUrl = window.location.origin;
//         const recordLink = `${baseUrl}/${this.recordId}`;

//         try {
//             // Write to clipboard
//             await navigator.clipboard.writeText(recordLink);
//             this.showToast('Success', 'Record link copied to clipboard!', 'success');
//         } catch (err) {
//             this.showToast('Error', 'Failed to copy the link. Please try again.', 'error');
//             console.error('Clipboard write failed:', err);
//         }
//     }

//     showToast(title, message, variant) {
//         this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
//     }
// }
