import { LightningElement , api ,track} from 'lwc';
import { getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi'; //ye bhii
import APPOINTMENT_OBJECT from '@salesforce/schema/Appointment__c';//ye bhii

export default class PatientComponent extends LightningElement {
    
    @api picklistFieldApiName;
    @track tabValues = [];
    selectedTab;
}