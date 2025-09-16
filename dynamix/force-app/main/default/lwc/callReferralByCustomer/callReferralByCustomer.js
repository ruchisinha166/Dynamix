import { LightningElement, api } from 'lwc';
export default class CallReferralByCustomer extends LightningElement {
@api message;
@api referralName
@api setReadOnlyChannelPartner
@api referralId
@api selectedIconName = "standard:Account";
referralByCustomerId;
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
handleValueSelectedOnreferralByCustomer(event) {
    this.referralByCustomerId = event.detail;
    console.log(' this.referralByCustomerId'+ this.referralByCustomerId);
    this.dispatchEvent(new CustomEvent(
    'getreferralByCustomerIdData', 
        {
            detail: { referralByCustomerId:  this.referralByCustomerId},
            bubbles: true,
            composed: true,
        }
    ));
}
}