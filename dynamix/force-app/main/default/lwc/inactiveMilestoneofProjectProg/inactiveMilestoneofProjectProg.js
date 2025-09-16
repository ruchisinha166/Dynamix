import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent,FlowNavigationFinishEvent } from 'lightning/flowSupport';
import getMilestoneList from '@salesforce/apex/MilestoneLWCHelper.getMilestoneList';
export default class InactiveMilestoneofProjectProg extends LightningElement {


    @api projectProgId;
    @track error;
    @track milestoneList;

    @api selMilestoneRecords = [];

    @track columns = [
        { label: 'Booking Name', fieldName: 'Booking_Name', type: 'text' },
        { label: 'Customer Name', fieldName: 'Customer_Name', type: 'text' },
        { label: 'Unit No', fieldName: 'Unit_no', type: 'text' },
        { label: 'Milestone Name', fieldName: 'Name', type: 'text' },
        { label: 'Milestone Amount', fieldName: 'Milestone_Amount1__c', type: 'currency' },
    ];

    @wire(getMilestoneList, { projectProgId: '$projectProgId' })
    WireMilestones({ error, data }) {
        if (data) {

            let tempRecords = JSON.parse(JSON.stringify(data));
            tempRecords = tempRecords.map(row => {
                return {
                    ...row, Booking_Name: row.Booking__r.Name,
                    Customer_Name: row.Booking__r.Primary_Applicant_Name_Formulla__c,
                    Unit_no: row.Booking__r.Unit_Number__c,
                };
            })
            this.milestoneList = tempRecords;
            this.error = undefined;
            //  this.milestoneList = data;
        }
        else if (error) {
            this.error = error;
            this.milestoneList = undefined;
        }
    }

    getSelectedRec() {
        var selectedRecords = this.template.querySelector("lightning-datatable").getSelectedRows();
        if (selectedRecords.length > 0) {
            console.log('selectedRecords are ', selectedRecords);
            var milestoneIds=[];
          /*  let ids = '';
            selectedRecords.forEach(currentItem => {
                ids = ids + ',' + currentItem.Id;
            });
            this.selectedIds = ids.replace(/^,/, '');
            this.lstSelectedRecords = selectedRecords;
*/
// alert(this.selectedIds);
selectedRecords.forEach(currentItem => {
    milestoneIds.push(currentItem.Id);
});

            const attributeChangeEvent = FlowAttributeChangeEvent(
                'selMilestoneRecords',
                JSON.stringify(milestoneIds)
            );
            this.dispatchEvent(attributeChangeEvent);

            const navigateNextEvent = new FlowNavigationNextEvent();
            this.dispatchEvent(navigateNextEvent);

           
        }
        else if(selectedRecords.length ==0){
            const event = new ShowToastEvent({
                title: 'Error message',
                message: 'Please select milestone records',
                variant: 'error',
                mode: 'dismissable'
            });
            this.dispatchEvent(event);
        }
    }
    closeAction() {
        //const navigateFinishEvent = new FlowNavigationFinishEvent();
       // this.dispatchEvent(navigateFinishEvent);
     }
}