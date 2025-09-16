import { api, LightningElement, track } from 'lwc';
import createSuggestedProperty from '@salesforce/apex/PropertyGraphicalViewController.createSuggestedProperty';
import { getRecordNotifyChange } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import refresh from '@salesforce/messageChannel/Refresh__c';
import { createMessageContext, publish } from 'lightning/messageService';
import { NavigationMixin } from 'lightning/navigation';

export default class PropertyInfo extends NavigationMixin(LightningElement) {

    @api property;
    @api oppId;
    @api showPropertyInfo;
    @api isTransfer;

    messageContext;

    constructor() {
        super();

        this.messageContext = createMessageContext();
    }

    get buttonName() {

        if (this.isTransfer === true) {
            return 'Transfer';
        }
        else {
            return 'Short List';
        }
    }

    get bookingUrl() {

        if (this.property.bookingId) {
            return '/' + this.property.bookingId;
        }
    }

    get isShortListDisabled() {
        if (!this.oppId && this.isTransfer === false) {
            return true;
        }
        else if (this.property && this.property.status == 'Available') {
            return false;
        }
        else {
            return true;
        }
    }

    handleClose() {
        this.dispatchEvent(new CustomEvent('closeinfo'));
    }

    get showPricingDetails() {
        return this.property.status === 'Available' || this.property.status === 'Reserved';
    }

    get showBookingUrl() {
        return this.property.status === 'Booked';
    }

    get showBookingDetails() {
        return this.property.status != 'Available';
    }

    openBooking() {

        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.property.bookingId,
                actionName: 'view',
            },
        });
    }
    

    handleShortList() {

        if (this.isTransfer === true) {

            this.dispatchEvent(new CustomEvent('transfer', {
                detail: {
                    propertyId: this.property.id
                }
            }));
        }
        else {
            //this.isShortListDisabled = true;
            createSuggestedProperty({ propertyId: this.property.id, oppId: this.oppId }).then(result => {
                console.log(result);
                if (result != 'Record Already Exists') {
                    getRecordNotifyChange([{ recordId: result }]);
                    publish(this.messageContext, refresh, {});
                }
                else {

                    const evt = new ShowToastEvent({
                        title: 'Error :',
                        message: 'Property is already suggested so please select another property',
                        variant: 'error',
                        mode: 'dismissable'
                    });
                    this.dispatchEvent(evt);
                }
            }).catch(error => {
                console.log('error-->' + JSON.stringify(error));
                this.error = error;
            });
        }
    }

    renderedCallback() {
        if (this.showPropertyInfo) {
            this.template.querySelector('div.slds-panel').classList.add('slds-is-open');
            this.template.querySelector('div.slds-panel').classList.add('flexi-box');
            this.template.querySelector('div.slds-panel').classList.remove('slds-hidden');
        }
        else {
            this.template.querySelector('div.slds-panel').classList.remove('slds-is-open');
            this.template.querySelector('div.slds-panel').classList.remove('flexi-box');
            this.template.querySelector('div.slds-panel').classList.add('slds-hidden');
        }
    }
}