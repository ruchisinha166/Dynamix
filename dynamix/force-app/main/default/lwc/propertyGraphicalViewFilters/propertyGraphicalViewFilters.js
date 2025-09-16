import { api, LightningElement, track } from 'lwc';

export default class PropertyGraphicalViewFilters extends LightningElement {

    @track propertyFilters = [{ "label": "Tower: ANGELICA,CALAMUS", "name": "tower", "filterValues": ["ANGELICA", "CALAMUS"] }];

    @api toggleFilter = false;

    @api
    get filters() {
        return this.propertyFilters;
    }
    set filters(value) {
        this.propertyFilters = value;
    }

    handleFilterRemove(event) {

        const index = event.detail.index;

        this.dispatchEvent(new CustomEvent('filterremove', {
            detail: {
                index: index
            }
        }));
    }

    handleFilter() {
        this.dispatchEvent(new CustomEvent('togglefilter'));
    }

    errorCallback(error, stack) {
        console.error(error);
    }
}