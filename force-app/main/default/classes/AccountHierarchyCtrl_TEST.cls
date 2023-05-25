@isTest
private class AccountHierarchyCtrl_TEST {
	
    static testMethod void testAccountHierarchyCtrl() {
        Account a = new Account(Name = 'Test');
        insert a;
        ApexPages.StandardController controller = new ApexPages.StandardController(a);
        AccountHierarchyCtrl ctrl = new AccountHierarchyCtrl(controller);
    }
    
}