import { LightningElement, api } from 'lwc';

export default class FileOrganiserHeader extends LightningElement {

    @api hasFiles = false;

    handleRefreshFiles() {
        this.dispatchEvent(new CustomEvent('retrieve', {}));
    }

    handleUploadFiles() {
        this.dispatchEvent(new CustomEvent('upload', {}));
    }

    handleSearch(event) {
        this.dispatchEvent(new CustomEvent('search', {
            detail: {
                searchText: event.target.value,
            }
        }));
    }

    handleGroupBy() {
        this.dispatchEvent(new CustomEvent('groupby', {}));
    }
}