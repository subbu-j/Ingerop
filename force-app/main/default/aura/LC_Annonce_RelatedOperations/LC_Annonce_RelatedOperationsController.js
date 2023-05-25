({
    doInit: function(component, event, helper) {
        var actions = [
            { label: 'Délier', name: 'unlink' }
        ];

        component.set('v.columns', [
            {label: "Nom", fieldName: "Link__c", type: "url", typeAttributes: { label: { fieldName: 'Name' } }, sortable: true},
            {label: "Opération", fieldName: "OperationLink", type: "url", typeAttributes: { label: { fieldName: 'OperationName' } }, sortable: true, iconName: 'custom:custom37'},            
            //{label: "ID Explore", fieldName: "ID_Explore__c", type: "text", sortable: true}, 
            {label: "UFO", fieldName: "UfoName", type: "text", sortable: true}, 
            {label: "Proriétaire", fieldName: "OwnerName", type: "text", sortable: true}, 
            {label: "Compte", fieldName: "AccountLink", type: "url", typeAttributes: { label: { fieldName: 'AccountName' } }, sortable: true},
            //{label: "Lien Explore", fieldName: "URL_Explore__c", type: "url", typeAttributes: { label: { fieldName: 'ExploreLinkName' } }, sortable: true},

            { type: 'action', typeAttributes: { rowActions: actions }}
        ]);

        var page = component.get("v.page") || 1;
        helper.getData(component, page);
    },

    navigate: function(component, event, helper) {
        var page = component.get("v.page") || 1;
        var direction = event.getSource().get("v.label");
        page = direction === "Previous Page" ? (page - 1) : (page + 1);

        helper.getData(component, page);
    },

    onSelectChange: function(component, event, helper) {
        var page = 1;
        helper.getData(component, page);
    },

    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'edit':
                var editRecordEvent = $A.get("e.force:editRecord");
                editRecordEvent.fire({
                    "recordId":  row.Id
                });
                break;
            case 'unlink':
                var page = component.get("v.page") || 1;
                helper.unlink(component, page, row.Id, row.ID_Explore__c);
                break;
        }
    },

    createRecord : function (component) {
        var createRecordEvent = $A.get("e.force:createRecord");
        var objectType = component.get("v.objectType");

        createRecordEvent.fire({
            "entityApiName": objectType
        });
    },

    handleApplicationEvent: function (component, event, helper) {
        var page = component.get("v.page") || 1;
        helper.getData(component, page);
    },

    updateColumnSorting: function (component, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        component.set("v.sortedBy", fieldName);
        component.set("v.sortedDirection", sortDirection);
        helper.sortData(component, fieldName, sortDirection);
    }
})