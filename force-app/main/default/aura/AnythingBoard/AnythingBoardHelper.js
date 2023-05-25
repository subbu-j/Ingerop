({
	buildSoql : function(component) {
		var field = component.get("v.pathField");
		var objectType = component.get("v.sObjectName");

		var displayFields = component.get("v.displayFields");
		var exclude1 = component.get("v.excludePicklistValuesFromTiles");
		var exclude2 = component.get("v.excludePicklistValuesFromBoard");

		//safe to remove all space because it's field API names
		var displayFieldsArray = displayFields.replace(/\s/g, '').split(",")
		var queryFields = _.join(_.union(displayFieldsArray, [field], ["Id"]), ", ");


		var soql = "select " + queryFields + " from " + objectType; 

		//checking for any exclusion		
		if ((exclude1 != null && exclude1 != '') || (exclude2 != null && exclude2 != '')){
			var excludeString1, excludeString2 = [];
			if (exclude1 != null && exclude1 != ''){
				excludeString1 = this.CSL2Array(exclude1);
			} 
			if (exclude2 != null && exclude2 != ''){
				excludeString2 = this.CSL2Array(exclude2);
			}
			
			//non-redundant array of all the fields to exclude
			var excludeString = _.union(excludeString1, excludeString2);

			excludeString = "'" + excludeString.join("', '") + "'";
			console.log(excludeString);

			soql = soql + " where " + field + " NOT IN (" + excludeString + ")"
		}
		
		console.log(soql);

		component.set("v.soql", soql);
			
	},

	buildEmptyTree: function(component, rawOptions) {
			console.log("building tree");
			console.log(rawOptions);

			//exclusion process

			var excludeString = component.get("v.excludePicklistValuesFromBoard");
			console.log(excludeString);

			if (excludeString != null && excludeString != ''){
				excludeString = this.CSL2Array(excludeString);
				console.log(excludeString);

				_.forEach(excludeString, function(value, key){
					delete rawOptions[value];
				})
				console.log(rawOptions);
			}


            var output = [];
            for (var key in rawOptions) { //(value, label)
            	if (rawOptions.hasOwnProperty(key)){
            		output.push({
            			"name" : rawOptions[key], 
            			"value" : key,
            			"records" : []
            		});
            	}
            }

            component.set("v.options", output);

	},

	buildDisplayFieldsArray: function (component){
		console.log("buildind DFA");
		component.set("v.displayFieldsArray", this.CSL2Array(component.get("v.displayFields")));
	},

	//shared by lots of functions.  You give it a comma-separated list of stuff, it returns a trimmed array
	CSL2Array: function (CSL){

		var outputArray = CSL.split(",");
		_.forEach(outputArray, function (value, key){
			outputArray[key] = _.trim(value);
		});
		return outputArray;
	}
})