({
    // destruction du composant modal dynamique
	closeModal : function(component, event, helper)  { 
        component.destroy();
	},
    
    // gestion de validation des champs obligatoires

    isFormValid: function (component) {
        return (component.find('required-field') || [])
            .filter(function (i) {
                var fieldname = i.get('v.fieldName');
                var value = i.get('v.value');
                //console.log('# isFormValid : ' + fieldname +'/'+value);
                return !value || value == '' || value.trim().length === 0;
            })
            .map(function (i) {
                return i.get('v.fieldName');
            });
    },

})