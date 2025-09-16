import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import fetchRelatedFiles from '@salesforce/apex/BulkDownloadFilesController.fetchRelatedFiles';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent, FlowNavigationFinishEvent } from 'lightning/flowSupport';
import { NavigationMixin } from 'lightning/navigation';

export default class BulkDownloadFiles extends NavigationMixin(LightningElement) {

    // @api recordId;
    @api bookingId;
    @track selectedOption;
    @track firstPage = true;
    @track secondPage = false;
    @track error;

    @track contentVersionList;

    @track columns = [
        { label: 'File Name', fieldName: 'Title', type: 'text' },
        { label: 'Created Date', fieldName: 'CreatedDate', type: 'date' },
        { label: 'File Type', fieldName: 'FileType', type: 'text' },
    ];



    changeHandler(event) {
        const field = event.target.name;
        if (field === 'optionSelect') {
            this.selectedOption = event.target.value;
            // alert("you have selected : " + this.selectedOption);
        }
    }
    nextPage() {
        if (this.selectedOption != undefined) {
            console.log('Selected File Type:' + this.selectedOption);

            fetchRelatedFiles({ recordId: this.bookingId, docType: this.selectedOption })
                .then(result => {
                    console.log('result is', JSON.stringify(result));
                    if (result.length > 0) {
                        this.firstPage = false;
                        this.secondPage = true;
                        this.contentVersionList = result;
                        this.error = undefined;


                    } else {
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'File(s) Download Failed',
                                message: 'There is no any files with selected doc type !!!',
                                variant: 'error'
                            }),
                        );

                    }

                })
                .catch(error => {
                    console.log("error message" + error);
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'File(s) Download Failed',
                            message: 'System Error Occurred',
                            variant: 'error'
                        }),
                    );

                });
        }
        else {
            const evt = new ShowToastEvent({
                title: 'Select Document Type',
                message: 'Document type is not selected',
                variant: 'error',
            });
            this.dispatchEvent(evt);
        }
    }
    
    bulkDownloadFiles() {
        var selectedRecords = this.template.querySelector("lightning-datatable").getSelectedRows();
        if (selectedRecords.length > 0) {
            console.log('selectedRecords are ', selectedRecords);

            let filesDownloadUrl = '/sfc/servlet.shepherd/version/download';

            selectedRecords.forEach(currentItem => {
                filesDownloadUrl += '/' +currentItem.Id;
            });

            console.log('filesDownloadUrl is', filesDownloadUrl);

            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: filesDownloadUrl
                }
            }, false);


            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'File(s) Downloading',
                    message: 'File(s) Downloading Started Successfully!!!',
                    variant: 'success'
                }),
            );

            setTimeout(() => {
                const navigateFinishEvent = new FlowNavigationFinishEvent();
                this.dispatchEvent(navigateFinishEvent);
            }, 1000)
        }
        else {
            const event = new ShowToastEvent({
                title: 'Error message',
                message: 'Please select files',
                variant: 'error',
                mode: 'dismissable'
            });
            this.dispatchEvent(event);
        }
    }
}