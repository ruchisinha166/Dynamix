import { LightningElement, api, track, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import updateFile from '@salesforce/apex/FileOrganiserHandler.updateFile';
import { createMessageContext, publish } from 'lightning/messageService';
import refresh from '@salesforce/messageChannel/Refresh__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class UploadFile extends LightningElement {

messageContext;
subscription;

@api recordId;
@track disabled = true;
@track docTypeValue;
@track objType;
@track registrationStatus;

constructor() {
    super();

    this.messageContext = createMessageContext();
}
@wire(getRecord, { recordId: '$recordId', layoutTypes: 'Full' })
linkedObject({ error, data }) {
    if (data) {
        this.objType = data.apiName;
        
        if (data.apiName == 'Booking__c') {
            const registrationStatus = data.fields.Registration_Status__c.value;
            this.registrationStatus = registrationStatus;
        }
        
       
    }

}

handlePicklistValue(event) {
    console.log('OUTPUT : ',event.detail.value);
    this.docTypeValue = event.detail.value;

    if (this.docTypeValue == 'NOC' && this.registrationStatus != 'Completed') { 
        this.disabled = true;

        const toastEvent = new ShowToastEvent({
        title: 'Error',
        message: 'Cannot upload a document with NOC type when registration status is not Complete.',
        variant: 'error',
        });

        this.dispatchEvent(toastEvent);
        //this.disabled = true;
    } 
    console.log('docTypeValue:', this.docTypeValue);
    console.log('registrationStatus:', this.registrationStatus);
    console.log('Object type:', this.objType);

    if (this.docTypeValue && this.docTypeValue == 'NOC' && this.registrationStatus != 'Completed') {
        this.disabled = true;
    }else{
        this.disabled = false;
    }
}

handleUploadFinished(event) {
    let uploadedFiles = event.detail.files;

    updateFile({
        Temp: this.recordId,
        recordId: uploadedFiles[0].documentId,
        objType: this.objType,
        documentType: this.docTypeValue
        }).then(() => {
        this.docTypeValue = '';
        this.disabled = false;
        publish(this.messageContext, refresh, {});
    });
}
}