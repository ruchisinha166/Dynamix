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
      //  console.log("this.paymentMilestone.Booking__r.Registration_Status__c"+this.paymentMilestone.Booking__r.Registration_Status__c);
    if (this.paymentMilestone.Booking__r.Registration_Status__c != 'Completed') {
        return this.paymentMilestone.Milestone_Status__c === 'Active';
    }
    return true;   
    // return this.paymentMilestone.Milestone_Status__c === 'Active';
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
			
				 let firstName = this.template.querySelector(".inputLastName");
				console.log(firstName);
				console.log(firstName.value);
				var len = firstName.value.length;
				
				console.log(len);
				if(len > 80)
				{
						console.log('i if');
						firstName.setCustomValidity('Length must be below 80 characters');
						firstName.reportValidity();
						this.paymentMilestone[event.target.dataset.element] = event.detail.value;
        		this.dispatchUpdate();
				}
        this.paymentMilestone[event.target.dataset.element] = event.detail.value;
        this.dispatchUpdate();
    }

    handleChange(event) {
        this.paymentMilestone.Project_Progress__c = event.detail.recordId;
        this.dispatchUpdate();
    }

    removeRow(event) {
        this.dispatchEvent(new CustomEvent('delete', {
            detail: {
                index: this.index,
                paymentMilestone: this.paymentMilestone

            }
        }));

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