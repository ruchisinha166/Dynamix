import { api, LightningElement, track, wire } from 'lwc';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent } from 'lightning/flowSupport';

export default class ManageDiscontForPriceDetails extends LightningElement {
    @api paymentMilestones = [];

    @api
    get planJSON() {
        return JSON.stringify(this.paymentMilestones);
    }
    set planJSON(value) {
        this.paymentMilestones = JSON.parse(value);
    }

    handleChange(event) {
        this.paymentMilestones[event.detail.index] = event.detail.paymentMilestone;

        const attributeChangeEvent = new FlowAttributeChangeEvent('planJSON', JSON.stringify(this.paymentMilestones));
        this.dispatchEvent(attributeChangeEvent);
    }
}