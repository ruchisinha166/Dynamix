import { api, LightningElement, track, wire } from 'lwc';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent } from 'lightning/flowSupport';

export default class CustomPaymentPlan extends LightningElement {

draggedElement;

@track paymentMilestones = [];
@track totalPercentage = 0;


@api planId;
@api
get planJSON() {
return JSON.stringify(this.paymentMilestones);
}
set planJSON(value) {
this.paymentMilestones = JSON.parse(value);
}

get disableNext() {
if (this.paymentMilestones) {

let total = this.paymentMilestones.reduce((total, currentValue) => {
        return total + Number(currentValue.Milestone_age__c);
}, 0);


if (parseFloat((total).toFixed(2)) !== 100) {
    console.log('Total=>'+total);
    console.log('Total Fixed =>'+parseFloat((total).toFixed(2)));
    return true;
}
            
else {
    let isValid = this.paymentMilestones.reduce((validSoFar, milestone) => {

        let isProjectProgress = this.checkValue(milestone.Project_Progress__c);
        let daysAfterBooking = this.checkValue(milestone.Days_after_Booking__c);
        let milestoneType = this.checkValue(milestone.Milestone_Activation__c);
        let milestoneName = this.checkValue(milestone.Name);
                            
        let len =0;
                            if(milestoneName!=''){
                                len = milestone.Name.length;
                            }
                            console.log('len ' + len);
                            
                            if(len > 80)
                            {
                                    console.log('in if--');
                                    return false;
                            }

        return validSoFar && (isProjectProgress || daysAfterBooking) && milestoneType && milestoneName;
    }, true);

    return !isValid;
}
}

return false;
}

checkValue(value) {
return typeof value !== 'undefined' && value !== null && value !== '';
}

handleAddRow() {
this.paymentMilestones.push({
Sequence_No__c: this.paymentMilestones.length + 1
});
}

handleChange(event) {
this.paymentMilestones[event.detail.index] = event.detail.paymentMilestone;
}

handleNext() {
console.log('next');
const attributeChangeEvent = new FlowAttributeChangeEvent('planJSON', JSON.stringify(this.paymentMilestones));
this.dispatchEvent(attributeChangeEvent);
console.log('final : ',JSON.stringify(this.paymentMilestones));
const navigateNextEvent = new FlowNavigationNextEvent();
this.dispatchEvent(navigateNextEvent);
}

allowDrop(event) {
event.preventDefault();
}

drop(event) {

let draggedMilestone = this.paymentMilestones[this.draggedElement];
this.paymentMilestones.splice(this.draggedElement, 1);
this.paymentMilestones.splice(event.target.dataset.index, 0, draggedMilestone);

this.paymentMilestones.forEach((paymentMilestone, index) => {
paymentMilestone.Sequence_No__c = index + 1;
});
}

deleteRow(event) {

var key = event.target.dataset.index;
if (this.paymentMilestones.length > 1) {
this.paymentMilestones.splice(key, 1);
this.index = 0;
this.paymentMilestones.forEach((paymentMilestone, index) => {
    paymentMilestone.Sequence_No__c = index + 1;
});
}
else if (this.paymentMilestones.length == 1) {
this.paymentMilestones = [];
this.index = 0;
this.paymentMilestones.forEach((paymentMilestone, index) => {
    paymentMilestone.Sequence_No__c = index + 1;
});
}
}

drag(event) {
this.draggedElement = event.target.dataset.index;
}

renderedCallback() {
console.log('renderedCallback');
if (this.disableNext === true) {
console.log('renderedCallback If');
this.totalPercentage = this.paymentMilestones.reduce((total, currentValue) => {
    if(currentValue.Milestone_age__c == null)
    {
        var amt=parseFloat((total + 0).toFixed(2));
        console.log('amt=>'+amt);
        return amt;
    }
    else{
        var amt2=parseFloat((total + Number(currentValue.Milestone_age__c)).toFixed(2));
        console.log('amt2=>'+amt2);
        return amt2;
    }
}, 0);

this.template.querySelector('div.slds-notify').classList.remove('slds-hide');
}
else {
console.log('renderedCallback Else');
this.template.querySelector('div.slds-notify').classList.add('slds-hide');
}
}
}