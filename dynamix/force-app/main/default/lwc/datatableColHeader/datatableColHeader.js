import { LightningElement, api, track } from 'lwc';
import { createMessageContext, subscribe, publish } from 'lightning/messageService';
import sorted from '@salesforce/messageChannel/sorted__c';

export default class DatatableColHeader extends LightningElement {

    @track sortDirection = 'asc';
    @track isSorted = false;

    @api col;
    @api isFirst;

    get isSortable() {
        return this.isFirst ? '' : 'slds-is-sortable';
    }

    constructor() {
        super();

        this.messageContext = createMessageContext();
        this.subscribeMC();
    }

    subscribeMC() {
        if (this.subscription) {
            return;
        }

        this.subscription = subscribe(
            this.messageContext,
            sorted, (message) => {
                this.removeSort(message);
            });
    }

    removeSort(message) {
        if (message.sortedBy !== this.col) {
            this.isSorted = false;
            this.sortArrowDisplay();
        }
    }

    sort() {

        this.sortDirection = this.sortDirection === 'asc' ? 'desc' : 'asc';
        this.isSorted = true;

        this.dispatchEvent(new CustomEvent('sort', {
            detail: {
                sortedBy: this.col,
                sortDirection: this.sortDirection
            }
        }));

        const message = {
            sortedBy: this.col,
        };
        publish(this.messageContext, sorted, message);

        this.sortArrowDisplay();
    }

    sortArrowDisplay() {
        if (this.isSorted && this.sortDirection === 'asc') {
            this.template.querySelector('div').classList.add('slds-is-sorted');
            this.template.querySelector('div').classList.add('slds-is-sorted_asc');
            this.template.querySelector('div').classList.remove('slds-is-sorted_desc');
        }
        else if (this.isSorted && this.sortDirection === 'desc') {
            this.template.querySelector('div').classList.add('slds-is-sorted');
            this.template.querySelector('div').classList.add('slds-is-sorted_desc');
            this.template.querySelector('div').classList.remove('slds-is-sorted_asc');
        }
        else if (!this.isFirst) {
            this.template.querySelector('div').classList.add('slds-is-sortable');
            this.template.querySelector('div').classList.remove('slds-is-sorted');
            this.template.querySelector('div').classList.remove('slds-is-sorted_desc');
            this.template.querySelector('div').classList.remove('slds-is-sorted_asc');
        }
    }
}