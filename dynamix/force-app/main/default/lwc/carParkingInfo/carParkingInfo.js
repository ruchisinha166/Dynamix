import { api, LightningElement, track,wire } from 'lwc';
import { createMessageContext, publish } from 'lightning/messageService';
import { NavigationMixin } from 'lightning/navigation';
import changeStatus from '@salesforce/apex/CarParkingGraphicalViewController.changeStatus';  
import refresh from '@salesforce/messageChannel/Refresh__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';




export default class carParkingInfo extends NavigationMixin(LightningElement) {

    isAdmin = false;
    
    currentUserProfileId;
    userRoleName;
    error;
    @wire(getRecord, { recordId: USER_ID, fields: ['User.Profile.Name','User.UserRole.Name'] })
    wiredUser({ error, data }) {
        if (data) {
            const profileName = data.fields.Profile.value.fields.Name.value;
            console.log('profileName----'+profileName);
   
        if (data.fields.UserRole.value != null) {
            this.userRoleName = data.fields.UserRole.value.fields.Name.value;
        }
        console.log('this.userRoleName'+this.userRoleName);
            if(this.userRoleName.includes("Sales Manager") || profileName === 'System Administrator' || profileName === 'Sales' || profileName === 'Sales Manager'){
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
    
    @api property;
    @api recordId;
    @api oppId;
    @api showPropertyInfo;
    @api isTransfer;
    @api isAllocateVisible;
    @api flowName = 'Show_Suugested_Properties_On_Car_Parking_Short_List';
    @track isPopupVisible = false;
    suggestedProperties = [];
    @track showPropertySelector = false;
    @track showAlllocate = false;
    @track opportunityId;
    @track cpId;

    messageContext; 

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
    get showAlllocate()
    {
         console.log('this.isAllocateVisible'+this.isAllocateVisible);
      return this.isAllocateVisible;
    }
    get isShortListDisabled() {
        if (!this.oppId && this.isTransfer === false ) {
            return true;
        }
        else if (this.property && this.property.status == 'Available' ) {
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
    

    openBooking() {

        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.property.bookingId,
                actionName: 'view',
            },
        });
    }
    unallocate(){

        console.log('UnAllocate '+this.property.id);
        changeStatus({ propertyId: this.property.id}).then(result => {
                console.log(result);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: result,
                        variant: 'success',
                    })
                );
                location.reload();
                if (result != 'Record Already Exists') {
                    console.log('Inside If'+result);
                    getRecordNotifyChange([{ recordId: result }]);
                    publish(this.messageContext, refresh, {});
                }
                else {

                    const evt = new ShowToastEvent({
                        title: 'Error :',
                        message: 'Property is already suggested so please select another property',
                        variant: 'error',
                        mode: 'dismissable'
                    });
                    this.dispatchEvent(evt);
                }
            }).catch(error => {
                console.log('error-->' + JSON.stringify(error));
                this.error = error;
            });
    }
    submitFunction()
    {
        console.log('Submit');
        console.log('Transfer'+this.isTransfer);
        console.log('this.oppId'+this.oppId);
        console.log('this.property.parkingType'+this.property.status);
        console.log('this.property.id'+this.property.id);
        this.opportunityId = this.oppId;
        this.showPropertySelector = true;
        this.cpId = this.property.id;
        console.log('this.cpId'+this.cpId);
        
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