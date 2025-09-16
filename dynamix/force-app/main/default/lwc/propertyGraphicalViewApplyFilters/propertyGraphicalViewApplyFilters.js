import { api, LightningElement, track, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getProperties from '@salesforce/apex/PropertyGraphicalViewController.getProperties';

const FIELDS = [
    'Opportunity.Unit_Type__c',
    'Opportunity.Project__c'
];

export default class PropertyGraphicalViewApplyFilters extends LightningElement {

    allProperties;
    propertyFilters = [];

    @track projectId;

    @track options = {};
    @track selectedOptions = {
        unitType: [],
        tower: [],
        pLC: []
    };

    @api recordId;
    @api toggleFilter;
    @api propertyGraph;

    @api
    get filters() {
        return this.propertyFilters;
    }
    set filters(value) {
        this.propertyFilters = value;

        this.selectedOptions = {
            unitType: [],
            tower: [],
            pLC: []
        }

        this.propertyFilters.forEach(propFilter => {
            this.selectedOptions[propFilter.name] = propFilter.filterValues;
        });

    }

    @wire(getProperties, { projectId: '$recordId' })
    getProperties({ error, data }) {
        if (data) {
            this.allProperties = data;
            this.getFiltersWithOptions();
        }

        if (error) {
            console.error(error);
        }
    }

    getFiltersWithOptions() {
        if (this.allProperties) {

            const unitTypeValues = [...new Set(this.allProperties.map(option => option.unitType))];
            this.options.unitType = [];
            unitTypeValues.sort().forEach(option => {
                this.options.unitType.push({ label: option, value: option })
            });

            const towerTypeValues = [...new Set(this.allProperties.map(option => option.tower))];
            this.options.tower = [];
            towerTypeValues.sort().forEach(option => {
                this.options.tower.push({ label: option, value: option })
            });

            const pLCValuesSplit = [...new Set(this.allProperties.map(option => option.preferredLocation.split(',')))];
            let pLCValuesArray = [];

            pLCValuesSplit.forEach(option => {
                option.forEach(opt => {
                    pLCValuesArray.push(opt);
                })
            });

            const pLCValues = [...new Set(pLCValuesArray)];

            this.options.pLC = [];
            pLCValues.sort().forEach(option => {
                if (option !== 'Not Available') {
                    this.options.pLC.push({ label: option, value: option });
                }
            });
        }
    }

    handleChange(event) {

        this.propertyFilters = this.propertyFilters.filter(
            propFilter => propFilter.name != event.target.dataset.fieldapiname
        );

        if (event.detail.value && event.detail.value.length > 0) {
            let filter = {};
            filter.label = event.target.dataset.fielddisplayname + ': ' + event.detail.value.join(',')
            filter.name = event.target.dataset.fieldapiname;
            filter.filterValues = event.detail.value;

            this.propertyFilters.push(filter);
        }

        this.dispatchEvent(new CustomEvent('filterchange', {
            detail: {
                filters: this.propertyFilters
            }
        }));
    }

    handleFilterToggle() {
        this.dispatchEvent(new CustomEvent('togglefilter'));
    }

    renderedCallback() {
        if (this.toggleFilter) {
            this.template.querySelector('div.slds-panel').classList.add('slds-is-open');
            this.template.querySelector('div.slds-panel').classList.remove('slds-hidden');
        }
        else {
            this.template.querySelector('div.slds-panel').classList.remove('slds-is-open');
            this.template.querySelector('div.slds-panel').classList.add('slds-hidden');
        }
    }
}