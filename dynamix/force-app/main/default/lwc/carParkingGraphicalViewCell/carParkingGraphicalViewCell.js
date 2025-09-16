import { api, LightningElement } from 'lwc';

    export default class carParkingGraphicalViewCell extends LightningElement {

        @api property;
        @api flatNumber;
        @api disabled = false;
        @api filtered = false;
        @api snagcolorstatus = false;

        handleClick() {
            this.dispatchEvent(new CustomEvent('property_select', { bubbles: true, composed: true, detail: this.property }));
        }

        renderedCallback() {
   
            if (this.property && this.disabled === false) {
                
                if (this.property.status === 'Allotted In Progress') {
                    this.template.querySelector('span.slds-visual-picker__figure').classList.add('hold');
                }
                
                else if (this.property.status === 'Pre - Allotted') {
                    //this.disabled = true;
                    this.template.querySelector('span.slds-visual-picker__figure').classList.add('sold');
                }
                else if (this.property.status === 'Allotted') {
                    this.template.querySelector('span.slds-visual-picker__figure').classList.add('blocked');
                }
                else if (this.property.status === 'Available'){
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
                 console.log('snagcolorstatus'+this.property.SnagStatus);
                   if(this.snagcolorstatus === true && this.property.SnagStatus === 'Internal Snagging')
                {
                    this.template.querySelector('span.slds-visual-picker__figure').classList.add('yetToStart');
                }
                
            }
        }
    }