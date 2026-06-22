import { LightningElement, track } from 'lwc';

export default class sortData extends LightningElement {

    @track data = [
        {
            Id: '1',
            Name: 'Anjali',
            Email: 'anjali@gmail.com',
            Age: 22
        },
        {
            Id: '2',
            Name: 'Rahul',
            Email: 'rahul@gmail.com',
            Age: 25
        },
        {
            Id: '3',
            Name: 'Priya',
            Email: 'priya@gmail.com',
            Age: 20
        }
    ];

    columns = [
        {
            label: 'Name',
            fieldName: 'Name',
            type: 'text',
            sortable: true
        },
        {
            label: 'Email',
            fieldName: 'Email',
            type: 'email',
            sortable: true
        },
        {
            label: 'Age',
            fieldName: 'Age',
            type: 'number',
            sortable: true
        }
    ];

    sortedBy;
    sortDirection = 'asc';

    handleSort(event) {
        const { fieldName: sortedBy, sortDirection } = event.detail;

        this.sortedBy = sortedBy;
        this.sortDirection = sortDirection;

        this.sortData(sortedBy, sortDirection);
    }

    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.data));

        let keyValue = (a) => {
            return a[fieldname];
        };

        let isReverse = direction === 'asc' ? 1 : -1;

        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : '';
            y = keyValue(y) ? keyValue(y) : '';

            return isReverse * ((x > y) - (y > x));
        });

        this.data = parseData;
    }
}