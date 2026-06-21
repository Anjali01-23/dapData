import { LightningElement, api } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';

import CHART_JS
from '@salesforce/resourceUrl/ChartJS';

export default class GaugeChart extends LightningElement {

    @api completed;
@api delayed;
@api going;
@api percentage;

    chart;
    loaded = false;

    renderedCallback(){

        if(this.loaded){
            return;
        }

        this.loaded = true;

        loadScript(this, CHART_JS)
        .then(()=>{

            window.ResizeObserver = class{
                observe(){}
                unobserve(){}
                disconnect(){}
            };

            this.createChart();
        });
    }

    createChart(){

        const ctx =
            this.refs.chartCanvas.getContext('2d');

        this.chart =
            new window.Chart(ctx,{

            type:'doughnut',

            data:{
                datasets:[{
                           data:[
            this.completed,
            this.delayed,
            this.going
        ],

                    backgroundColor:[
                        '#00C853',
                        '#FFAB00',
                        '#FF1744'
                    ],

                    borderWidth:0
                }]
            },

            options:{

                responsive:true,

                circumference:180,

                rotation:270,

                cutout:'80%',

                plugins:{
                    legend:{
                        display:false
                    },
                    tooltip:{
                        enabled:false
                    }
                }
            }
        });
    }
}