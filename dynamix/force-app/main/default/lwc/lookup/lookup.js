import { LightningElement, api, wire, track } from 'lwc';
import lookUpById from '@salesforce/apex/LookupController.lookUpById';
import find from '@salesforce/apex/LookupController.find';

export default class Lookup extends LightningElement {

    searchTerm;
    filters;
    createRecord;

    objName;
    displayFields;
    index;
    @track displayReadOnly;
    @track records;
    @track hasRecord;
    @track record;

    @api disabled = false;
    @api recordId;
    @api
    get config() {
        return this._config;
    }

    set config(entity) {
        this._config = entity;

        if (this.recordId) {
            this.objName = entity.objName;
            this.displayFields = entity.displayFields;
            this.displayReadOnly = true;
        }

        if (entity.objName === 'All') {
            this.setAllFilters(entity.searchEntities);
        }
        else {
            this.filters = this.setObjFilters(entity);
        }

        this.label = entity.label;
        this.createRecord = entity.createRecord;
    }

    get placeholder() {
        return 'Search ' + this._config.pluralLabel + '...';
    }

    setAllFilters(entities) {

        this.filters = '';

        let entityFilters = [];

        entities.forEach(entity => {
            entityFilters.push(this.setObjFilters(entity));
        });

        this.filters = entityFilters.join();
    }

    setObjFilters(entity) {
        let filterQuery = entity.objName;
        let endQuery = '';

        if (entity.displayFields) {
            filterQuery += ' (' + entity.displayFields;
            endQuery = ')'
        }

        if (entity.filters) {
            filterQuery += ' WHERE ' + entity.filters;
            endQuery = ')';
        }

        filterQuery += endQuery;

        return filterQuery;
    }

    @wire(find, { searchTerm: '$searchTerm', filters: '$filters' })
    searchRecords({ error, data }) {
        this.records = [];
        if (data) {
            for (let i = 0; i < data.length; i++) {
                let records = data[i];

                records.forEach(record => {
                    this.records.push(this.getRecord(record, i));
                });
            }
        } else if (error) {
            this.error = error;
        }
    }

    @wire(lookUpById, { recordId: '$recordId', objName: '$objName', fields: '$displayFields' })
    fetchRecord({ error, data }) {
        if (data) {
            this.record = this.getRecord(data, this.index);
            this.hasRecord = true;
        } else if (error) {
            this.error = error;
        }
    }

    getRecord(record, i) {

        let option = { ...record };

        let entity;
        if (this._config.objName === 'All') {
            entity = this._config.searchEntities[i];
        }
        else {
            entity = this._config;
        }

        option.display = this.generateLabel(option, entity);
        option.iconName = entity.iconName;
        option.label = entity.label;
        option.objName = entity.objName;
        option.displayFields = entity.displayFields;
        option.index = i;

        return option;
    }

    generateLabel(record, entity) {

        let label = entity.displayFormat;
        let splitFields = entity.displayFields.split(',');
        splitFields.forEach(field => {
            field = field.trim();
            let value;

            //logic to handle relationhships in queries
            if (field.indexOf('.') > -1) {
                let splitRelations = field.split('.');
                splitRelations.forEach(item => {
                    value = (value ? value[item] : record[item]);
                });
            } else {
                value = record[field];
            }

            value = value ? value : '';
            label = label.replace(field, value);
        });
        return label;
    }

    handleClick(event) {
            console.log('console : ',JSON.stringify(event.currentTarget.dataset.id));
        this.recordId = event.currentTarget.dataset.id;
        this.searchTerm = undefined;

        let selected = this.records.filter(
            (option) => option.Id === this.recordId
        );

        if (this._config.objName === 'All') {
            this._config = this._config.searchEntities[event.currentTarget.dataset.index];
        }

        this.dispatchEvent(new CustomEvent('change', {
            detail: {
                recordId: event.currentTarget.dataset.id,
                selectedEntity: this._config.objName,
                recordName: event.currentTarget.dataset.name
            }
        }));

        this.record = selected[0];
        this.hasRecord = true;

        this.template.querySelector('input').blur();
    }

    handleRemovePill() {
        this.recordId = undefined;
        this.hasRecord = false;

        this.dispatchEvent(new CustomEvent('change', {
            detail: {
                recordId: undefined,
                selectedEntity: this._config.objName
            }
        }));
    }

    handleChange(event) {
        this.searchTerm = event.target.value;
    }

    handleFocus() {
        this.template.querySelector('div.slds-combobox').classList.add('slds-is-open');
    }

    handleBlur() {
        this.template.querySelector('div.slds-combobox').classList.remove('slds-is-open');
    }

    handleMousedown(event) {
        event.preventDefault();
    }
}