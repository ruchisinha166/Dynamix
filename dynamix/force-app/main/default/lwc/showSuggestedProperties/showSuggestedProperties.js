import { LightningElement, api, track } from 'lwc';
import getSuggProp from '@salesforce/apex/CarParkingGraphicalViewController.getSuggProp';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createOpportunityAddOns from '@salesforce/apex/CreateAddOn.createOpportunityAddOns';
export default class showSuggestedProperties extends LightningElement {
    @api opportunityId;
    @api cpId; 
    @track propertyOptions = [];
    @track selectedProperty;

    connectedCallback() {
        this.fetchProperties();
        console.log('cpId:', this.cpId);
    }

    fetchProperties() {
         console.log('Fetching properties for opportunityId:', this.opportunityId);
        getSuggProp({ opportunityId: this.opportunityId })
            .then(result => {
                this.propertyOptions = result.map(prop => ({
                    label: prop.Name+' ('+prop.Unit__r.Name+')',
                    value: prop.Id,
                }));
            })
            .catch(error => {
                console.error('Error fetching properties', error);
            });
    }

    handleClose() {
        window.location.reload();
    }

    renderedCallback() {
        loadStyle(this, styles);
    }

    createAddOn() {
        if (!this.selectedProperty) {
            console.log('error');
            return;
        }

        else{
            console.log('InsideElse');
            console.log('opportunityId in callApexMethod:', this.opportunityId);
            console.log('cpId in callApexMethod:', this.cpId);
            console.log('selectedProperty in callApexMethod:', this.selectedProperty);
           createOpportunityAddOns({
               OppId: this.opportunityId,
               SuggPropId: this.selectedProperty,
               CarParkId: this.cpId,
           }).then(result =>{
               console.log('Apex method result: ',result);
               this.dispatchEvent(
                   new ShowToastEvent({
                       title: 'Success',
                       message: 'Record Created Successfully',
                       variant: 'Success',
                   })
               );
           }).catch(error => {
               console.error('Error calling Apex method:', error);

               this.dispatchEvent(
                   new ShowToastEvent({
                       title: 'Error',
                       method: 'An error occured while creating the record',
                       variant: 'error',
                   })
               );
           });

           location.reload();
        }
    }

     handlePropertyChange(event) {
        // Capture the selected property Id from the radio group
        this.selectedProperty = event.detail.value;
    }     
}