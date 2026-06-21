import { LightningElement, wire, track } from 'lwc';
import getData from '@salesforce/apex/apexClassNew.apexClassNew';

export default class NewsLWC extends LightningElement {



    @track datas={};
    @wire(getData)response({data, error}){
        if(data){
            this.datas=data;
            console.log(this.datas);
        }
        else{
            console.log(error);
        }
    }
    
}