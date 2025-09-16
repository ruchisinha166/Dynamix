import { LightningElement, api } from 'lwc';

export default class DatatableRows extends LightningElement {

    currentRows;

    @api
    get rows() {
        return this.currentRows;
    }
    set rows(value) {
        this.currentRows = JSON.parse(JSON.stringify(value));
    }

    @api columns;

    @api
    sort(sortedBy, sortDirection) {

        const sortedData = [...this.currentRows];
        sortedData.sort(this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1));

        this.currentRows = sortedData;
    }

    sortBy(field, reverse, primer) {
        const key = primer
            ? function (x) {
                return primer(x[field]);
            }
            : function (x) {
                return x[field];
            };

        return function (a, b) {
            a = key(a);
            b = key(b);
            return reverse * ((a > b) - (b > a));
        };
    }

    get groupedRows() {

        let tempRows = JSON.parse(JSON.stringify(this.currentRows));
        let output = [];

        tempRows.forEach((row, index) => {
            output[index] = [{
                label: 'id',
                fieldValue: row.id,
                rowspan: 1
            }];
        });

        for (let i = 1; i < this.columns.length; i++) {

            tempRows = this.handleRowGrouping(tempRows, this.columns[i]);

            tempRows.forEach((row, index) => {
                if (row.rowspan) {
                    output[index].push({
                        label: this.columns[i].fieldName,
                        fieldValue: row[this.columns[i].fieldName],
                        rowspan: row.rowspan
                    });
                }
            });
        }

        return output;
    }

    handleRowGrouping(rows, currentColumn) {

        let data = [];
        let columngroups = new Map();

        rows.forEach((row) => {

            let currentColumnValue = row[currentColumn.fieldName];

            if (currentColumn.grouped) {

                if (!row.groupIdentity) {
                    row.groupIdentity = currentColumnValue;
                }
                else {
                    row.groupIdentity += currentColumnValue;
                }

                if (columngroups.has(row.groupIdentity)) {
                    let rowgroup = columngroups.get(row.groupIdentity);
                    rowgroup.push(row);
                    columngroups.set(row.groupIdentity, rowgroup);
                }
                else {
                    let rowgroup = [row];
                    columngroups.set(row.groupIdentity, rowgroup);
                }
            }
            else {

                row.rowspan = 1;

                data.push(row);
            }
        });

        if (currentColumn.grouped) {
            columngroups.forEach((rows, key) => {
                this.currentGroupValue = key;

                rows.forEach((row, index) => {
                    if (index === 0) {
                        row.rowspan = rows.length;
                    }
                    data.push(row);
                });

            });
        }

        return data;
    }
}