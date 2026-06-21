import { LightningElement , api} from 'lwc';

export default class Revise1 extends LightningElement {
    @api recordId;
    @api message;
    @api childProperty;
}