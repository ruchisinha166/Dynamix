import { api, LightningElement } from 'lwc';

export default class FormReadOnlyElement extends LightningElement {

    @api label;
    @api value;
}