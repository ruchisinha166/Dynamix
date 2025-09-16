import { LightningElement, track, wire, api } from 'lwc';
import getPricingList from '@salesforce/apex/pricingPlanClass.getPricingList';
import createRecords from '@salesforce/apex/pricingPlanClass.createRecords';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class pricingPlan extends NavigationMixin(LightningElement) {

    @api recordId;
    @track pricingPlanList = [];
    @track pricingPlanUpdated;

    saveClicked = false;
    planName;
    projectId;
    pricePlanId;
    validFromDate;
    validToDate;

    get disableSave() {
        if (this.pricingPlanUpdated) {
            
            let isValid = this.pricingPlanUpdated.reduce((validSoFar, pricePlan) => {
                console.log('pricePlan>>: ',JSON.stringify(pricePlan));
                console.log('validSoFar>> : ',validSoFar);
                let planNameCheck = this.checkValue(this.planName);
                let isGSTTreatment = this.checkValue(pricePlan.GST_Treatment__c);
                let amountLumpsum = this.checkValue(pricePlan.Price_Lumpsum__c);
                let amountPerSQFT = this.checkValue(pricePlan.Price_per_SQFT__c);
                let amountAge = this.checkValue(pricePlan.Price_age__c);
                let componentType = this.checkValue(pricePlan.Component_Type__c);
                console.log(isGSTTreatment);

                return validSoFar && (amountLumpsum || amountPerSQFT || amountAge) && isGSTTreatment && planNameCheck && componentType;
            }, true);

            return !isValid || this.saveClicked;
        }
        else {
            return true;
        }

    }

    checkValue(value) {
        return typeof value !== 'undefined' && value !== null && value !== '';
    }

    @wire(getPricingList, { recordId: '$recordId' })
    wiredPricing({ data, error }) {
        if (data) {
            this.planName = data.pricePlanName;
            this.validFromDate = data.validFrom;
            this.validToDate = data.validTo;
            console.log('validFromDate : ',data.validFrom);
            console.log('validToDate : ',data.validTo);
            this.pricingPlanList = data.pPCLst;
            this.projectId = data.projectId;
            this.pricePlanId = data.pricePlanId;
            this.pricingPlanUpdated = JSON.parse(JSON.stringify(data.pPCLst));
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.pricingPlanList = undefined;
            console.log("error: " + error);
        }
    }

    handleChange(event) {

        let pricePlanIndex = this.pricingPlanUpdated.findIndex(pricingPlan => pricingPlan.Project_Add_On_Charges__c === event.detail.pricePlanComponent.Project_Add_On_Charges__c);
        this.pricingPlanUpdated[pricePlanIndex] = event.detail.pricePlanComponent;
        console.log(this.pricingPlanUpdated);
    }

    planNameChange(event) {
        this.planName = event.target.value;
    }
    validFromChange(event){
        this.validFromDate = event.target.value;
    }
    validToChange(event){
        this.validToDate = event.target.value;
        console.log('validToDate12 : ',this.validToDate);
    }
    handleSave(event) {

        this.saveClicked = true;

        createRecords({ planObjectList: this.pricingPlanUpdated, pricingPlan: this.planName, validFrom: this.validFromDate, ValidTo: this.validToDate, projectId: this.projectId, pricePlanId: this.pricePlanId })
            .then(result => {
                console.log('result==' + result);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Records created',
                        variant: 'success'
                    })
                );

                this[NavigationMixin.Navigate](
                    {
                        type: 'standard__recordPage',
                        attributes:
                        {
                            "recordId": this.recordId,
                            "objectApiName": "PRICING_PLAN",
                            "actionName": "view"
                        }
                    });
            })
            .catch(error => {
                console.log(error);
            });
    }

    handleExit(event) {

        this[NavigationMixin.Navigate](
            {
                type: 'standard__recordPage',
                attributes:
                {
                    "recordId": this.recordId,
                    "objectApiName": "PRICING_PLAN",
                    "actionName": "view"
                }
            });
    }

    renderedCallback() {
        if (this.disableSave === true) {
            this.template.querySelector('div.slds-notify').classList.remove('slds-hide');
        }
        else {
            this.template.querySelector('div.slds-notify').classList.add('slds-hide');
        }
    }
}