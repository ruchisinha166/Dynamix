import { LightningElement, api } from 'lwc';

export default class CallOwnerLookUp extends LightningElement {
 @api message;
 @api recordInfo
 @api channelPartnerName
 @api sourcingManagerId
 @api sourcingManagerName

 @api setReadOnlyChannelPartner
 parentAccountSelectedRecord;
 sourcingManagerId;
 areDetailsVisible = false;//getting the default selected record

connectedCallback() {
    console.log('Test setReadOnlyChannelPartner---'+ setReadOnlyChannelPartner);
      this.setReadOnlyChannelPartner=this.setReadOnlyChannelPartner;

          console.log(' this.setReadOnlyChannelPartner---'+ this.setReadOnlyChannelPartner);

    if(this.setReadOnlyChannelPartner == 'Yes')
    {
        this.areDetailsVisible = true;
         
    }
    else{
        this.areDetailsVisible = false;
    }
    console.log('this.areDetailsVisible---'+this.areDetailsVisible);
}
    handleValueSelectedOnAccount(event) {
        this.parentAccountSelectedRecord = event.detail;
        console.log(' this.parentAccountSelectedRecord'+ this.parentAccountSelectedRecord);
        this.dispatchEvent(new CustomEvent(
        'getdata', 
            {
                detail: { parentAccountSelectedRecord:  this.parentAccountSelectedRecord},
                bubbles: true,
                composed: true,
            }
        ));
    }
    handleValueSelectedOnSourcingManager(event) {
        this.sourcingManagerId = event.detail;
        console.log(' this.sourcingManagerId'+ this.sourcingManagerId);
        this.dispatchEvent(new CustomEvent(
        'getSourcingManagerdata', 
            {
                detail: { sourcingManagerId:  this.sourcingManagerId},
                bubbles: true,
                composed: true,
            }
        ));
    }
}