@isTest
public class AP14_CustomRecordComparaisonCtrlTest {

    @isTest
    static void testInit() {
        TestDataFactory.TEST_returnEmpty = false;
        // Create test data
        Account testAccount = new Account(Name = 'Test Account', SIRET__c = '123456789');
        insert testAccount;
        
        // Call the init method
        Test.startTest();
        AP13_CustomRecordComparaisonWrapper result = AP14_CustomRecordComparaisonController.init(testAccount.Id);
        Test.stopTest();
        
        // Perform assertions
        Assert.areNotEqual(0, result.lstCustomRecordComparaisonRow.size(), 'At least one field comparison row should have been created');
        System.assertEquals(testAccount.Id, result.primarySObjectId, 'Incorrect primary account in the wrapper');
    }
    
    @isTest
    static void testSave() {
        TestDataFactory.TEST_returnEmpty = false;
        // Create test data
        Account testAccount = new Account(Name = 'Test Account', SIRET__c = '123456789', AnnualRevenue = 1234, ShippingPostalCode = '92000', ShippingLongitude = 3.141592, ShippingLatitude = 3.141592);
        insert testAccount;
        
        // Call the init method
        Test.startTest();
        AP13_CustomRecordComparaisonWrapper result = AP14_CustomRecordComparaisonController.init(testAccount.Id);

        for(AP13_CustomRecordComparaisonWrapper.CustomRecordComparaisonRow currCRCR:result.lstCustomRecordComparaisonRow){
            currCRCR.selectedValue = currCRCR.fieldType == 'String' ? '987654321' : currCRCR.fieldType == 'Decimal' ? String.valueOf(3.141592) : String.valueOf(3);
        }
        String jsonWrapper = JSON.serialize(result);
        System.debug(JSON.serialize(result));
        // Call the save method
        AP14_CustomRecordComparaisonController.save(jsonWrapper);
        Test.stopTest();
        testAccount.SIRET__c = '123456789';
        // Perform assertions
        Account updatedAccount = [SELECT Id, Name, SIRET__c FROM Account WHERE Id = :testAccount.Id];
        System.assertNotEquals(testAccount.SIRET__c, updatedAccount.SIRET__c, 'Account name was not updated');
    }
    
    @isTest
    static void testCheckPrimaryAccount() {
        // Create test data
        Account testAccount = new Account(Name = 'Test Account', SIRET__c = '');
        List<Account> lstAccount = new List<Account>();
        
        try {
            AP14_CustomRecordComparaisonController.checkPrimaryAccount(lstAccount);
        } catch (AP14_CustomRecordComparaisonController.CustomRecordComparaisonControllerException ex) {
            Assert.areEqual(Label.AP_CustRecCompCtrl_Ex_PrimaryAccountNotFound, ex.getMessage(), 'A CustomRecordComparaisonControllerException should have been raised');
        }
        lstAccount.add(testAccount);
        try {
            AP14_CustomRecordComparaisonController.checkPrimaryAccount(lstAccount);
        } catch (AP14_CustomRecordComparaisonController.CustomRecordComparaisonControllerException ex) {
            Assert.areEqual(Label.AP_CustRecCompCtrl_Ex_EmptySIRET, ex.getMessage(), 'A CustomRecordComparaisonControllerException should have been raised');
        }
    }
    
    @isTest
    static void testGetFieldsToDisplay(){
        TestDataFactory.TEST_returnEmpty = false;
        String sObjectAPIName = 'Account';
        List<String> lstFieldsToDisplay = AP14_CustomRecordComparaisonController.getFieldsToDisplay(sObjectAPIName);
        Assert.isTrue(lstFieldsToDisplay.contains('AnnualRevenue'), 'List of lstFieldsToDisplay should have AnnualRevenue value');
        //No mdt
        try{
            TestDataFactory.TEST_returnEmpty = true;
        	AP14_CustomRecordComparaisonController.getFieldsToDisplay(sObjectAPIName);
        }catch(AP14_CustomRecordComparaisonController.CustomRecordComparaisonControllerException ex){
            Assert.areEqual(Label.AP_CastJSONToSObject_Ex_NoMetadata.replace('{{sObjectToCastAPIName}}',sObjectAPIName), ex.getMessage(), 'A CustomRecordComparaisonControllerException should have been raised');
        }
    }
}