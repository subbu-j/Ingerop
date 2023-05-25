/**
 * @description       : The AP15_CastJSONToSObject class is used to cast a JSON input to a Salesforce sObject.
						It allows mapping JSON fields to Salesforce fields based on custom metadata records.
 * @author            : emmanuel.javay@springfive.com
 * @group             : 
 * @last modified on  : 2023-05-25
 * @last modified by  : emmanuel.javay@springfive.com
**/
public class AP15_CastJSONToSObject {

    private String sObjectToCastAPIName;
    private String jsonInput;
    private SObject sObjectInstance;
    private List<CustomRecordComparaison__mdt> lstCustomRecordComparaisonMdt;
    private static final String PATH_DELIMITER = Label.AP_CastJSONToSObject_Delimiter;
    
    /**
     * Constructs a AP15_CastJSONToSObject instance with the sObject API name and JSON input.
     * @param sObjectToCastAPIName The API name of the sObject to cast the JSON input into.
     * @param jsonInput The JSON input string to be casted.
	*/
    public AP15_CastJSONToSObject(String sObjectToCastAPIName, String jsonInput){
        this.sObjectToCastAPIName = sObjectToCastAPIName;
        this.jsonInput = jsonInput;
        assertAndInit();
    }
    
    /**
     * Asserts and initializes the AP15_CastJSONToSObject instance.
     * It checks the JSON input string, instantiates the sObject, and retrieves the custom metadata records.
     * @throws CastJSONToSObjectException If the JSON input is null or blank or if no custom metadata records are assigned for the given sObject.
	*/
    private void assertAndInit(){
        // Check Json String
        if(String.isBlank(jsonInput))
            Throw new CastJSONToSObjectException(Label.AP_CastJSONToSObject_Ex_JsonNullOrBlank);
        
		// Instanciate sObject        
        sObjectInstance = AP12_Apexutil.getInstanceOfSObjectByAPIName(sObjectToCastAPIName);
        
        //Retrieve and check custom metadata
        lstCustomRecordComparaisonMdt =  Test.isRunningTest() ? 
            							TestDataFactory.generateTestCustomMetadataCastJSONToSObject() : [SELECT MappedField__c, SalesforceFieldAPIName__c , SalesforceObject__c, ToBeCastedIn__c  FROM CustomRecordComparaison__mdt WHERE SalesforceObject__c = :sObjectToCastAPIName];
        if(lstCustomRecordComparaisonMdt == null || lstCustomRecordComparaisonMdt.size() == 0){
            String exMessage = Label.AP_CastJSONToSObject_Ex_NoMetadata.replace('{{sObjectToCastAPIName}}',sObjectToCastAPIName);
            Throw new CastJSONToSObjectException(exMessage);
        }
    }
    
    /**
     * Generates the casted sObject based on the JSON input and custom metadata mappings.
     * @return The casted sObject.
	*/
    public sObject generateCast(){
        //Unserialize json
        Map<String, Object> deserializedJson = (Map<String, Object>) JSON.deserializeUntyped(jsonInput);
        Object dJSONFieldValue;
        for(CustomRecordComparaison__mdt crc: lstCustomRecordComparaisonMdt){
            dJSONFieldValue = getNestedValue(deserializedJson, crc.MappedField__c);
            if(dJSONFieldValue != null){
                AP12_ApexUtil.castValueForField(sObjectInstance, crc.ToBeCastedIn__c, crc.SalesforceFieldAPIName__c, dJSONFieldValue);
            }
        }
        return sObjectInstance;
    }
    
    /**
     * Retrieves a nested value from a hierarchical map based on the provided path.
     * @param nest The hierarchical map containing nested values.
     * @param path The path to the desired value, specifying the keys to traverse the nested structure.
     * @return The nested value corresponding to the given path, or null if the value is not found.
     * @throws NullPointerException if the nest parameter is null.
     * @throws IllegalArgumentException if the path parameter is null or empty.
	*/
    private Object getNestedValue(Map<String, Object> nest, String path){
        List<String> currNestSplited = path.split(PATH_DELIMITER);
        if(currNestSplited.size() > 1){
            String nextNestPath = path.substringAfter(PATH_DELIMITER);
            return getNestedValue((Map<String, Object>)nest.get(path.substringBefore(PATH_DELIMITER)),nextNestPath);
        }
        else if(currNestSplited.size() == 1)
        	return nest.get(path);
        return null;
    }
    
    public class CastJSONToSObjectException extends Exception{}
}