import { LightningElement, api } from 'lwc';
export default class CallReusableLookUp extends LightningElement {
@api message;
@api recordInfo
@api salesManagerName
@api secondarySalesManager
@api makeItReadOnly
@api secondarySalesManagerName
@api secondarySalesManagerId
parentAccountSelectedRecord;
@api selectedIconName = "standard:User";
salesMaangerId;
areDetailsVisible = false;//getting the default selected record
connectedCallback() {
    console.log('Test secondarySalesManager---'+ secondarySalesManager);
      this.secondarySalesManager=this.secondarySalesManager;

          console.log(' this.secondarySalesManager---'+ this.secondarySalesManager);

    if(this.secondarySalesManager == 'Yes')
    {
        this.areDetailsVisible = true;
         
    }
    else{
        this.areDetailsVisible = false;
    }
    console.log('this.areDetailsVisible---'+this.areDetailsVisible);
}


handleValueSelectedOnSalesManager(event) {
    this.salesMaangerId = event.detail;
    console.log(' this.salesMaangerId'+ this.salesMaangerId);
    this.dispatchEvent(new CustomEvent(
    'getSalesManagerdata', 
        {
            detail: { salesMaangerId:  this.salesMaangerId},
            bubbles: true,
            composed: true,
        }
    ));
}
    handleValueSelectedOnSecondarySalesManager(event) {
    this.secondarySalesManagerId = event.detail;
    console.log(' this.secondarySalesManagerId'+ this.secondarySalesManagerId);
    this.dispatchEvent(new CustomEvent(
    'getSecondarySalesManagerdata', 
        {
            detail: { secondarySalesManagerId:  this.secondarySalesManagerId},
            bubbles: true,
            composed: true,
        }
    ));
}
}