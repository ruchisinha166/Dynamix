import { api, LightningElement } from 'lwc';

export default class PropertyGraphicalViewCell extends LightningElement {

    @api property;
    @api flatNumber;
    @api disabled = false;
    @api filtered = false;

    handleClick() {
        this.dispatchEvent(new CustomEvent('property_select', { bubbles: true, composed: true, detail: this.property }));
    }

    renderedCallback() {

        if (this.property && this.disabled === false) {
            if (this.property.status === 'Refuge') {
                this.template.querySelector('span.slds-visual-picker__figure').classList.add('refuge');
            }
            else if (this.property.status === 'In Progress') {
                this.template.querySelector('span.slds-visual-picker__figure').classList.add('hold');
            }
            else if (this.property.status === 'Blocked') {
                this.template.querySelector('span.slds-visual-picker__figure').classList.add('blockeds');
            }
            else if (this.property.status === 'Booked') {
                //this.disabled = true;
                this.template.querySelector('span.slds-visual-picker__figure').classList.add('sold');
            }
            else if (this.property.status === 'Reserved') {
                this.template.querySelector('span.slds-visual-picker__figure').classList.add('blocked');
            }
            else if (this.property.status === 'Confirmed Allocation') {
            this.template.querySelector('span.slds-visual-picker__figure').classList.add('CA');
        }  
            else {
                this.template.querySelector('span.slds-visual-picker__figure').classList.add('available');
            }

            if (this.filtered === true) {
                this.template.querySelector('span.slds-visual-picker__figure').classList.add('filteredCell');
                this.template.querySelector('span.slds-text-heading_small').classList.add('filteredText');
            }
            else {
                this.template.querySelector('span.slds-visual-picker__figure').classList.remove('filteredCell');
                this.template.querySelector('span.slds-text-heading_small').classList.remove('filteredText');
            }
        }
    }
}