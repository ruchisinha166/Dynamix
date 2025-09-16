import { api, LightningElement, track } from 'lwc';

export default class PricingPlanComponentRow extends LightningElement {

    pricingPlan;

    @api
    get pricePlanComponent() {
        return this.pricingPlan;
    }
    set pricePlanComponent(value) {
        this.pricingPlan = JSON.parse(JSON.stringify(value));
    }

    get isFixedCharge() {
        return this.pricePlanComponent.Project_Add_On_Charges__r.Charge_Type__c === 'Fixed';
    }

    get isVariableCharge() {
        return this.pricePlanComponent.Project_Add_On_Charges__r.Charge_Type__c != 'Fixed';
    }

    handlePicklistValue(event) {

        this.pricingPlan.GST_Treatment__c = event.detail.value;
        this.dispatchUpdate();
    }
    handlePicklistValue1(event) {
        this.pricingPlan.Component_Type__c = event.detail.value;
        this.dispatchUpdate();
    }
    handlePriceInput(event) {

        this.pricingPlan[event.target.dataset.element] = event.detail.value;
        this.dispatchUpdate();
    }

    dispatchUpdate() {
        this.dispatchEvent(new CustomEvent('priceplanchange', {
            detail: {
                pricePlanComponent: this.pricingPlan
            }
        }));
    }
}