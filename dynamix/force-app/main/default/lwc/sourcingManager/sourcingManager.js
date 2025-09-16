import { LightningElement, api } from 'lwc';

export default class SourcingManager extends LightningElement {
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