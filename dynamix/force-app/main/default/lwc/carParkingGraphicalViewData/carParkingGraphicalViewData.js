import { api, LightningElement } from 'lwc';

export default class carParkingGraphicalViewData extends LightningElement {

    @api propertyGraph;

    renderedCallback() {

        if (this.template.querySelector('lightning-tabset')) {
            const style = document.createElement('style');
            style.innerText = 'lightning-tabset.flexi-box div.slds-tabs_default {overflow: auto;height: 100%;display: flex;flex-direction: column;flex: 1;position: relative;}';
            this.template.querySelector('lightning-tabset').appendChild(style);
        }
    }
}