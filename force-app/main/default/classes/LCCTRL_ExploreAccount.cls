/**
 * @description       : This is a controller class for LC_ExploreAccount Lightning component that provides functionalities for getting Account data.
 * @author            : subramanyam.jagadeesan@springfive.com
 * @group             : 
 * @last modified on  : 2023-05-30
 * @last modified by  : subramanyam.jagadeesan@springfive.com
**/

public with sharing class LCCTRL_ExploreAccount {
    
    /**
     * Searches for Account record that matches the input text provided by the user.
     * @param searchText Text to be searched in Name and Alias fields of Account.
     * @return List<Account> The list of Account records fetched.
	*/
    @AuraEnabled
    public static List<Account> getAccountsDataSearch (String searchText) {
        
        List<Account> returnList = new List<Account>();
        searchText = (searchText != null && searchText != '') ? '%' + searchText + '%' : ''; 
        List<Account> searchList = [SELECT Id, Name, Alias__c, ParentId, Parent.Name, SIRET__c, ShippingCity, RecordType.Name FROM Account WHERE Name LIKE :searchText OR Alias__c LIKE :searchText];
        
        for(Account acc : searchList){
            returnList.add(acc);
        }
        return returnList;
    }

    /**
     * Get Account Id if the SIRET corresponds to only one Account record.
     * @param siret Used to find the Account.
     * @return String AccountId of the corresponding Siret.
	*/
    @AuraEnabled
    public static String getAccountIdBySiret (String siret){
        List<Account> lstAccount = [SELECT Id, Name FROM Account WHERE SIRET__c =:siret];
        if(!lstAccount.IsEmpty()){
            if(lstAccount.size() == 1){
                return lstAccount[0].Id;
            }
        }
        return null;
    }
    
    /**
     * Fetch all the record type Names of Account Object.
     * @return List<String> List of Account record type names.
	*/
    @AuraEnabled        
    public static List<String> fetchRecordTypeValues(){

        List<Schema.RecordTypeInfo> recordTypes = Account.SObjectType.getDescribe().getRecordTypeInfos();    
        Map<Id, String> recordTypeMap = new Map<Id, String>();
        for(RecordTypeInfo rt : recordTypes){
            if(rt.getName() != 'Master'){
                recordTypeMap.put(rt.getRecordTypeId(), rt.getName());
            }
        }        
        return recordTypeMap.values();
    }
    

    /**
     * Retrieves the Account data from Explore API to prepopulate the data while creating a new account.
     * @param siret Used to fetch the Account.
     * @param recordTypeLabel To get its corresponding record Type Id.
     * @return ExploreAccountWrapper The wrapper object containing the Account data retrieved from Explore.
     * @throws AuraHandledException if any error occurred while getting/parsing the data from Explore.
	*/
    @AuraEnabled
    public static ExploreAccountWrapper createAccount(String siret, String recordTypeLabel){
        if (String.isBlank(siret)){
            throw new AuraHandledException(Label.AP_CustRecCompCtrl_Ex_EmptySIRET);
        }
        try{
            Id recid = Schema.SObjectType.Account.getRecordTypeInfosByName().get(recordTypeLabel).getRecordTypeId();        

            String jsonExplore = Test.isRunningTest() ? TestDataFactory.JSON_RESULT_EXPLORE : WS_Explore.getSiretData(siret);
            Explore_Siret data = Explore_Siret.parse(jsonExplore);
            ExploreAccountWrapper acc = new ExploreAccountWrapper();

            if (data != null){
                acc.Name = data.NOTICE80.L1_NOMEN;
                acc.Siret = data.NOTICE80.SIRET;
                acc.Description = data.NOTICE80.LIBNJ;
                acc.ShippingStreet = data.NOTICE80.L4_VOIE;
                acc.ShippingPostalCode = data.NOTICE80.CODPOS;
                acc.ShippingCity = data.NOTICE80.LIBCOM;
                acc.ShippingCountry = data.NOTICE80.L7_ETRG;
                acc.ShippingLatitude = data.COMPLEMENTS.LATITUDE;
                acc.ShippingLongitude = data.COMPLEMENTS.LONGITUDE;
                acc.Phone = data.COMPLEMENTS.TELEPHONE;
                acc.Website = data.COMPLEMENTS.SITE_WEB;
                acc.RecordTypeId = recid;
            }
            return acc;
        } 
        catch (Exception e){
            throw new AuraHandledException(Label.LCCTRL_ExploreAcc_Ex_CalloutError);
        }
    }
            
    public class ExploreAccountWrapper{
        @AuraEnabled public String Name;
        @AuraEnabled public String Siret;
        @AuraEnabled public String Description;
        @AuraEnabled public String ShippingStreet;
        @AuraEnabled public String ShippingPostalCode;
        @AuraEnabled public String ShippingCity;
        @AuraEnabled public String ShippingCountry;
        @AuraEnabled public Double ShippingLongitude;
        @AuraEnabled public Double ShippingLatitude;
        @AuraEnabled public String Phone;
        @AuraEnabled public String Website;
        @AuraEnabled public String RecordTypeId;
    }


}