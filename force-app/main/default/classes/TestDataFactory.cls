/*
----------------------------------------------------------------------
-- - Name          : TestDataFactory
-- - Author        : Boris THOMAS - Bluetis
-- - Description   : Methods for test classes
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 10-NOV-2016   BTH    1.0      Initial version
----------------------------------------------------------------------
*/
public without sharing class TestDataFactory {
    
    public static Boolean TEST_returnEmpty;
    
	public static User createTestUser(Id profID, String fName, String lName) {
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User tuser = new User(  Firstname = fName,
                                LastName = lName,
                                Email = uniqueName + '@testxx' + orgId + '.org',
                                Username = uniqueName + '@testxx' + orgId + '.org',
                                EmailEncodingKey = 'ISO-8859-1',
                                Alias = uniqueName.substring(18, 23),
                                TimeZoneSidKey = 'Europe/Paris',
                                LocaleSidKey = 'fr_FR_EURO',
                                LanguageLocaleKey = 'fr',
                                ProfileId = profId);
        return tuser;
    }   
    
    public static List<CustomRecordComparaison__mdt> generateTestCustomMetadataCastJSONToSObject(){
        
        
        List<CustomRecordComparaison__mdt> lstCRC = new List<CustomRecordComparaison__mdt>();
        if(!TEST_returnEmpty){
            lstCRC.add(new CustomRecordComparaison__mdt(
                        MappedField__c = 'Ext_Name',
                        SalesforceFieldAPIName__c = 'Name',
                        SalesforceObject__c = 'Account',
                        ToBeCastedIn__c = 'String')
                      );
            lstCRC.add(new CustomRecordComparaison__mdt(
                        MappedField__c = 'Ext_AnnualRevenue',
                        SalesforceFieldAPIName__c = 'AnnualRevenue',
                        SalesforceObject__c = 'Account',
                        ToBeCastedIn__c = 'Integer')
                      );
            lstCRC.add(new CustomRecordComparaison__mdt(
                        MappedField__c = 'Ext_ShippingPostalCode',
                        SalesforceFieldAPIName__c = 'ShippingPostalCode',
                        SalesforceObject__c = 'Account',
                        ToBeCastedIn__c = 'String')
                      );
            lstCRC.add(new CustomRecordComparaison__mdt(
                        MappedField__c = 'Ext_ShippingLongitude',
                        SalesforceFieldAPIName__c = 'ShippingLongitude',
                        SalesforceObject__c = 'Account',
                        ToBeCastedIn__c = 'Decimal')
                      );
        }
        
        return lstCRC;
    }
}