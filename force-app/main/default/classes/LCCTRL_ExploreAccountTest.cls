/**
 * @description       : This is a test class for LCCTRL_ExploreAccount controller class
 * @author            : subramanyam.jagadeesan@springfive.com
 * @group             : 
 * @last modified on  : 2023-05-30
 * @last modified by  : subramanyam.jagadeesan@springfive.com
**/

@isTest
public class LCCTRL_ExploreAccountTest {
    @isTest
    static void testExploreAccount(){
        Account acc = new Account(Name='Test Account', Alias__c = 'Test', SIRET__c = '40798530800011');
        insert acc;
        
        List<String> recordTypeList = LCCTRL_ExploreAccount.fetchRecordTypeValues();
        
        List<Account> searchAccounts = LCCTRL_ExploreAccount.getAccountsDataSearch('Test');
        System.assertEquals(1, searchAccounts.size());

        String accountId = LCCTRL_ExploreAccount.getAccountIdBySiret('40798530800011');
        System.assertEquals(acc.Id, accountId);
        System.assertEquals(null, LCCTRL_ExploreAccount.getAccountIdBySiret('40798530800012'));
        
        Test.startTest();
        LCCTRL_ExploreAccount.ExploreAccountWrapper accWrap = LCCTRL_ExploreAccount.createAccount('52504601700030', 'Client');
        System.assertEquals('0182462000', accWrap.Phone);
        Test.stopTest();

    }
}