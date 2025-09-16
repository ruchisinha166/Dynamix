import { api, LightningElement, track, wire } from 'lwc';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent } from 'lightning/flowSupport';

export default class addCoApplicant extends LightningElement {

    draggedElement;

    @track coApplicants = [];

    @api newApplicants = [];
    @api updateApplicants = [];
    @api delApplicants = [];

    @api bookingId;
    @api
    get applicants() {
        return this.coApplicants;
    }
    set applicants(value) {
        this.coApplicants = JSON.parse(JSON.stringify(value));
    }

    @api
    get planJSON() {
        return JSON.stringify(this.coApplicants);
    }
    set planJSON(value) {
        this.coApplicants = JSON.parse(value);
    }

    get disableNext() {
        if (this.coApplicants) {

            /*let total = this.coApplicants.reduce((total, currentValue) => {
                return total + Number(currentValue.Ownership__c);
            }, 0);*/

            /*if (total !== 100) {
                return true;
            }
            else {*/
            let isValid = this.coApplicants.reduce((validSoFar, applicant) => {

                let isAccountfilled = this.checkValue(applicant.Account__c);

                return validSoFar && isAccountfilled;
            }, true);

            return !isValid;
            //}
        }

        return false;
    }

    checkValue(value) {
        return typeof value !== 'undefined' && value !== null && value !== '';
    }

    handleAddRow() {
        this.coApplicants.push({
            Role__c: 'Co-Applicant', Booking__c: this.bookingId
        });
    }

    handleChange(event) {
        this.coApplicants[event.detail.index] = event.detail.coApplicant;
    }

    setPrimary(event) {
        console.log(event.detail.index);
        this.coApplicants.forEach((coApplicant, index) => {
            if (event.detail.index === index) {
                this.coApplicants[index].Role__c = 'Primary';
            }
            else {
                this.coApplicants[index].Role__c = 'Co-Applicant';
            }
        });

        this.template.querySelectorAll('c-add-co-applicant-row').forEach((element, index) => {
            if (index === event.detail.index) {
                element.setAsPrimaryApplicant();
            }
            else {
                element.setAsCoApplicant();
            }
        });

        this.coApplicants = [...this.coApplicants];
    }

    handleNext() {
        console.log('next' + this.bookingId);

        this.coApplicants.forEach(coApplicant => {
            if (coApplicant.Id != undefined) {
                this.updateApplicants.push(coApplicant);
            }
            else {
                this.newApplicants.push(coApplicant);
            }
        });

        const attributeChangeEvent = new FlowAttributeChangeEvent('applicants', this.coApplicants);
        this.dispatchEvent(attributeChangeEvent);

        if (this.newApplicants.length > 0) {
            const attributeChangeEvent = new FlowAttributeChangeEvent('newApplicants', this.newApplicants);
            this.dispatchEvent(attributeChangeEvent);
        }
        else {
            this.newApplicants = undefined;
            const attributeChangeEvent = new FlowAttributeChangeEvent('newApplicants', this.newApplicants);
            this.dispatchEvent(attributeChangeEvent);
        }

        if (this.delApplicants.length > 0) {
            const attributeChangeEventDel = new FlowAttributeChangeEvent('delApplicants', this.delApplicants);
            this.dispatchEvent(attributeChangeEventDel);
        }
        else {
            this.delApplicants = undefined;
            const attributeChangeEventDel = new FlowAttributeChangeEvent('delApplicants', this.delApplicants);
            this.dispatchEvent(attributeChangeEventDel);
        }

        if (this.updateApplicants.length > 0) {
            const attributeChangeEventUpdate = new FlowAttributeChangeEvent('updateApplicants', this.updateApplicants);
            this.dispatchEvent(attributeChangeEventUpdate);
        }
        else {
            this.updateApplicants = undefined;
            const attributeChangeEventUpdate = new FlowAttributeChangeEvent('updateApplicants', this.updateApplicants);
            this.dispatchEvent(attributeChangeEventUpdate);
        }

        const navigateNextEvent = new FlowNavigationNextEvent();
        this.dispatchEvent(navigateNextEvent);
    }

    deleteRow(event) {
        var key = event.target.dataset.index;

        if (this.coApplicants[key].Id != undefined) {
            this.delApplicants.push(this.coApplicants[key]);
        }

        this.coApplicants.splice(key, 1);
    }

    renderedCallback() {
        if (this.disableNext === true) {
            this.template.querySelector('div.slds-notify').classList.remove('slds-hide');
        }
        else {
            this.template.querySelector('div.slds-notify').classList.add('slds-hide');
        }
    }
}