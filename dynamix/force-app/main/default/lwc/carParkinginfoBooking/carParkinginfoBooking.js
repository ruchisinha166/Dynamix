import { api,wire, LightningElement, track } from 'lwc';
import { createMessageContext, publish } from 'lightning/messageService';
import { NavigationMixin } from 'lightning/navigation';
import { getRecord } from 'lightning/uiRecordApi';
import createAddOnBookingCarParking from '@salesforce/apex/CreateAddOn.createAddOnBookingCarParking';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import USER_ID from '@salesforce/user/Id';



export default class carParkingInfoBooking extends NavigationMixin(LightningElement) {

    @api property;
    @api recordId;
    @api oppId;
    @api showPropertyInfo;
    @api isTransfer;
    @api flowName = 'Show_Suugested_Properties_On_Car_Parking_Short_List';
    @track isPopupVisible = false;
    suggestedProperties = [];
    @track showPropertySelector = false;
    @track opportunityId;
    @track cpId;
    @track errorMessage = '';
    @track errorClass = 'slds-hide';

    isAdmin = false;

    messageContext;
    currentUserProfileId;
    error;
    @wire(getRecord, { recordId: USER_ID, fields: ['User.Profile.Name'] })
    wiredUser({ error, data }) {
        if (data) {
            const profileName = data.fields.Profile.value.fields.Name.value;
            console.log('profileName----'+profileName);
            if(profileName === 'System Administrator' || profileName === 'Post Sales'){
                this.isAdmin = true;
            }
            
        } else if (error) {
            this.handleError(error);
        }
    }

    handleError(error) {
        // Handle error, e.g., show error toast
        const evt = new ShowToastEvent({
            title: 'Error',
            message: error.body.message,
            variant: 'error',
        });
        this.dispatchEvent(evt);
    }
    
    constructor() {
        super();

        this.messageContext = createMessageContext();
    }

    get button(){
        return 'Unallocate';
    }

    get buttonName() {

        if (this.isTransfer === true) {
            return 'Transfer';
        }
        
        else {
            return 'Allocate';
        }
    }

    get bookingUrl() {

        if (this.property.bookingId) {
            return '/' + this.property.bookingId;
        }
    }

    get isShortListDisabledUnAllocate(){
        if(this.property && this.property.status =='Available'){
            return true;
        }
        else{
            return false;
        }
    }

    get isShortListDisabled() {
        if (!this.oppId && this.isTransfer === false) {
            return true;
        }
        else if (this.property && this.property.status == 'Available') {
            return false;
        }
        else {
            return true;
        }
    }

    handleClose() {
        this.dispatchEvent(new CustomEvent('closeinfo'));
    }

    get showPricingDetails() {
        return this.property.status === 'Available' || this.property.status === 'Reserved';
    }

    get showBookingUrl() {
        return this.property.status === 'Booked';
    }

    get showBookingDetails() {
        return this.property.status != 'Available';
    }
    get opportunityId() {
        return this.oppId;
        
    }

    @wire(getRecord, { recordId: '$oppId', fields: ['Booking__c.Total_Amount_Due__c', 'Booking__c.Total_Billed_Amount__c','Booking__c.Registration_Status__c'] })
    record;

    

    openBooking() {

        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.property.bookingId,
                actionName: 'view',
            },
        });
    }
   
    submitFunction()
    {
        

        if(this.record.data){
            
            const outstandingAmt = this.record.data.fields.Total_Amount_Due__c.value;
            const dueAmt = this.record.data.fields.Total_Billed_Amount__c.value;
            const stage = this.record.data.fields.Registration_Status__c.value;

            const percntage = (outstandingAmt/dueAmt)*100;

            console.log('outstandingAmt'+JSON.stringify(outstandingAmt));
            console.log('dueAmt'+JSON.stringify(dueAmt));
            console.log('stage'+JSON.stringify(stage));
            console.log('outstandingAmt'+outstandingAmt);
            console.log('dueAmt'+dueAmt*0.9);
              //else if(stage=='Completed' && outstandingAmt <= dueAmt*0.9){
            if(stage=='Completed' && outstandingAmt >= dueAmt*0.9){
                console.log('percntage'+percntage);
                this.errorMessage = 'There is an overdue of '+percentage+ '% on last demand on the booking selected, please ask customer clear the same before initiating the car park request';
                this.errorClass = 'slds-show';
            }
            //else if(stage=='Completed' && outstandingAmt >= dueAmt*0.9){
            else if(stage=='Completed' && outstandingAmt <= dueAmt*0.1){
                console.log('carParkId '+this.property.Id);
                createAddOnBookingCarParking({
               booknigId: this.oppId,
               CarParkId: this.property.id
           }).then(result =>{
               console.log('Apex method result: ',result);
               this.dispatchEvent(
                   new ShowToastEvent({
                       title: 'Success',
                       message: 'Record Created Successfully and Please update the payment plan with the allocated car park value',
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
            setTimeout(function () { (window.location.reload()) }.bind(this), 4000);

            //location.reload();
            }
            else{
                console.log('carParkId '+this.property.Id);
                createAddOnBookingCarParking({
               booknigId: this.oppId,
               CarParkId: this.property.id
           }).then(result =>{
               console.log('Apex method result: ',result);
               this.dispatchEvent(
                   new ShowToastEvent({
                       title: 'Success',
                    //message: 'Record Created Successfully',
                        message: 'Record Created Successfully and Please update the payment plan with the allocated car park value',

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
            setTimeout(function () { (window.location.reload()) }.bind(this), 4000);
         //  location.reload();
            }
        }
        
        
    }

    closePopup() {
        // Set isPopupVisible to false to hide the popup
        this.isPopupVisible = false;
    }

    renderedCallback() {
        if (this.showPropertyInfo) {
            this.template.querySelector('div.slds-panel').classList.add('slds-is-open');
            this.template.querySelector('div.slds-panel').classList.add('flexi-box');
            this.template.querySelector('div.slds-panel').classList.remove('slds-hidden');
        }
        else {
            this.template.querySelector('div.slds-panel').classList.remove('slds-is-open');
            this.template.querySelector('div.slds-panel').classList.remove('flexi-box');
            this.template.querySelector('div.slds-panel').classList.add('slds-hidden');
        }
    }
}