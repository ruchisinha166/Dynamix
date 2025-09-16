import { api, LightningElement, track } from 'lwc';
export default class ManageDiscountRow extends LightningElement {
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
    handleInput(event) {

        this.paymentMilestone[event.target.dataset.element] = event.detail.value;
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