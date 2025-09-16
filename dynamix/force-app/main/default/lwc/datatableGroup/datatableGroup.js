import { LightningElement, api } from 'lwc';

export default class DatatableGroup extends LightningElement {

    @api rows;
    @api columns;

    handleSort(event) {

        const { sortedBy, sortDirection } = event.detail;

        this.template.querySelector('c-datatable-rows').sort(sortedBy, sortDirection);
    }
}