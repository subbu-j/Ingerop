@isTest
public class TestDataFactoryTest {

    @IsTest
    static void testGenerateTestCustomMetadataCastJSONToSObject() {
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' OR Name = 'Administrateur Système' LIMIT 1].Id;
        TestDataFactory.createTestUser(profileId, 'TestFN', 'TestLN');
        TestDataFactory.TEST_returnEmpty = false;
        // Create test custom metadata records
        List<CustomRecordComparaison__mdt> lstCRC = TestDataFactory.generateTestCustomMetadataCastJSONToSObject();

        // Assert the field values
        System.assertEquals('Ext_Name', lstCRC[0].MappedField__c);
        System.assertEquals('String', lstCRC[0].ToBeCastedIn__c);
        System.assertEquals('AnnualRevenue', lstCRC[1].SalesforceFieldAPIName__c);
        System.assertEquals('Account', lstCRC[2].SalesforceObject__c);
    }
    
}