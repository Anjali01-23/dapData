import { LightningElement, wire, track } from 'lwc';
import getIncome from '@salesforce/apex/transApex.method1';
import getName from '@salesforce/apex/transApex.method0';
import getExpense from '@salesforce/apex/transApex.method2';
import getData from '@salesforce/apex/transApex.method3';
import getDiff from '@salesforce/apex/transApex.method4';
import insertData from '@salesforce/apex/transApex.createTrans';
import { deleteRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

export default class TransLWC extends LightningElement {
    names = '';
    income = 0;
    expense = 0;
    amt = 0;
    datas = [];

    @track a1 = null;
    @track a2 = null;
    @track a3 = null;
    wholedata = null;
    diffData = null;

    naam = '';
    amounts = 0;
    typess = '';
    dates=undefined;
    allowDelete = false;

    today = new Date().toISOString().slice(0, 10);

    @wire(getName)
    wiredName(result) {
        this.a1 = result;
        if (result.data) {
            this.names = result.data;
        } else if (result.error) {
            console.error('Error loading name', result.error);
        }
    }

    @wire(getIncome)
    wiredIncome(result) {
        this.a2 = result;
        if (result.data !== undefined) {
            this.income = result.data || 0;
            console.log(this.income);
        } else if (result.error) {
            console.error('Error loading income', result.error);
        }
    }

    @wire(getExpense)
    wiredExpense(result) {
        this.a3 = result;
        if (result.data !== undefined) {
            this.expense = result.data || 0;
            console.log(this.expense);
        } else if (result.error) {
            console.error('Error loading expense', result.error);
        }
    }

    @wire(getDiff)
    wiredDiff(result) {
        this.diffData = result;
        if (result.data !== undefined) {
            this.amt = result.data || 0;
        } else if (result.error) {
            console.error('Error loading balance', result.error);
        }
    }

    @wire(getData)
    wiredData(result) {
        this.wholedata = result;
        if (result.data) {
            this.datas = result.data;
        } else if (result.error) {
            console.error('Error loading transactions', result.error);
        }
    }

    set(event) {
        this.typess = event.target.dataset.types;
    }

    handleName(event) {
        this.naam = event.detail.value;
    }

    handleAmt(event) {
       // const value = Number(event.detail.value);
      //  this.amounts = isNaN(value) ? 0 : value;
      this.amounts=event.detail.value;
    }

    handleDate(event) {
        this.dates = event.detail.value;
    }

    handleValidation() {
        const amtCmp = this.template.querySelector('.amtCmp');
        const dateCmp = this.template.querySelector('.dateCmp');

        if (!amtCmp || !dateCmp) {
            console.error('Validation inputs not found');
            return;
        }

        let isValid = true;
        amtCmp.setCustomValidity('');
        dateCmp.setCustomValidity('');

        if (this.amounts < 0) {
            isValid = false;
            amtCmp.setCustomValidity('Expense cannot be negative');
        }

        if (this.dates && this.dates > this.today || (!this.dates)) {
            isValid = false;
            dateCmp.setCustomValidity('Future date is not allowed');
        }

        if (this.typess === 'Expense' && this.amounts > this.amt) {
            isValid = false;
            amtCmp.setCustomValidity('Expense is greater than income');
        }

        amtCmp.reportValidity();
        dateCmp.reportValidity();

        if (isValid) {
            this.insertDatas();
        }
    }

    insertDatas() {
        insertData({
            names: this.naam,
            amt: this.amounts,
            type: this.typess,
            datess: this.dates
        })
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Transaction added successfully',
                        variant: 'success'
                    })
                );
                this.clearForm();
                this.handleRefreshAll();
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: error.body?.message || error.message || 'Unable to add transaction',
                        variant: 'error'
                    })
                );
                console.error(error);
            });
    }

    async handleRefreshAll() {
        const refreshPromises = [];
        if (this.wholedata) {
            refreshPromises.push(refreshApex(this.wholedata));
        }
        if (this.a1) {
            refreshPromises.push(refreshApex(this.a1));
        }
        if (this.a2) {
            refreshPromises.push(refreshApex(this.a2));
        }
        if (this.a3) {
            refreshPromises.push(refreshApex(this.a3));
        }
        if (this.diffData) {
            refreshPromises.push(refreshApex(this.diffData));
        }

        try {
        await Promise.all(refreshPromises);
        console.log('Refresh complete');
      } catch (error) {
        console.error('Error refreshing data', error);
      }
    }

    del() {
        this.allowDelete = true;
    }

    notDel() {
        this.allowDelete = false;
    }

    deleteRec(event) {
        const recId = event.target.dataset.id;
        deleteRecord(recId)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Record deleted',
                        variant: 'success'
                    })
                );
                this.handleRefreshAll();
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: error.body?.message || error.message || 'Unable to delete record',
                        variant: 'error'
                    })
                );
                console.error(error);
            });
    }

    clearForm() {
        this.naam = '';
        this.amounts = 0;
        this.typess = '';
        this.dates = undefined;
    }
}
