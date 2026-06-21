import LightningDatatable from 'lightning/datatable';
import progressRing from './progressRing.html';
export default class customDatatableComp extends LightningDatatable {

    static customTypes = {
       rotation: {
           template: progressRing,
           standardCellLayout: true,
        typeAttributes: ['value']
       }
    }

}

