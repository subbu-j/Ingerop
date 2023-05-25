@isTest
private class AccountHierarchyController_TEST {

    static testMethod void testAccountHierarchyController() {
        Account a1 = new Account(Name = 'Test 1');
        insert a1;
        
        Account a2 = new Account(Name = 'Test 2', ParentId = a1.Id);
        Account a3 = new Account(Name = 'Test 3', ParentId = a1.Id);
        insert a2;
        insert a3;
        
        Contact ct = new Contact(
        	LastName = 'Last 1',
            AccountId = a1.Id
        );
        insert ct;
        
        
        Test.startTest();
        AccountNode node = AccountHierarchyController.generateNode(a1.Id, null);
        
        system.assertEquals(2, node.listChildNodes.size());
        system.assertEquals(1, node.listChildContacts.size());
        system.assertEquals(a1.Name, node.a.Name);
    }
    
}