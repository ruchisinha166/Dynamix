import { api, LightningElement, track, wire } from 'lwc';
import { createMessageContext, subscribe } from 'lightning/messageService';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import getFiles from '@salesforce/apex/FileOrganiserHandler.getFiles';
import refresh from '@salesforce/messageChannel/Refresh__c';

export default class FileOrganiserLWC extends LightningElement {

    @api recordId;

    @track rows;
    @track columns;

    @track isLoaded = false;
    @track hasFiles;

    @track showGroup;
    @track groupByOptions;
    @track groupByValues = [];

    displayFields;
    data;
    messageContext;
    subscription;
    wireResponse;

    constructor() {
        super();

        this.messageContext = createMessageContext();
        this.subscribeMC();
    }

    subscribeMC() {
        if (this.subscription) {
            return;
        }

        this.subscription = subscribe(this.messageContext, refresh, () => {
            this.refreshFiles();
        });
    }

    @wire(getFiles, { recordId: '$recordId' })
    files(response) {

        this.wireResponse = response;

        if (response.data) {
            this.data = JSON.parse(JSON.stringify(response.data));

            if (this.data.length === 0) {
                this.hasFiles = false;
                this.isLoaded = true;
                return;
            }

            this.rows = [...this.data];

            this.displayFields = [];
            this.displayFields.push({ label: 'File Name', fieldName: 'title', type: 'text' });
            this.displayFields.push({ label: 'Document Type', fieldName: 'documentType', type: 'text' });
            this.displayFields.push({ label: 'Uploaded Date', fieldName: 'uploadedDate', type: 'date' });
            this.displayFields.push({ label: 'Uploaded By', fieldName: 'uploadedBy', type: 'text' });

            this.isLoaded = true;
            this.hasFiles = true;
            this.setColumns();
            this.setGroupByOptions();
        }
        else if (response.error) {
            const event = new ShowToastEvent({
                title: 'Error!!!',
                message: error.body.message,
                variant: 'error'
            });
            this.dispatchEvent(event);
            this.isLoaded = true;
        }
    }

    refreshFiles() {
        refreshApex(this.wireResponse);
    }

    search(event) {
        this.rows = [...this.data.filter(row => JSON.stringify(row).toLowerCase().includes(event.detail.searchText.toLowerCase()))];
    }

    displayGroupBy() {
        this.showGroup = true;
    }

    handleGrpByChange(event) {
        this.groupByValues = [...event.detail.value];
    }

    handleUpload() {
        this.dispatchEvent(new CustomEvent('upload', {}));
    }

    updateGroup() {
        this.setColumns();
        this.cancelGroup();
    }

    cancelGroup() {
        this.showGroup = false;
    }

    setColumns() {

        this.columns = [];

        this.columns.push({ label: '', fieldName: 'id', type: 'text' });
        let addedColumns = new Set();

        if (this.groupByValues != '' && this.groupByValues != undefined) {
            this.groupByValues.forEach((field) => {
                this.columns.push({ label: field, fieldName: field, type: 'text', grouped: true });
                addedColumns.add(field);
            });
        }

        this.displayFields.forEach((field) => {

            if (!addedColumns.has(field.fieldName)) {
                this.columns.push({ label: field.label, fieldName: field.fieldName, type: 'text' });
                addedColumns.add(field.fieldName);
            }
        });
    }

    setGroupByOptions() {

        this.groupByOptions = [];

        this.displayFields.forEach((field) => {

            this.groupByOptions.push({ label: field.label, value: field.fieldName });
        });
    }
}