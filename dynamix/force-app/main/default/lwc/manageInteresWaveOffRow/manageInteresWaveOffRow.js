import { api, LightningElement, track } from 'lwc';

export default class BookingPaymentPlanRow extends LightningElement {
    entityConfig = {
        'objName': 'Project_Progress__c',
        'iconName': 'custom:custom25',
        'label': 'Project Progress',
        'displayFields': 'Name, Tower__r.Name, Floor__c',
        'displayFormat': 'Name - Tower__r.Name',
        'pluralLabel': 'Project Progress',
        'createRecord': false
    };

    @track paymentMilestone;

    @api index;

    @api
    get paymentPlanMilestone() {
        return this.paymentMilestone;
    }
    set paymentPlanMilestone(value) {
        this.paymentMilestone = JSON.parse(JSON.stringify(value));
    }

    get isProjectProgressBased() {
        return this.paymentMilestone.Milestone_Activation__c === 'Project Progress';
    }

    get isBookingBased() {
        return this.paymentMilestone.Milestone_Activation__c !== 'Project Progress';
    }

    get isReadOnly() {
        return this.paymentMilestone.Milestone_Status__c === 'Active';
    }

    handlePicklistValue(event) {

        this.paymentMilestone.Milestone_Activation__c = event.detail.value;
        if (this.paymentMilestone.Milestone_Activation__c == 'Project Progress') {
            this.paymentMilestone.Milestone_Activation_Date__c = null;
        }
        else {
            this.paymentMilestone.Project_Progress__c = null;
        }
        this.dispatchUpdate();
    }

    handleInput(event) {

        this.paymentMilestone[event.target.dataset.element] = event.detail.value;
        this.dispatchUpdate();
    }

    handleChange(event) {
        this.paymentMilestone.Project_Progress__c = event.detail.recordId;
        this.dispatchUpdate();
    }

    

    dispatchUpdate() {
        this.dispatchEvent(new CustomEvent('milestonechange', {
            detail: {
                index: this.index,
                paymentMilestone: this.paymentMilestone
            }
        }));
    }
}