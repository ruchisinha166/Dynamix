import { api, LightningElement, track, wire } from 'lwc';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent } from 'lightning/flowSupport';
import { deleteRecord } from 'lightning/uiRecordApi';
export default class BookingPaymentPlan extends LightningElement {

    @track paymentMilestones = [];
    @track currentAgreementValue;
    @track currentGSTValue;
    @track updatedTotal = 0;
    @track updatedGSTTotal = 0;

    @api bookId;
    @api newAgreementValue = 0;
    @api newGSTValue = 0; 
    @api deletedPMIds = [];
    @api deletedPM = [];
    @api
    get planJSON() {
        return JSON.stringify(this.paymentMilestones);
    }
    set planJSON(value) {
        this.addrow = 2;
        this.paymentMilestones = JSON.parse(value);

        for (let i in this.paymentMilestones) {
            var pmap = this.paymentMilestones[i];
            pmap['Milestone_Activation__c'] = 'Booking Date';
            if (pmap.Project_Progress__c != null) {
                pmap['Milestone_Activation__c'] = 'Project Progress';
            }

            this.paymentMilestones[i] = pmap;
            //console.log(this.paymentMilestones[i]);
        }

        this.setCurrentAgreementValue();
		this.setCurrentGSTValue();
    }

    @api
    validate() {
        let isValidCheck = false;
				var totalAgreementRoundoff = this.newAgreementValue.toFixed(2);
				console.log(totalAgreementRoundoff);
				
				
        if (this.paymentMilestones) {

          let total = this.paymentMilestones.reduce((total, currentValue) => {
                return total + Number(currentValue.Milestone_Amount1__c);
            }, 0);
            if(total)
            {
                var totalRoundoff = total.toFixed(2);
				this.updatedTotal = totalRoundoff;
				console.log('updatedTotal '+ this.updatedTotal + 'newAgreementValue ' + this.newAgreementValue );
            }
            
            console.log('total ' + total);
            console.log('updatedTotal ' + this.updatedTotal);

            let GSTtotal = this.paymentMilestones.reduce((GSTtotal, currentValue) => {
                return GSTtotal + Number(currentValue.GST_Amount1__c);
            }, 0);
            console.log('GST total ' + GSTtotal);
            if(GSTtotal)
            {
                var GstRoundoff = GSTtotal.toFixed(2);
				this.updatedGSTTotal = GstRoundoff;
				console.log('updatedGSTTotal '+ this.updatedGSTTotal + ' newGSTValue ' + this.newGSTValue + ' this.newAgreementValue.toFixed(2) '+this.newAgreementValue.toFixed(2));
            }

            if (this.updatedTotal !== this.newAgreementValue.toFixed(2) && this.updatedTotal !== totalAgreementRoundoff) {
								console.log('in if');
                isValidCheck = false;
                console.log('this.updatedTotal isValidCheck'+isValidCheck);
            }
			else if(this.updatedGSTTotal !== this.newGSTValue.toFixed(2))
			{
					console.log('in else');
					isValidCheck = false;
                    console.log('this.updatedGSTTotal isValidCheck'+isValidCheck);
			}
            else {

                let isValid = this.paymentMilestones.reduce((validSoFar, milestone) => {

                    let isProjectProgress;
                    let daysAfterBooking;
                    if(milestone.Name != 'Possession/Handover(Other) Charge')
                    {
                    if (milestone.Milestone_Activation__c == 'Project Progress') {
                        isProjectProgress = this.checkValue(milestone.Project_Progress__c);
                        
                    }
                    else {
                        daysAfterBooking = this.checkValue(milestone.Milestone_Activation_Date__c);
                    }
                    }
                    else{
                        isProjectProgress = false;
                        daysAfterBooking = true;
                        



                    }
                        
                    //let daysAfterBooking = this.checkValue(milestone.Days_after_Booking__c);
                    let milestoneType = this.checkValue(milestone.Milestone_Activation__c);
                    let milestoneName = this.checkValue(milestone.Name);
										console.log('milestone.Name:' ,milestone.Name);
										let len = milestone.Name.length;
										console.log('len ' + len);
										
										if(len > 80)
										{
												console.log('in if--');
												return false;
										}

console.log('validSoFar'+validSoFar);
console.log('isProjectProgress'+isProjectProgress);
console.log('daysAfterBooking'+daysAfterBooking);
console.log('milestoneType'+milestoneType);
console.log('milestoneName'+milestoneName);
                    return validSoFar && (isProjectProgress || daysAfterBooking) && milestoneType && milestoneName;
                }, true);
console.log('isValid'+isValid);
                isValidCheck = isValid;
                console.log('isValidCheck'+isValidCheck);
            }
                
        }

        if (isValidCheck) {
            return { isValid: true };
        }
        else {
           //  return { isValid: true };
            // If the component is invalid, return the isValid parameter 
            // as false and return an error message. 
            return {
                isValid: false,
                errorMessage: 'Please ensure all fields are filled and Name Value is must be less than 80 character Total for Milestone Amount is ' + this.newAgreementValue  + ' Current Total: ' + this.updatedTotal + ' And GST Amount is ' + this.newGSTValue + '. Current GST Total: ' + this.updatedGSTTotal
            };
        }
    }

    checkValue(value) {
        return typeof value !== 'undefined' && value !== null && value !== '';
    }

    handleAddRow() {
          console.log('this.paymentMilestones----'+JSON.stringify(this.paymentMilestones));
           console.log('this.paymentMilestones.Booking__c'+this.paymentMilestones[0].Booking__c);

        this.paymentMilestones.push({
            Sequence_No__c: this.paymentMilestones.length + 1,
            Milestone_Status__c: 'Inactive',
            Booking__c:  this.paymentMilestones[0].Booking__c,
            Booking__r:
            {
              Registration_Status__c: 'Not Started'
            }

            

        });
         console.log('this.paymentMilestones'+JSON.stringify(this.paymentMilestones));
    }

    handleChange(event) {
        this.paymentMilestones[event.detail.index] = event.detail.paymentMilestone;
        console.log('event.detail.paymentMilestone'+event.detail.paymentMilestone);
        this.setCurrentAgreementValue();
		this.setCurrentGSTValue();
    }

    setCurrentAgreementValue() {
        if (this.paymentMilestones) {
            let total = this.paymentMilestones.reduce((total, currentValue) => {
                return total + Number(currentValue.Milestone_Amount1__c);
            }, 0);

            this.currentAgreementValue = total;
        }
    }
	setCurrentGSTValue() {
        if (this.paymentMilestones) {
            let total = this.paymentMilestones.reduce((total, currentValue) => {
                return total + Number(currentValue.GST_Amount1__c);
            }, 0);

            this.currentGSTValue = total;
        }
    }

    handleNext() {

        ["planJSON", "deletedPMIds", "deletedPM"].forEach((prop) =>
            this.dispatchEvent(new FlowAttributeChangeEvent(prop, this[prop]))
        );

        //const attributeChangeEvent = new FlowAttributeChangeEvent('planJSON', JSON.stringify(this.paymentMilestones));
        //this.dispatchEvent(attributeChangeEvent);

        const navigateNextEvent = new FlowNavigationNextEvent();
        this.dispatchEvent(navigateNextEvent);
    }

    deleteRow(event) {

        var key = event.target.dataset.index;
        if (this.paymentMilestones.length > 1) {

            if (this.paymentMilestones[key].Id) {
                //deleteRecord(this.paymentMilestones[key].Id);
                //this.deletedPMIds.push(this.paymentMilestones[key].Id);
                this.deletedPM.push(this.paymentMilestones[key].Id);

            }
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

        //console.log('===> deleteid ' + this.deletedPMIds);
        console.log('===> this.deletedPM ' + this.deletedPM);

    }

    renderedCallback() {
        if (this.validate().isValid === false) {
            this.template.querySelector('div.slds-notify').classList.remove('slds-hide');
        }
        else {
            this.template.querySelector('div.slds-notify').classList.add('slds-hide');
        }
    }
}