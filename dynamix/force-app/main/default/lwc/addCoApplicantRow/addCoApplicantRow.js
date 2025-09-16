import { api, LightningElement, track } from 'lwc';


export default class addCoApplicantRow extends LightningElement {

    entityConfig = {
        'objName': 'Account',
        'iconName': 'standard:account',
        'label': 'Account',
        'displayFields': 'Name,RecordTypeId',
        'displayFormat': 'Name',
        'pluralLabel': 'Accounts',
        'createRecord': false
    };

    @track coApplicant;

    @api index;

    @api
    get coApplicantsOfBooking() {
        return this.coApplicant;
    }
    set coApplicantsOfBooking(value) {
        this.coApplicant = JSON.parse(JSON.stringify(value));
    }

    @api
    setAsCoApplicant() {
        this.coApplicant.Role__c = 'Co-Applicant';
    }

    @api
    setAsPrimaryApplicant() {
        this.coApplicant.Role__c = 'Primary';
    }

    get isPrimary() {
        return this.coApplicant.Role__c === 'Primary';
    }

    handlePicklistValue(event) {
        this.coApplicant.Role__c = event.detail.value;
        this.dispatchUpdate();
    }

    handleInput(event) {

        this.coApplicant[event.target.dataset.element] = event.detail.value;
        this.dispatchUpdate();
    }

    handleChange(event) {
        this.coApplicant.Account__c = event.detail.recordId;
        console.log('handleChange3'+ JSON.stringify(this.coApplicant) );
        console.log('handleChange4'+ JSON.stringify(this.coApplicant.Account__c) );
        console.log('handleChange5'+ JSON.stringify(event.detail) );
        this.dispatchUpdate();
    }

    handleClick(event) {
        this.dispatchEvent(new CustomEvent('setprimary', {
            detail: {
                index: this.index,
                coApplicant: this.coApplicant
            }
        }));
    }

    removeRow(event) {
        this.dispatchEvent(new CustomEvent('delete', {
            detail: {
                index: this.index,
                coApplicant: this.coApplicant
            }
        }));
    }

    dispatchUpdate() {
        this.dispatchEvent(new CustomEvent('applicantchange', {
            detail: {
                index: this.index,
                coApplicant: this.coApplicant
            }
        }));
    }
}