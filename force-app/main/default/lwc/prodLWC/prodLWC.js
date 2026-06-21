import { LightningElement , wire,track} from 'lwc';
import getData from "@salesforce/apex/prodClass.method1";
import getData1 from "@salesforce/apex/prodClass.method3";

export default class ProdLWC extends LightningElement {

  columns=[
    {label:'Name',fieldName : 'Name'}
  ]

  @track datas=[];
    @track datass=[];
    value = '';
    @track labelss=[];
    @track valuess=[];
    get picklistOptions() {
        if(this.datass){
         return this.datass.map((rec)=>{
            return { label: rec.Name, value: rec.Id };
        });
        }
        else {
            return [];
        }
    }


    @wire(getData) res({ data, error }) {
        if (data) {
          this.datass=data;
          console.log("data", JSON.parse(JSON.stringify(this.datass)));
        } else {
          console.log(error);
        }
      }
      @track arrayLabelId=[];

      handlePicklistChange(event) {
        this.value = event.detail.value;
        let selectedLabel = event.target.options.find(opt => opt.value === event.detail.value).label;
        if (this.valuess.includes(this.value)) {
            return;
        }
        this.valuess.push(this.value);
        this.labelss.push(selectedLabel);
        this.arrayLabelId=[...this.arrayLabelId,{label:selectedLabel,value:this.value}];
        this.mainMethod();
        console.log(JSON.parse(JSON.stringify(this.labelss)));
      }
      
      connectedCallback(){
        this.mainMethod();
      }

      mainMethod(){
        getData1({catList:this.valuess}).then((data)=>{
          this.datas=data;
          console.log(data);
        }).catch((error)=>{
          console.log(error);
        })
      }


      removeMethod(event){
        let lab=event.target.dataset.names;
        let val=event.target.dataset.id;
        this.valuess=this.valuess.filter(item=> item!==val);
        this.labelss=this.labelss.filter(item=>item !== lab);
        this.arrayLabelId=this.arrayLabelId.filter(item => item.value!==val);
        this.mainMethod();

      }

      
}























