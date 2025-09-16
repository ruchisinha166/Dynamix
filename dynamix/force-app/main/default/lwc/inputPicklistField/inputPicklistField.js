import { LightningElement, api, wire, track } from 'lwc';
import { getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';

export default class InputPicklistField extends LightningElement {

    @track options;
    objectInfo;
    fieldMap;
    controllingValue;

    @api label;
    @api name;
    @api value;
    @api objectApiName;
    @api fieldApiName;
    @api variant;
    @api disabled = false;
    @api isDependentPicklist = false;
    @api required = false;

    get placeholder() {
        return 'Choose ' + this.label;
    }

    @api
    get controllingFieldValue() {
        return this.controllingValue;
    }
    set controllingFieldValue(value) {

        this.controllingValue = value;

        if (this.isDependentPicklist && this.fieldMap) {

            if (value !== null && value !== undefined && value !== '') {

                let currentOptions = [{ label: '--None--', value: '', selected: true }];
                if (this.fieldMap.get(value)) {
                    this.fieldMap.get(value).forEach(opt => currentOptions.push(opt));
                }

                this.options = currentOptions;
            }
        }
    }

    @wire(getObjectInfo, { objectApiName: '$objectApiName' })
    objectInfo;

    @wire(getPicklistValuesByRecordType, { objectApiName: '$objectApiName', recordTypeId: '$objectInfo.data.defaultRecordTypeId' })
    fetchValues({ error, data }) {
        if (!this.objectInfo) {
            this.isError = true;
            this.errorMessage = 'Please Check You Object Settings';
            return;
        }
        if (data && data.picklistFieldValues) {
            try {
                this.setUpPicklistValues(data);
            } catch (err) {
                this.isError = true;
                this.errorMessage = err.message;
            }
        } else if (error) {
            this.isError = true;
            this.errorMessage = 'Object is not configured properly please check';
        }
    }

    setUpPicklistValues(data) {

        let selected = this.value ? false : true;
        this.options = [{ label: '--None--', value: '', selected: selected }];

        if (data.picklistFieldValues[this.fieldApiName]) {
            if (this.isDependentPicklist) {
                let pickMap = new Map();

                if (data.picklistFieldValues[this.fieldApiName].controllerValues !== undefined) {

                    const controllerValues = data.picklistFieldValues[this.fieldApiName].controllerValues;

                    Object.entries(controllerValues).forEach(([key, value]) => {
                        const picValues = data.picklistFieldValues[this.fieldApiName].values;
                        picValues.forEach(pickValue => {
                            if (pickValue.validFor.includes(value)) {
                                if (pickMap.has(key)) {
                                    let temp = pickMap.get(key);
                                    temp.push(pickValue);
                                    pickMap.set(key, temp);
                                } else {
                                    let temp2 = [];
                                    temp2.push(pickValue);
                                    pickMap.set(key, temp2);
                                }
                            }

                        });
                    });

                    this.fieldMap = pickMap;

                    if (this.controllingValue) {
                        this.controllingFieldValue = this.controllingValue;
                    }

                } else {
                    console.log("Error: This field is not a dependent picklist!");
                }
            }
            else {
                data.picklistFieldValues[this.fieldApiName].values.forEach(option => {
                    this.options.push({ label: option.label, value: option.value });
                });
            }
        } else {
            console.log("Error in fetching picklist values! Invalid picklist field");
        }
    }

    handleChange(event) {
        this.value = event.detail.value;

        const pickValueChangeEvent = new CustomEvent('picklistchange', {
            detail: {
                value: this.value,
                fieldApiName: this.fieldApiName
            }
        });
        this.dispatchEvent(pickValueChangeEvent);
    }
}