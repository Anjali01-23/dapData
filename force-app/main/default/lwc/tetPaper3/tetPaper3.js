import { LightningElement , track ,api,wire} from 'lwc';
import demo from 'c/newDemoModal';
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class TetPaper3 extends LightningElement {

   @track imageUrl;

   handleFile(event){

    const file = event.target.files[0];

    if(file){

        const reader = new FileReader(); //JS object used to read the files.

        reader.onload = () => {

            this.imageUrl = reader.result;   //Here we store the url result in 'imageUrl'
            const event = new ShowToastEvent({
                      title: "Success",
                      message: "File Uploaded",
                      variant: "success"
                    });
            this.dispatchEvent(event);

        };

        reader.readAsDataURL(file);  // Files are read here and converted into base64 URL.
    }
}

    @track currentStep='1';
   
    value='None';
    @track personalInfo={
        'FirstName':'',
        'LastName':'',
        'DOB':'',
        'Phone':'',
        'Address':'',
    }

    @track academics={
        'ten':'',
        'twelve':'',
        'College':'',
        'CGPA':'',
        'Technical':'',
    }

    @track extras={
        'soft':'',
        'awards':'',
        'hack':'',
        'intern':'',
        'hobbies':'',
    }

    //For Experience



    @track experData={
        'work':'',
        'certificate':'',
        'project':'',
        'skill':'',
    }

    @track extrass1={
        'soft':'',
        'awards':'',
        'seminars':'',
        'hobbies':'',
    }


    @track extra1={};
    @track extra2={};
    @track extra3={};


    empty=' ';
    handleChange1(event){
        let datas = event.target.dataset.field;
        this.personalInfo[datas]=event.target.value;
    }

    handleChange2(event){
        let datas = event.target.dataset.field;
        this.academics[datas]=event.target.value;
    }

    handleChange3(event){
        let datas = event.target.dataset.field;
        this.extras[datas]=event.target.value;
    }

    handleChange4(event){
        let datas = event.target.dataset.field;
        this.extra1[datas]=event.target.value;
    }
    handleChange5(event){
        let datas = event.target.dataset.field;
        this.extra2[datas]=event.target.value;
    }
    handleChange6(event){
        let datas = event.target.dataset.field;
        this.extra3[datas]=event.target.value;
    }


    handleChangeExp1(event){
        let datas = event.target.dataset.field;
        this.personalInfo[datas]=event.target.value;
    }

    handleChangeExp2(event){
        let datas = event.target.dataset.field;
        this.experData[datas]=event.target.value;
    }

    handleChangeExp3(event){
        let datas = event.target.dataset.field;
        this.extrass1[datas]=event.target.value;
    }

    // handleChange4(event){
    //     let datas = event.target.dataset.field;
    //     this.extra1[datas]=event.target.value;
    // }
    // handleChange5(event){
    //     let datas = event.target.dataset.field;
    //     this.extra2[datas]=event.target.value;
    // }
    // handleChange6(event){
    //     let datas = event.target.dataset.field;
    //     this.extra3[datas]=event.target.value;
    // }

    get extraFields1(){
        return Object.keys(this.extra1).map(key=>{
            return {
                'label':key,
                'value':this.extra1[key]
            }
        })
    }

    get extraFields2(){
        return Object.keys(this.extra2).map(key=>{
            return {
                'label':key,
                'value':this.extra2[key]
            }
        })
    }

    get extraFields3(){
        return Object.keys(this.extra3).map(key=>{
            return {
                'label':key,
                'value':this.extra3[key]
            }
        })
    }

    addField(labelName){
        if(this.isStep1==true){
         this.extra1={...this.extra1,[labelName]:''};
         console.log('Extra1',JSON.parse(JSON.stringify(this.extra1)));
        }
        else if(this.isStep2==true){
         this.extra2 = {...this.extra2,[labelName]:''};
        }
        else {
         this.extra3 = {...this.extra3,[labelName]:''};     
        }
        
    }
    async handleModal(event) {
    
            const result = await demo.open({
                size: 'small',
            });
            if(result!=null){
               this.addField(result);
            }
        }

    

     get options() {
        return [
            { label: 'None', value: 'None' },
            { label: 'Mr.', value: 'Mr.' },
            { label: 'Mrs.', value: 'Mrs.' },
            { label: 'Miss', value: 'Miss' },
        ];
    }

    handleChange(event) {
        this.value = event.detail.value;
    }

    isStep1=true;
    isStep2=false;
    isStep3=false;
    
    isFresher=false;
    isExper=false;

    onOne(){
      this.isStep1=true;
      this.isStep2=false;
      this.isStep3=false;
      this.currentStep='1';
    }

    onSecond(){
      this.isStep2=true;
      this.isStep1=false;
      this.isStep3=false;
      this.currentStep='2';
    }

    onThird(){
     this.isStep3=true;
     this.isStep2=false;
     this.isStep1=false;
     this.currentStep='3';
    }

    Fresh(){
        this.isFresher=true;
        this.isExper=false;
        this.onOne();
    }

    Exper(){
        this.isExper=true;
        this.isFresher=false;
        this.onOne();
        this.showResume=false;
        this.value='None';
        this.personalInfo={
        'FirstName':'',
        'LastName':'',
        'DOB':'',
        'Phone':'',
        'Address':'',
    }

    this.academics={
        'ten':'',
        'twelve':'',
        'College':'',
        'CGPA':'',
        'Technical':'',
    }

    this.extras={
        'soft':'',
        'awards':'',
        'hack':'',
        'intern':'',
        'hobbies':'',
    }
        this.extra1={};
        this.extra2={};
        this.extra3={};
    }

    showResume=false;
    showResume1=false;

    submitButton(){
        const allValid = [
        ...this.template.querySelectorAll('lightning-input')
    ].reduce((validSoFar, inputCmp) => {

        inputCmp.reportValidity();

        return validSoFar && inputCmp.checkValidity();

    }, true);

    if(allValid){

        this.showResume=true;

    }
        
    }

    submitButton1(){
        this.showResume1=true;
    }

    handleNext1() {

    const allValid = [
        ...this.template.querySelectorAll('lightning-input')
    ].reduce((validSoFar, inputCmp) => {

        inputCmp.reportValidity();

        return validSoFar && inputCmp.checkValidity();

    }, true);

    if(allValid){

        this.onSecond();

    }
}

handleNext2() {

    const allValid = [
        ...this.template.querySelectorAll('lightning-input')
    ].reduce((validSoFar, inputCmp) => {

        inputCmp.reportValidity();

        return validSoFar && inputCmp.checkValidity();

    }, true);

    if(allValid){

        this.onThird();

    }
}
}
