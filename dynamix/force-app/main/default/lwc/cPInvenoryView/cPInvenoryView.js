import { LightningElement, wire, track, api } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

const FIELDS = [
    'Opportunity.Project__c'
];
const FIELDS_BOOK = [
    'Booking__c.Project_Name__c'
];

export default class cPInvenoryView extends LightningElement {

    @track projectId;
    @api recordId;
    
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    getFilters({ error, data }) {
        if (data) {
            this.projectId = data.fields.Project__c.value;
            console.log(this.projectId);
        }

        if (error) {
            console.error(error);
        }
    }
}