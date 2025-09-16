import { api, LightningElement, track, wire } from 'lwc';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent } from 'lightning/flowSupport';
import { deleteRecord } from 'lightning/uiRecordApi';
export default class BookingPaymentPlan extends LightningElement {

    @track paymentMilestones = [];
    @track TotalInterestAmount = 0;
    @api intersAmountinput = 0;
    
    @api
    get planJSON() {
        return JSON.stringify(this.paymentMilestones);
    }
    set planJSON(value) {
        
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

       
    }
    @api
    validate() {
        let isValidCheck = false;
        if (this.paymentMilestones) {

          let total = this.paymentMilestones.reduce((total, currentValue) => {
                return total + Number(currentValue.Total_Interest_Amount__c);
            }, 0);
            
            if(total)
            {
                this.TotalInterestAmount = total;
            }
            console.log('total ' + total);
            
        }
        if (this.intersAmountinput > this.TotalInterestAmount) {
            isValidCheck = false;
        }
        else if(this.intersAmountinput < 0)
        {
            isValidCheck = false;
        }
        else{
            isValidCheck = true;
        }

        if (isValidCheck) {
            return { isValid: true };
        }
        else {
            // If the component is invalid, return the isValid parameter 
            // as false and return an error message. 
            return {
                isValid: false,
                errorMessage: 'Please ensure Interest Wave Off Amount should be positive and less than Total Interest Amount ' + this.TotalInterestAmount
            };
        }
    }

    checkValue(value) {
        return typeof value !== 'undefined' && value !== null && value !== '';
    }
    handleChange(event) {
        this.paymentMilestones[event.detail.index] = event.detail.paymentMilestone;
     //const attributeChangeEvent = new FlowAttributeChangeEvent('planJSON', JSON.stringify(this.paymentMilestones));
        //this.dispatchEvent(attributeChangeEvent);
    }
    handleChangeIntAmo(event){
        this.intersAmountinput = event.target.value;
        //const attributeChangeEvent = new FlowAttributeChangeEvent('intersAmountinput', intersAmountinput);
        //this.dispatchEvent(attributeChangeEvent);
        console.log('===> amount ' + this.intersAmountinput);
    }
    handleNext() {

        ["planJSON", "intersAmountinput"].forEach((prop) =>
            this.dispatchEvent(new FlowAttributeChangeEvent(prop, this[prop]))
        );
        const navigateNextEvent = new FlowNavigationNextEvent();
        this.dispatchEvent(navigateNextEvent);
    }

       
    renderedCallback() {
       if (this.validate().isValid === false) {
           // this.template.querySelector('div.slds-notify').classList.remove('slds-hide');
        }
        else {
            //this.template.querySelector('div.slds-notify').classList.add('slds-hide');
        }
    } 
  
}