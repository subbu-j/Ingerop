//TO DO:
//	- Comments
//	- Classes de test
//	- Custom Labels
//	- Front
//	TO DO:
//		- Test if SIRET null
public class AP14_CustomRecordComparaisonController {
    
    private static final String RECORD_TWO= '001MT000002n04WYAQ';
    private static final Boolean BOUCHON = true;
    private static String sObjectAPIName;
    
    @AuraEnabled
    public static AP13_CustomRecordComparaisonWrapper init(Id primaryRecordId){
    	//Call to Explore API and retrieve json
    	List<Account> lstAccToCompare;
        List<String> lstFieldsToDisplay;
        if(BOUCHON){
            List<Id> lstIdAccountToCompare = new List<Id>{primaryRecordId, RECORD_TWO};
            lstAccToCompare = [SELECT AnnualRevenue, Description, Industry, Name, Phone, ShippingCity, ShippingCountry, ShippingLatitude, ShippingLongitude, ShippingPostalCode, ShippingStreet, Website FROM Account WHERE Id IN :lstIdAccountToCompare];
        }
        else{
            // Identify the sObject API Name to compare with
            String sObjectAPIName = primaryRecordId.getSObjectType().getDescribe().getName();
            //Get fields to display from Custom labels
    		lstFieldsToDisplay = getFieldsToDisplay(sObjectAPIName);
            // Retrieve the primary record
            List<Account> lstAccount = Database.query('SELECT ' + String.join(lstFieldsToDisplay,',') + ' FROM '+ sObjectAPIName +' WHERE Id = ' + primaryRecordId);
            checkPrimaryAccount(lstAccount);
            // Retrieve the json from Explore
            String jsonExplore = WS_Explore.getSiretData(lstAccount[0].SIRET__c);
            // Cast Json dynamically
            AP15_CastJSONToSObject cjtso = new AP15_CastJSONToSObject(sObjectAPIName, jsonExplore);
            Account castedExploreAccount = (Account) cjtso.generateCast();
        }
    	//Build wrapper
    	AP13_CustomRecordComparaisonWrapper crcw = new AP13_CustomRecordComparaisonWrapper(lstAccToCompare[0], lstAccToCompare[1], lstFieldsToDisplay);//To be changed
        crcw.buildWrapper();
        System.debug(crcw.lstCustomRecordComparaisonRow);
        return crcw;
	}
    
    @AuraEnabled
    public static void save(String crcwJsonWrapper){
        System.debug('crcwJsonWrapper : '+crcwJsonWrapper);
        Boolean recordIsSaved = true;
        // Deserialize json and update primary Account with selected values
        AP13_CustomRecordComparaisonWrapper crcw = (AP13_CustomRecordComparaisonWrapper) JSON.deserialize(crcwJsonWrapper, AP13_CustomRecordComparaisonWrapper.class);
        Account accToBeUpdated = (Account) crcw.getUpdatedPrimarySObject();
        System.debug(accToBeUpdated);
        // Save record
        update accToBeUpdated;
    }
    
    private static void checkPrimaryAccount(List<Account> lstAccount){
        if(lstAccount.size() != 1)
            Throw new CustomRecordComparaisonControllerException('Error when retrieving the primary Account');//Use custom label
        if(String.isBlank(lstAccount[0].SIRET__c))
            Throw new CustomRecordComparaisonControllerException('SIRET must be filled');//Use custom label
    }
    
    private static List<String> getFieldsToDisplay(String sObjectAPIName){
        List<String> lstFieldsToDisplay = new List<String>();
        List<CustomRecordComparaison__mdt> lstCustomRecordComparaisonMdt = [SELECT MappedField__c, SalesforceFieldAPIName__c , SalesforceObject__c, ToBeCastedIn__c 
                                         FROM CustomRecordComparaison__mdt
                                        WHERE SalesforceObject__c = :sObjectAPIName];
        if(lstCustomRecordComparaisonMdt == null || lstCustomRecordComparaisonMdt.size() == 0)
            Throw new CustomRecordComparaisonControllerException('No Custom Metadata records assigned for the Salesforce object '+sObjectAPIName);// Use Custom Label
        for(CustomRecordComparaison__mdt crcMdt:lstCustomRecordComparaisonMdt){
            lstFieldsToDisplay.add(crcMdt.SalesforceFieldAPIName__c);
        }
        
        return lstFieldsToDisplay;
        
    }
    
    private class CustomRecordComparaisonControllerException extends Exception{}
    
}