import { LightningElement ,track , wire} from 'lwc';
import getShow from '@salesforce/apex/movieClass.getShows';
import getShow1 from '@salesforce/apex/movieClass.accGenre';
import getShow2 from '@salesforce/apex/movieClass.getShow';

import demo from 'c/newOneDemo'
export default class MovieLWC extends LightningElement {

   @track currentStep='1';
   empty=' ';
    isStep1=true;
    isStep2=false;
    isStep3=false;
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


    @track datas=[];
    @wire(getShow)dataShow({data,error}){
        if(data){
            this.datas=data;
            console.log(this.datas);
        }
        else{
            console.log(error);
        }
    }

    continues=false;

    showNaam;
    seatType;

    silver=false;
    gold=false;
    platinum=false;

    m1(event){
        this.continues=true;
        this.showNaam=event.target.dataset.showname;
        this.seatType=event.target.label;
         console.log('Showww',this.showNaam);
         console.log('Showww',this.seatType);
        if(this.seatType=='Silver'){
            this.silver=true;
            this.gold=false;
            this.platinum=false;
        }
        else if(this.seatType=='Gold'){
            this.silver=false;
            this.gold=true;
            this.platinum=false;
        }
        else{
            this.silver=false;
            this.gold=false;
            this.platinum=true;
        }
    }

    m2(){
        this.continues=false;
    }

     async handleModal(event) {
        
                const result = await demo.open({
                    size: 'small',
                    details: event.target.dataset.detail
                });
                
            }



            value='All';
            dates=null;
            get options(){
                return [
            { label: 'All Genres', value: 'All' },
            { label: 'Humour', value: 'Humour' },
            { label: 'Horror', value: 'Horror' },
            { label: 'Action', value: 'Action' },
            { label: 'Romance', value: 'Romance' },
        ];
            }

            handleChange(event){
                this.value= event.detail.value;
                getShow1({gen:this.value,datess:this.dates}).then(result=>{
                    this.datas=result;
                    console.log(this.datas);
                }).catch(error=>{
                    console.log(error);
                })
            }

          

            handleChange1(event){
                this.dates= event.detail.value;
                getShow1({gen:this.value,datess:this.dates}).then(result=>{
                    this.datas=result;
                    console.log(this.datas);
                }).catch(error=>{
                    console.log(error);
                })
            }

            timerId;

            startTimer() {
            this.timerId = setTimeout(() => {
            this.handleReset();
         }, 4*1000); 
   }

           handleReset(){
            this.onOne();
           }

           @track newData=[];
            handleNext2(){
                this.onSecond();

                console.log('Showww',this.showNaam);
                getShow2({naam:this.showNaam}).then(result=>{
                    this.newData=result;
                    this.startTimer();
                    console.log(JSON.parse(JSON.stringify(this.newData)));
                }).catch(error=>{
                    console.log(error);
                })
            }

            
            emptyy='               ';

            seats=0;
            handleMinus(){
              if(this.seats>0){
                this.seats--;
              }
            }

            handlePlus(){
              if(this.seats<10){
                this.seats++;
              }
            }
}