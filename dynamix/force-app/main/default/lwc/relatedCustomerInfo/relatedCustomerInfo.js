import { LightningElement, track, wire, api } from 'lwc';
import FORM_FACTOR from '@salesforce/client/formFactor';
import { getRecord } from 'lightning/uiRecordApi';

export default class RelatedCustomerInfo extends LightningElement {

    @api recordId;
    @api relatedObjectApiName;
    @api relatedObjectlabel;
    @api relatedFieldApiName;

    @track relatedRecordId;
    @track layoutType = 'Full';
    @track iconName;

    record;

    @wire(getRecord, { recordId: '$recordId', layoutTypes: '$layoutType' })
    wiredResult({ error, data }) {

        if (data) {

            //this.record = data;
            this.relatedRecordId = data.fields[this.relatedFieldApiName].value;

            if (this.relatedrelatedObjectApiName === 'Lead') {
                this.iconName = 'standard:lead';
            }
            else if (this.relatedObjectApiName === 'Contact') {
                this.iconName = 'standard:contact';
            }
            else if (this.relatedObjectApiName === 'Account') {
                this.iconName = 'standard:account';
            }
            else {
                this.iconName = 'standard:avatar';
            }
        }
        else {
            this.error = error;
        }
    }

    /*get Name() {

        let name = '';

        if (this.objectApiName === 'Lead' || this.objectApiName === 'Contact') {
            name = this.record.fields.Salutation.value === null ? '' : this.record.fields.Salutation.value + ' ';

            name += this.record.fields.FirstName.value === null ? '' : this.record.fields.FirstName.value + ' ';
            name += this.record.fields.LastName.value === null ? '' : this.record.fields.LastName.value;
        }
        else {
            name = this.record.fields.Name.value;
        }

        return name;
    }*/
}