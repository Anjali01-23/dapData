import { LightningElement } from 'lwc';

export default class ColorDatatable extends LightningElement {}


// import LightningDatatable from 'lightning/datatable';
// import amountTemplate from './amountTemplate.html';

// export default class CustomDatatable extends LightningDatatable {

//     static customTypes = {
//         coloredAmount: {
//             template: amountTemplate,
//             standardCellLayout: true,
//             typeAttributes: [
//                 'value',
//                 'cellClass'
//             ]
//         }
//     };
// }


{/* <template>
    <span class={typeAttributes.cellClass}>
        {typeAttributes.value}
    </span>
</template> */}



// this.data = result.map(row => {

//     return {

//         ...row,

//         amountClass:
//             row.Amount > 10000
//             ? 'slds-text-color_success'
//             : 'slds-text-color_error'
//     };
// });


// columns = [

// {
//     label: 'Name',
//     fieldName: 'Name'
// },

// {
//     label: 'Amount',
//     type: 'coloredAmount',

//     typeAttributes: {

//         value: {
//             fieldName: 'Amount'
//         },

//         cellClass: {
//             fieldName: 'amountClass'
//         }
//     }
// }

// ];




//Dynamic query
// @AuraEnabled
// public static List<Projectt__c> method4(
//     Integer limitSize,
//     Integer offset,
//     String managerId,
//     String status
// ){
//     String query =
//         'SELECT Id, Name, Project_Manager__c, Project_Manager__r.Name, Due_Date__c, Status__c ' +
//         'FROM Projectt__c ' +
//         'WHERE Due_Date__c = LAST_N_DAYS:30 ';

//     if(String.isNotBlank(managerId)){
//         query += ' AND Project_Manager__c = :managerId';
//     }

//     if(String.isNotBlank(status)){
//         query += ' AND Status__c = :status';
//     }

//     query += ' ORDER BY CreatedDate DESC LIMIT :limitSize OFFSET :offset';

//     return Database.query(query);
// }








// import { LightningElement } from 'lwc';

// export default class MyComponent extends LightningElement {
//     timerId;

//     connectedCallback() {
//         this.startTimer();
//     }

//     startTimer() {
//         this.timerId = setTimeout(() => {
//             this.handleReset();
//         }, 15 * 60 * 1000); // 15 min
//     }

//     handleNextButton() {
//         // User clicked button A

//         clearTimeout(this.timerId);

//         console.log('User clicked within 15 minutes');

//         // Your button A logic
//     }

//     handleReset() {
//         console.log('15 minutes completed');

//         // Button B logic
//         // Go to start state
//         this.currentStep = 1;
//     }

//     disconnectedCallback() {
//         clearTimeout(this.timerId);
//     }
// }








// import { LightningElement } from 'lwc';

// export default class IdleTimer extends LightningElement {
//     timerId;

//     connectedCallback() {
//         this.startIdleTimer();

//         window.addEventListener('click', this.resetTimer.bind(this));
//         window.addEventListener('mousemove', this.resetTimer.bind(this));
//         window.addEventListener('keypress', this.resetTimer.bind(this));
//         window.addEventListener('scroll', this.resetTimer.bind(this));
//     }

//     startIdleTimer() {
//         this.timerId = setTimeout(() => {
//             this.performAction();
//         }, 15 * 60 * 1000); // 15 minutes
//     }

//     resetTimer() {
//         clearTimeout(this.timerId);
//         this.startIdleTimer();
//     }

//     performAction() {
//         console.log('User inactive for 15 minutes');

//         // Call your button logic here
//         this.handleButtonClick();
//     }

//     handleButtonClick() {
//         // Actual button logic
//         console.log('Button clicked automatically');
//     }

//     disconnectedCallback() {
//         clearTimeout(this.timerId);
//     }
// }