@IsTest
public class AP13_CustomRecordComparaisonWrapperTest {

    @isTest
    static void testBuildWrapper(){
        List<String> lstFieldToCompare = new List<String>{'Name', 'AnnualRevenue', 'Website'};
        Account primarySObject = new Account(Name = 'Test Acc 3', AnnualRevenue = 100, Website = 'testacc1@test.com');
        Account secondarySObject = new Account(Name = 'Test Acc 4', AnnualRevenue = 200, Website = 'testacc2@test.com');
        Opportunity exceptionSObject = new Opportunity(Name = 'Opp1', StageName = 'Qualification', closeDate = date.today().addDays(5));
        
        insert exceptionSObject;
        insert new List<Account>{primarySObject, secondarySObject};
        
            
        //Passing tests
        AP13_CustomRecordComparaisonWrapper crcw = new AP13_CustomRecordComparaisonWrapper(primarySObject, secondarySObject, lstFieldToCompare);
        crcw.buildWrapper();
        
        System.assertEquals('Account', crcw.sObjectAPIName, 'sObjectAPIName should be set to "Account"');
        System.assertEquals(3, crcw.lstCustomRecordComparaisonRow.size(), 'lstCustomRecordComparaisonRow should have 3 rows');
        
        Boolean rowFound = false;
        AP13_CustomRecordComparaisonWrapper.CustomRecordComparaisonRow crcrToTest;
        for(AP13_CustomRecordComparaisonWrapper.CustomRecordComparaisonRow currCrcr:crcw.lstCustomRecordComparaisonRow){
            if(currCrcr.fieldAPIName == 'Name'){
                rowFound = true;
                crcrToTest = currCrcr;
            }
        }
        
        System.assertEquals(true, rowFound, 'Row Name for Account should be String');
        System.assertEquals('STRING', crcrToTest.fieldType, 'Row Name for Account should be String');
        System.assertEquals('Account Name', crcrToTest.fieldLabel, 'Row Name for Account should have been Account Name');
        System.assertEquals('Test Acc 4', crcrToTest.columns[0].value, 'Columns One for Row Name for Account 1 should have been "Test Acc 1"');
        
        // Failing tests
        crcw = new AP13_CustomRecordComparaisonWrapper(primarySObject, exceptionSObject, lstFieldToCompare);
        try{
            crcw.buildWrapper();
        }catch(AP13_CustomRecordComparaisonWrapper.CustomRecordComparaisonWrapperException ex){
			System.assertEquals(Label.AP_CustRecCompWrapper_Ex_sObjectDifferent.replace('{{primaryObjectAPIName}}','Account').replace('{{secondaryObjectAPIName}}','Opportunity'), ex.getMessage(), 'Wrong Exception message');            
        }

    }
    
    @isTest
    static void testGetUpdatedPrimarySObject(){
        List<String> lstFieldToCompare = new List<String>{'Name', 'AnnualRevenue', 'Website'};
        Account primarySObject = new Account(Name = 'Test Acc 1', AnnualRevenue = 100, Website = 'testacc1@test.com');
        Account secondarySObject = new Account(Name = 'Test Acc 2', AnnualRevenue = 200, Website = 'testacc2@test.com');
        
        insert new List<Account>{primarySObject, secondarySObject};
        
            
        //Passing tests
        AP13_CustomRecordComparaisonWrapper crcw = new AP13_CustomRecordComparaisonWrapper(primarySObject, secondarySObject, lstFieldToCompare);
        crcw.buildWrapper();
        
		for(AP13_CustomRecordComparaisonWrapper.CustomRecordComparaisonRow currCrcr:crcw.lstCustomRecordComparaisonRow){
            if(currCrcr.fieldAPIName == 'AnnualRevenue'){
                currCrcr.selectedValue = String.valueOf(500);
            }
            if(currCrcr.fieldAPIName == 'Website'){
                currCrcr.selectedValue = null;
            }
            if(currCrcr.fieldAPIName == 'Name'){
                currCrcr.selectedValue = 'Test Acc 1';
            }
        }
        
        Account primaryAccUpdated = (Account) crcw.getUpdatedPrimarySObject();
        
        update primaryAccUpdated;
        
        primaryAccUpdated = [SELECT AnnualRevenue FROM Account WHERE Id = :crcw.primarySObjectId LIMIT 1];
        
        Assert.areEqual(500, primaryAccUpdated.AnnualRevenue);

    }
}