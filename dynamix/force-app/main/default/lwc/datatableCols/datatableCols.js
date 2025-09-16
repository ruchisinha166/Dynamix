import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class DatatableCols extends NavigationMixin(LightningElement) {

    @api row;

    get rowInfo() {

        let rows = JSON.parse(JSON.stringify(this.row));
        rows.forEach(data => {

            if (data.fieldValue) {
                if (isNaN(Date.parse(data.fieldValue))) {
                    data.isDate = false;
                }
                else {
                    data.isDate = true;
                }
            }
        });
        return rows;
    }

    getURL() {
        this[NavigationMixin.Navigate]({
            type: 'standard__namedPage',
            attributes: {
                pageName: 'filePreview'
            },
            state: {
                selectedRecordId: this.row[0].fieldValue
            }
        });
    }
}