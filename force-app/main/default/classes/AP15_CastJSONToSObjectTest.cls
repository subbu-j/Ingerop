@IsTest
private class AP15_CastJSONToSObjectTest {

    @IsTest
    static void testInstantiation() {
        
        //___Passing tests
        TestDataFactory.TEST_returnEmpty = false;
        // Create test data
        String sObjectToCastAPIName = 'Account';
        String jsonInput = '{"Ext_Name": "Test Account", "Ext_AnnualRevenue": "1000", "Ext_ShippingPostalCode": 75000, "Ext_ShippingLongitude": "37.7749"}';

        // Create the instance of the CastJSONToSObject class
        AP15_CastJSONToSObject castJSONToSObject = new AP15_CastJSONToSObject(sObjectToCastAPIName, jsonInput);

        //___Failing tests
        //No mdt
        try{
            TestDataFactory.TEST_returnEmpty = true;
        	castJSONToSObject = new AP15_CastJSONToSObject(sObjectToCastAPIName, jsonInput);
        }catch(AP15_CastJSONToSObject.CastJSONToSObjectException ex){
            System.assertEquals(Label.AP_CastJSONToSObject_Ex_NoMetadata.replace('{{sObjectToCastAPIName}}',sObjectToCastAPIName), ex.getMessage(), 'A CastJSONToSObjectException should have been raised');
        }
        //No json
        try{
            jsonInput = '';
        	castJSONToSObject = new AP15_CastJSONToSObject(sObjectToCastAPIName, jsonInput);
        }catch(AP15_CastJSONToSObject.CastJSONToSObjectException ex){
            System.assertEquals(Label.AP_CastJSONToSObject_Ex_JsonNullOrBlank, ex.getMessage(), 'An CastJSONToSObjectException should have been raised');
        }
    }
    
    @IsTest
    static void testGenerateCast() {
        
        //___Passing tests
        TestDataFactory.TEST_returnEmpty = false;
        // Create test data
        String sObjectToCastAPIName = 'Account';
        String jsonInput = '{"Ext_Name": "Test Account", "Ext_AnnualRevenue": "1000", "Ext_ShippingPostalCode": 75000, "Ext_ShippingLongitude": "37.7749"}';

        // Create the instance of the AP15_CastJSONToSObject class
        AP15_CastJSONToSObject castJSONToSObject = new AP15_CastJSONToSObject(sObjectToCastAPIName, jsonInput);
        
        // Generate the casted sObject
        sObject castedSObject = castJSONToSObject.generateCast();
        
        // Verify the casted sObject fields
        System.assertEquals('Test Account', castedSObject.get('Name'));
        System.assertEquals(1000, castedSObject.get('AnnualRevenue'));
    }
}