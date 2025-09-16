import { LightningElement, api } from 'lwc';
import fetchRecords from '@salesforce/apex/SalesManagerLookUp.fetchRecords';
/** The delay used when debouncing event handlers before invoking Apex. */
const DELAY = 500;

export default class SalesManagerowner extends LightningElement {
@api helpText = "custom search lookup";
@api label = "Parent Account";
@api required;
@api selectedIconName = "standard:User";
@api objectLabel = "User";
recordsList = [];
selectedRecordName;

@api objectApiName = "User";
@api fieldApiName = "Name";
@api otherFieldApiName = "Phone";
@api searchString = "";
@api selectedRecordId = "";
@api parentRecordId;
@api parentFieldApiName;
@api sourcingManagerName;
@api sourcingManagerId;
@api role;
@api makeItReadOnly;
preventClosingOfSerachPanel = false;
previousSourcingManagerId
areDetailsVisible = false;
get methodInput() {
    return {
        objectApiName: this.objectApiName,
        fieldApiName: this.fieldApiName,
        otherFieldApiName: this.otherFieldApiName,
        searchString: this.searchString,
        selectedRecordId: this.selectedRecordId,
        parentRecordId: this.parentRecordId,
        role: this.role,
        parentFieldApiName: this.parentFieldApiName
    };
}

get showRecentRecords() {
   
    if (!this.recordsList) {
        return false;
    }
    return this.recordsList.length > 0;
}

//getting the default selected record
connectedCallback() {
console.log('Test this.makeItReadOnly---'+ this.makeItReadOnly);
    this.makeItReadOnly=this.makeItReadOnly;

        console.log(' this.makeItReadOnly---'+ this.makeItReadOnly);

if(this.makeItReadOnly == 'Yes')
{
    this.areDetailsVisible = true;
        
}
else{
    this.areDetailsVisible = false;
}
    console.log('this.areDetailsVisible---'+this.areDetailsVisible);
     this.selectedRecordId= this.sourcingManagerId,
     this.previousSourcingManagerId=this.sourcingManagerId,
      this.selectedRecordName = this.sourcingManagerName,
      this.makeItReadOnly=this.makeItReadOnly,
     console.log('this.selectedRecordId----'+this.selectedRecordId);
      console.log('ReadOnly----'+ this.makeItReadOnly);
    if (this.selectedRecordId) {
        this.fetchSobjectRecords(true);
    }
}

//call the apex method
fetchSobjectRecords(loadEvent) {
    fetchRecords({
        inputWrapper: this.methodInput
    }).then(result => {
        if (loadEvent && result) {
            if(this.selectedRecordId == this.previousChannelPartnerId)

        {
this.selectedRecordName =this.selectedRecordName;
        }
            else{
this.selectedRecordName = result[0].mainField;
            } 
        } else if (result) {
            this.recordsList = JSON.parse(JSON.stringify(result));
        } else {
            this.recordsList = [];
        }
    }).catch(error => {
        console.log(error);
    })
}

get isValueSelected() {
    return this.selectedRecordId;
}

//handler for calling apex when user change the value in lookup
handleChange(event) {
    this.searchString = event.target.value;
    this.fetchSobjectRecords(false);
}

//handler for clicking outside the selection panel
handleBlur() {
    this.recordsList = [];
    this.preventClosingOfSerachPanel = false;
}

//handle the click inside the search panel to prevent it getting closed
handleDivClick() {
    this.preventClosingOfSerachPanel = true;
}

//handler for deselection of the selected item
handleCommit() {
    this.selectedRecordId = "";
    this.selectedRecordName = "";
}

//handler for selection of records from lookup result list
handleSelect(event) {
    let selectedRecord = {
        mainField: event.currentTarget.dataset.mainfield,
        subField: event.currentTarget.dataset.subfield,
        id: event.currentTarget.dataset.id
    };
    this.selectedRecordId = selectedRecord.id;
    this.selectedRecordName = selectedRecord.mainField;
    this.recordsList = [];
    // Creates the event
    const selectedEvent = new CustomEvent('valueselected', {
        detail: selectedRecord.id
    });
    console.log('selectedRecord.id'+selectedRecord.id);
    //dispatching the custom event
    this.dispatchEvent(selectedEvent);
}

//to close the search panel when clicked outside of search input
handleInputBlur(event) {
    // Debouncing this method: Do not actually invoke the Apex call as long as this function is
    // being called within a delay of DELAY. This is to avoid a very large number of Apex method calls.
    window.clearTimeout(this.delayTimeout);
    // eslint-disable-next-line @lwc/lwc/no-async-operation
    this.delayTimeout = setTimeout(() => {
        if (!this.preventClosingOfSerachPanel) {
            this.recordsList = [];
        }
        this.preventClosingOfSerachPanel = false;
    }, DELAY);
}

}