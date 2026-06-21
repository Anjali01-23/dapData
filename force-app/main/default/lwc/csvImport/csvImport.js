import { LightningElement , track} from 'lwc';
import getRecords from '@salesforce/apex/csvUploaderController.createRecordsFromCSV';
import updateData from '@salesforce/apex/csvUploaderController.updateData';
import { loadScript } from 'lightning/platformResourceLoader';
import CHARTJS from '@salesforce/resourceUrl/ChartJS';

export default class CsvToDatatable extends LightningElement {
   @track data=[];
   @track columns = [
   { label: "Employee Performance Name", fieldName: "Employee_Performance_Name__c" },
   { label: "Productivity", fieldName: "Productivity__c" },
   { label: "Attendance", fieldName: "Attendance__c" },
   { label: "Problem Solving Skills", fieldName: "Problem_Solving_Skills__c" },
   { label: "Pressure Management", fieldName: "Pressure_Management__c" },        
 ]; 

 @track Newdata=[];
   @track columns1 = [
   { label: "Employee Performance Name", fieldName: "Employee_Performance_Name__c" },
   { label: "Overall Performance", fieldName: "Overall_Performance__c" },        
 ]; 

  handleFileUpload(event) {
    const files = event.detail.files;

    if (files.length > 0) {
      const file = files[0];
      
      // start reading the uploaded csv file
      this.read(file);
    }
  }
  
  async read(file) {
    try {
      const result = await this.load(file);
      
      // execute the logic for parsing the uploaded csv file
      this.parse(result);
    } catch (e) {
      this.error = e;
    }
  }

  async load(file) {
    return new Promise((resolve, reject) => {
      const reader = new FileReader();

      reader.onload = () => {
        resolve(reader.result);
      };
      reader.onerror = () => {
        reject(reader.error);
      };
      reader.readAsText(file);
    });
  }
datanew=false;
  parse(csv) {
  // parse the csv file and treat each line as one item of an array
  const lines = csv.split(/\r\n|\n/);
  
  // parse the first line containing the csv column headers
  const headers = lines[0].split(',');
  
  // iterate through csv headers and transform them to column format supported by the datatable
  this.columns = headers.map((header) => {
    return { label: header, fieldName: header };
  });

  const data = [];
  
  
  // iterate through csv file rows and transform them to format supported by the datatable
  lines.forEach((line, i) => {
    if (i === 0 || !line.trim()) return; //CSV m last row empty aa ri thi to use skip krne k liye ye kiya line.trim()  empty line ko empty ("") hi return krta h kyuki usme trim krne ko kuch h hi ni to uempty means false hota h and false ka utla true to ye return ho jayega.

    const obj = {};
    const currentline = line.split(',');

    for (let j = 0; j < headers.length; j++) {
      obj[headers[j]] = currentline[j];
    }

    data.push(obj);
  });
  
  // assign the converted csv data for the lightning datatable
  this.data = data;
  console.log(JSON.parse(JSON.stringify(this.data)));
  this.datanew=true;
  this.handleData(this.data);
  
}

 handleData(datass) {

        getRecords({ dataList: datass })

        .then(result => {

            console.log('Result', result);

            if(result.length > 0) {

                alert(result.join('\n'));
            }
            else {

                alert('Records inserted successfully');
            }
        })

        .catch(error => {

            console.log('Error', error);
        });
    }

    newTable=false;

     chart;
  chartInitialized = false;

    handleClick(){
      console.log(JSON.parse(JSON.stringify(this.data)));
      updateData({dataList:this.data}).then(result=>{
      this.newTable=true;
      this.Newdata=result;
      console.log('Result is this ',result);
       if (this.chartInitialized) {
            return;
        }
        this.chartInitialized = true;

        loadScript(this, CHARTJS)
            .then(() => {
              window.ResizeObserver = class {
                    observe() {}
                    unobserve() {}
                    disconnect() {}
                };
                this.loadChartData(this.Newdata);
            })
            .catch(error => {
                console.error('ChartJS load error', error);
            });
     }) .catch(error => {

            console.log('Error', error);
        });


       

    }



    loadChartData(dataNaya) {
        const dataa=dataNaya;
                let labels = [];
                let data = [];
                let mpp={
                  "Red for Rating b/w 1 and 3":'',
                  "Orange for Rating b/w 3 and 3.5":'',
                  "Green for Rating above 3.5":'',
                };

                dataa.forEach(row => {
                  if(row.Overall_Performance__c >=1 && row.Overall_Performance__c <=2){
                    mpp['Red for Rating b/w 1 and 3']=(mpp['Red for Rating b/w 1 and 3'] || 0) + 1;
                  }
                  else if(row.Overall_Performance__c >=3 && row.Overall_Performance__c <=3.5){
                    mpp['Orange for Rating b/w 3 and 3.5']=(mpp['Orange for Rating b/w 3 and 3.5'] || 0) + 1;
                  }
                  else{
                    mpp['Green for Rating above 3.5']=(mpp['Green for Rating above 3.5'] || 0) + 1;
                  }


                    
                    labels=Object.keys(mpp);
                    data=Object.values(mpp);

                    
                });

                this.renderChart(labels, data);
          
           
    }

    renderChart(labels, data, backgroundColors) {
        const ctx = this.template.querySelector('canvas').getContext('2d');

        if (this.chart) {
            this.chart.destroy();
        }

        this.chart = new Chart(ctx, {
            type: 'pie',
            data: {
                labels: labels,
                datasets: [{
                    data: data,
                    backgroundColor: [
                        'rgba(207, 8, 51, 0.5)',
                        'rgba(232, 74, 16, 0.5)',
                        'rgba(24, 171, 59, 0.5)'
                    ],
                    borderColor: '#ffffff',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                
            }
        });
    }








}

//First take the code from Apex Hours and then save the chart.min.js file and then add the code but things to keep in 
// mind that we need to add this -->   window.ResizeObserver = class {
                //     observe() {}
                //     unobserve() {}
                //     disconnect() {}
                // };