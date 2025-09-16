import { api, LightningElement, track } from 'lwc';
export default class CustomPaymentPlanRow extends LightningElement {

entityConfig = {
    'objName': 'Project_Progress__c',
    'iconName': 'custom:custom25',
    'label': 'Project Progress',
    'displayFields': 'Name, Tower__r.Name, Floor__c,Project__r.Name',
    'displayFormat': 'Name - Tower__r.Name - Project__r.Name',
    'pluralLabel': 'Project Progress',
    'createRecord': false
};

milestoneEntityConfig = {
    "objName": "Milestone_Master__c",
    "iconName": "custom:custom25",
    "label": "Payment Milestones ",
    "displayFields": "Name",
    "displayFormat": "Name",
    "pluralLabel": "Milestones Masters",
    "createRecord": false
};

handleMilestoneChange(event) {
   console.log('event : ',JSON.stringify(event.detail));
    this.paymentMilestone.Milestone_Master__c = event.detail.recordId;
    this.paymentMilestone.Name = event.detail.recordName;
    this.dispatchUpdate();
    
}


@track paymentMilestone;

@api index;
// @api paymentMilestones;
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

handlePicklistValue(event) {

    this.paymentMilestone.Milestone_Activation__c = event.detail.value;
    this.dispatchUpdate();
}

handleInput(event) {

    /*let firstName = this.template.querySelector(".inputLastName");
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
            else{
                    console.log('in else');
                    firstName.setCustomValidity('');
                    firstName.reportValidity();
                    this.paymentMilestone[event.target.dataset.element] = event.detail.value;
            this.dispatchUpdate();
            }	*/

            this.paymentMilestone[event.target.dataset.element] = event.detail.value;
            this.dispatchUpdate();	
    }
    
handleChange(event) {
    this.paymentMilestone.Project_Progress__c = event.detail.recordId;
    this.dispatchUpdate();
}

removeRow(event)
{
    this.dispatchEvent(new CustomEvent('delete', {
        detail: {
            index: this.index,
            paymentMilestone: this.paymentMilestone
        }
    }));
}



dispatchUpdate() {
    console.log('Inside dispatchUpdate');
    this.dispatchEvent(new CustomEvent('milestonechange', {  
        detail: {
            index: this.index,
            paymentMilestone: this.paymentMilestone
        }
       
    }));
    console.log('paymentMilestone:'+this.paymentMilestone);
    console.log('paymentMilestone Json:'+JSON.stringify(this.paymentMilestone));
}
}