import { api, LightningElement, track, wire } from 'lwc';
import getInventory from '@salesforce/apex/BikeParkingGraphicalViewController.getInventory';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent } from 'lightning/flowSupport';

export default class bikeParkingGraphicalView extends LightningElement {

@api recordId;
@api oppId;
@api isTransfer = false;
@api selectedProperty;

@track propertyGraph;
@track filteredPropertyGraph;
@track showPropertyInfo = false;
@track toggleFilter = false;
@track property;
@track propertyFilters = [];

@wire(getInventory, { projectId: '$recordId'})
propertyGraph(response) {
    if (response.data) {
        this.propertyGraph = response.data;
        this.filteredPropertyGraph = JSON.parse(JSON.stringify(response.data));
    }

    if (response.error) {
        console.error(response.error);
    }
}

handlePropertySelect(event) {
    this.property = event.detail;
    this.showPropertyInfo = true;
    this.toggleFilter = false;
}

handleCloseInfo() {
    this.showPropertyInfo = false;
}

handleRemoveFilter(event) {
    this.propertyFilters.splice(event.detail.index, 1);
    this.propertyFilters = [...this.propertyFilters];
    this.filterData();
}

filterData() {
    this.filteredPropertyGraph = JSON.parse(JSON.stringify(this.propertyGraph));

    this.propertyFilters.forEach(propFilter => {
        console.log('propFilter.name'+propFilter.name);
        if (propFilter.name === 'tower') {
            this.filteredPropertyGraph.towers = this.filteredPropertyGraph.towers.filter(
                towerFilter => propFilter.filterValues.includes(towerFilter.name)
            );
        }
        else if (propFilter.name === 'floor') {
            console.log('floor');
            this.filteredPropertyGraph.towers.forEach(tower => {
                tower.floors.forEach(floor => {
                    let filteredProperties = floor.properties.filter(
                        filteredproperty => !propFilter.filterValues.includes(filteredproperty.floor)
                    );

                    filteredProperties.forEach(filteredproperty => {
                        filteredproperty.filtered = true;
                    });
                });
            });
        }
        else if (propFilter.name === 'ParkingType') {
        console.log('Snag');
        this.filteredPropertyGraph.towers.forEach(tower => {
            tower.floors.forEach(floor => {
                let filteredProperties = floor.properties.filter(
                    filteredproperty => !propFilter.filterValues.includes(filteredproperty.ParkingType)
                    
                );

                    filteredProperties.forEach(filteredproperty => {
                        filteredproperty.filtered = true;
                        
                    });

                        let filteredPropertiesSnag = floor.properties.filter(
                    filteredproperty => propFilter.filterValues.includes(filteredproperty.ParkingType)
                    
                    
                );
console.log('filteredproperty'+this.filteredproperty);
                    filteredPropertiesSnag.forEach(filteredproperty => {
                        
                            filteredproperty.snagcolorstatus = true;
                    });
                    
                });
            });
        }
        else if (propFilter.name === 'pLC') {
            this.filteredPropertyGraph.towers.forEach(tower => {
                tower.floors.forEach(floor => {
                    let filteredProperties = floor.properties.filter(filteredproperty => {

                        let commonPLC = propFilter.filterValues.filter(pFilter => filteredproperty.preferredLocation.split(',').includes(pFilter));

                        return !(commonPLC.length > 0);
                    });

                    filteredProperties.forEach(filteredproperty => {
                        filteredproperty.filtered = true;
                       });
                });
            });
        }
    });
}

handleTransfer(event) {
    console.log(event.detail.propertyId);
    const attributeChangeEvent = new FlowAttributeChangeEvent('selectedProperty', event.detail.propertyId);
    this.dispatchEvent(attributeChangeEvent);

    const navigateNextEvent = new FlowNavigationNextEvent();
    this.dispatchEvent(navigateNextEvent);
}

handleFilter(event) {
    this.propertyFilters = event.detail.filters;
    console.log('event.detail.filters'+event.detail.filters);
    this.filterData();
}

handleFilterToggle(event) {
    this.toggleFilter = !this.toggleFilter;

    if (this.toggleFilter) {
        this.showPropertyInfo = false;
    }
}
}