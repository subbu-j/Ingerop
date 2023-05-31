/**
 * @description       : This class provides functionality for comparing records in Salesforce.
 * @author            : emmanuel.javay@springfive.com
 * @group             : 
 * @last modified on  : 2023-05-25
 * @last modified by  : emmanuel.javay@springfive.com
**/

public class AP14_CustomRecordComparaisonController {
    
    /**
     * Initializes the comparison process for a primary record that will be compared to another one fetched.
     * @param primaryRecordId The ID of the primary record.
     * @return AP13_CustomRecordComparaisonWrapper The wrapper object containing the comparison data.
	*/
    @AuraEnabled
    public static AP13_CustomRecordComparaisonWrapper init(Id primaryRecordId){
    	List<Account> lstAccToCompare = new List<Account>();
        
        // Identify the sObject API Name to compare with
        String sObjectAPIName = primaryRecordId.getSObjectType().getDescribe().getName();
        //Get fields to display from Custom labels
        List<String> lstFieldsToDisplay = getFieldsToDisplay(sObjectAPIName);

        // Retrieve the primary record
        List<Account> lstAccount = Database.query('SELECT ' + String.join(lstFieldsToDisplay,',') + ' FROM '+ sObjectAPIName +' WHERE Id = \'' + primaryRecordId + '\'');
        checkPrimaryAccount(lstAccount);
        lstAccToCompare.add(lstAccount[0]);
        // Retrieve the json from Explore
        String jsonExplore = Test.isRunningTest() ? TestDataFactory.JSON_RESULT_CRCC : WS_Explore.getSiretData(lstAccount[0].SIRET__c);
        // Cast Json dynamically
        AP15_CastJSONToSObject cjtso = new AP15_CastJSONToSObject(sObjectAPIName, jsonExplore);
        lstAccToCompare.add((Account) cjtso.generateCast());

    	//Build wrapper
    	AP13_CustomRecordComparaisonWrapper crcw = new AP13_CustomRecordComparaisonWrapper(lstAccToCompare[0], lstAccToCompare[1], lstFieldsToDisplay);
        crcw.buildWrapper();
        return crcw;
	}
    
    /**
     * Saves the updated comparison data.
     * @param crcwJsonWrapper The JSON representation of the comparison wrapper object that contains fields values to be saved.
	*/
    @AuraEnabled
    public static void save(String crcwJsonWrapper){
        Boolean recordIsSaved = true;
        // Deserialize json and update primary Account with selected values
        AP13_CustomRecordComparaisonWrapper crcw = (AP13_CustomRecordComparaisonWrapper) JSON.deserialize(crcwJsonWrapper, AP13_CustomRecordComparaisonWrapper.class);
        Account accToBeUpdated = (Account) crcw.getUpdatedPrimarySObject();
        // Save record
        update accToBeUpdated;
    }
    
    /**
     * Checks if the primary account meets the required conditions.
     * @param lstAccount The list of accounts representing the primary record.
     * @throws CustomRecordComparaisonControllerException if the primary account retrieval fails or SIRET field is blank.
	*/
    @testVisible
    private static void checkPrimaryAccount(List<Account> lstAccount){
        if(lstAccount.size() != 1)
            Throw new CustomRecordComparaisonControllerException(Label.AP_CustRecCompCtrl_Ex_PrimaryAccountNotFound);
        if(String.isBlank(lstAccount[0].SIRET__c))
            Throw new CustomRecordComparaisonControllerException(Label.AP_CustRecCompCtrl_Ex_EmptySIRET);
    }
    
    /**
     * Retrieves the fields to display for a given Salesforce object API name.
     * @param sObjectAPIName The API name of the Salesforce object.
     * @return List<String> The list of fields to display.
     * @throws CustomRecordComparaisonControllerException if no custom metadata records are assigned for the Salesforce object.
	*/
    @testVisible
    private static List<String> getFieldsToDisplay(String sObjectAPIName){
        List<String> lstFieldsToDisplay = new List<String>();
        List<CustomRecordComparaison__mdt> lstCustomRecordComparaisonMdt =  Test.isRunningTest() ? 
            							TestDataFactory.generateTestCustomMetadataCastJSONToSObject() : [SELECT MappedField__c, SalesforceFieldAPIName__c , SalesforceObject__c, ToBeCastedIn__c  FROM CustomRecordComparaison__mdt WHERE SalesforceObject__c = :sObjectAPIName ORDER BY SalesforceFieldAPIName__c asc];
        if(lstCustomRecordComparaisonMdt == null || lstCustomRecordComparaisonMdt.size() == 0){
            String exMessage = Label.AP_CastJSONToSObject_Ex_NoMetadata.replace('{{sObjectToCastAPIName}}',sObjectAPIName);
            Throw new CustomRecordComparaisonControllerException(exMessage);
        }
        for(CustomRecordComparaison__mdt crcMdt:lstCustomRecordComparaisonMdt){
            lstFieldsToDisplay.add(crcMdt.SalesforceFieldAPIName__c);
        }
        
        return lstFieldsToDisplay;
        
    }
    
    public class CustomRecordComparaisonControllerException extends Exception{}
    
}