import { LightningElement, wire, track } from "lwc";
import getData from "@salesforce/apex/projectClass.method";
import getData1 from "@salesforce/apex/projectClass.method1";
import getData2 from "@salesforce/apex/projectClass.method2";
import getData3 from "@salesforce/apex/projectClass.method3";
import getData4 from "@salesforce/apex/projectClass.method4";
import getCounts from "@salesforce/apex/projectClass.getCount";
import getManagers from '@salesforce/apex/projectClass.getManagers';
import getOverallProgress from '@salesforce/apex/projectClass.getOverallProgress';
export default class ProjectData extends LightningElement {
  @track data0;
  @track data1;
  @track data2;
  @track data3;
  @track data4 = [];

  overallProgress = {
    completed:0,
    delayed:0,
    ongoing:0,
    total:0,
    percentage:0
};

@wire(getOverallProgress)
wiredProgress({data,error}){

    if(data){

        this.overallProgress = {

            completed:data.Completed,
            delayed:data.Delayed,
            ongoing:data.Ongoing,
            total:data.Total,

            percentage:
                data.Total > 0
                ? Math.round(
                    (data.Completed / data.Total)*100
                  )
                : 0
        };
    }

    if(error){
        console.log(error);
    }
}

  managerOptions = [{ label: "All", value: "" }];
  statusOptions = [
    { label: "All", value: "" },
    { label: "Active", value: "Active" },
    { label: "Completed", value: "Completed" },
    { label: "Delayed", value: "Delayed" },
    { label: "Ongoing", value: "Ongoing" }
  ];

  selectedManager = "";
  selectedStatus = "";

  columns = [
    { label: "Project Name", fieldName: "Name" },
    { label: "Project Manager", fieldName: "ManagerName" },
    { label: "Project Due Date", fieldName: "Due_Date__c" },
    { label: "Project Status", fieldName: "Status__c" },
    {
      
    label: 'Progress',
    type: 'rotation',
    typeAttributes: {
        value: { fieldName: 'ProgressValue' },
        variant: { fieldName: 'RingVariant' }
    }

    }
  ];


  @wire(getManagers)
wiredManagers({data,error}){

    if(data){

        this.managerOptions = [
            {label:'All', value:''},
            ...data.map(item => ({
                label:item.Name,
                value:item.Id
            }))
        ];
    }
}

  @wire(getData) res({ data, error }) {
    if (data) {
      this.data0 = data[0].expr0;
      console.log("data", this.data3);
      console.log("data", data);
    } else {
      console.log(error);
    }
  }

  @wire(getData1) res1({ data, error }) {
    if (data) {
      this.data1 = data;
      console.log("data", this.data1);
      console.log("data", data);
    } else {
      console.log(error);
    }
  }

  @wire(getData2) res2({ data, error }) {
    if (data) {
      this.data2 = data[0].expr0;
      console.log("dataSpentt", this.data2);
      console.log("data", data);
    } else {
      console.log(error);
    }
  }

  @wire(getData3) res3({ data, error }) {
    if (data) {
      this.data3 = data[0].expr0;
      console.log("dataAssigned", this.data3);
      console.log("data", data);
    } else {
      console.log(error);
    }
  }

  handleManagerChange(event) {
    this.selectedManager = event.detail.value;
    this.resetTable();
  }

  handleStatusChange(event) {
    this.selectedStatus = event.detail.value;
    this.resetTable();
  }

  resetTable() {

    this.data4 = [];
    this.rowOffSet = 0;
    this.countData();
    this.loadData();
    
}

  error;
  rowLimit = 5;
  rowOffSet = 0;
  totalRecord;
  connectedCallback() {
    this.loadData();
    this.countData();
  }

  countData(){
    getCounts({managerId:this.selectedManager,status:this.selectedStatus}).then((cnt)=>{
        this.totalRecord=cnt;
    })
  }
  loadData() {
    return getData4({
      limitSize: this.rowLimit,
      offset: this.rowOffSet,
      managerId: this.selectedManager,
      status: this.selectedStatus
    })
      .then((result) => {
        if(result){
            result = result.map(rec => {

    let progressValue = 0;
    let ringVariant = 'base-autocomplete';

    if(rec.Status__c === 'Active'){
        progressValue = 25;
        ringVariant = 'warning';
    }
    else if(rec.Status__c === 'Ongoing'){
        progressValue = 50;
        ringVariant = 'warning';
    }
    else if(rec.Status__c === 'Delayed'){
        progressValue = 75;
        ringVariant = 'expired';
    }
    else if(rec.Status__c === 'Completed'){
        progressValue = 100;
        ringVariant = 'base-autocomplete';
    }

    return {
        ...rec,
        ProgressValue: progressValue,
        RingVariant: ringVariant,
        ManagerName: rec.Project_Manager__c ? rec.Project_Manager__r.Name : ''
    };
});
        }
        let updatedRecords = [...this.data4, ...result];
        this.data4 = updatedRecords;
        this.error = undefined;
        console.log("Loaded records", this.data4.length);
      })
      .catch((error) => {
        this.error = error;
        this.accounts = undefined;
        console.log(error);
      });
  }

  loadMoreData(event) {
    console.log("LOADDD MOREEE");
    console.log("LOAD MORE");
    console.log("Current Records:", this.data4.length);
    console.log("Total Records:", this.totalRecord);
    const currentRecord = this.data4;
    const { target } = event;
    target.isLoading = true;
    if (this.data4.length >= this.totalRecord) {
      target.isLoading = false;
      return;
    }
    this.rowOffSet = this.rowOffSet + this.rowLimit;

    this.loadData().then(() => {
      target.isLoading = false;
    });
  }
}
