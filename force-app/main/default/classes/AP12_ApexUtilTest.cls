/**
 * The ApexUtilTest class is a test class for the ApexUtil class.
 */
@IsTest
public class AP12_ApexUtilTest {

    /**
     * Test method for the castValueForField method.
     */
    @IsTest
    public static void testCastValueForField() {
        // Test data setup
        Account testAccount = new Account(Name = 'Test Account');
        Opportunity testOpportunity = new Opportunity(Name = 'Test Opportunity');
        Event testEvent = new Event();
        
        // Test case 1: Cast String value
        AP12_ApexUtil.castValueForField(testAccount, 'String', 'Name', 'New Account Name');
        System.assertEquals('New Account Name', testAccount.Name);
        
        // Test case 2: Cast Integer value
        AP12_ApexUtil.castValueForField(testAccount, 'Integer', 'NumberOfEmployees', '100');
        System.assertEquals(100, testAccount.NumberOfEmployees);
        
        // Test case 3: Cast Decimal value
        AP12_ApexUtil.castValueForField(testAccount, 'Decimal', 'AnnualRevenue', '5000.50');
        System.assertEquals(5000.50, testAccount.AnnualRevenue);
        
        // Test case 4: Cast Double value
        AP12_ApexUtil.castValueForField(testAccount, 'Double', 'AnnualRevenue', '5000.50');
        System.assertEquals(5000.50, testAccount.AnnualRevenue);
        
        // Test case 5: Cast Date value
        String dateValueString = '2022-05-25';
        Date dateValue = Date.valueOf(dateValueString);
        AP12_ApexUtil.castValueForField(testOpportunity, 'Date', 'CloseDate', dateValueString);
        System.assertEquals(dateValue, testOpportunity.CloseDate);

        // Test case 6: Cast DateTime value
        String dateTimeValueString = '2100-05-01 12:00:00Z';
        DateTime dateTimeValue = DateTime.valueOf(dateTimeValueString);
        AP12_ApexUtil.castValueForField(testEvent, 'DateTime', 'StartDateTime', dateTimeValueString);
        System.assertEquals(dateTimeValue, testEvent.StartDateTime);
        
        // Test case 7: Unsupported field type
        try {
            AP12_ApexUtil.castValueForField(testOpportunity, 'InvalidType', 'InvalidField', 'Value');
            System.assert(false, 'Expected exception was not thrown.');
        } catch (AP12_ApexUtil.ApexUtilException ex) {
            System.assertEquals(Label.AP_ApexUtil_Ex_CastField.replace('{{SfFieldType}}','InvalidType').replace('{{sfFieldAPIName}}','InvalidField'), ex.getMessage());
        }
        
    }

    /**
     * Test method for the getInstanceOfSObjectByAPIName method.
     */
    @IsTest
    public static void testGetInstanceOfSObjectByAPIName() {
        // Test case 1: Valid sObject API name
        sObject testSObject1 = AP12_ApexUtil.getInstanceOfSObjectByAPIName('Account');
        System.assertNotEquals(null, testSObject1);
        System.assertEquals('Account', String.valueOf(testSObject1.getSObjectType()));
        
        // Test case 2: Invalid sObject API name
        try {
            sObject testSObject2 = AP12_ApexUtil.getInstanceOfSObjectByAPIName('Invalid_Object');
            System.assert(false, 'Expected exception was not thrown.');
        } catch (AP12_ApexUtil.ApexUtilException ex) {
            System.assertEquals(Label.AP_ApexUtil_Ex_sObjectNotFound.replace('{{sObjectAPIName}}','Invalid_Object'), ex.getMessage());
        }
        
    }
}