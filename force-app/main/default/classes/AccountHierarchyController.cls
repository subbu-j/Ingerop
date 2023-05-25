public class AccountHierarchyController {
    
    @AuraEnabled
    public static AccountNode generateNode(String accountId, Boolean b) {
        Boolean isSF1;        
        if(b != null) {
            isSF1 = b;
        }
        else {
            try {
                isSF1 = (ApexPages.currentPage().getParameters().get('isdtp') == 'p1');
            }
            catch(Exception ex) {
                isSF1 = false;
            }
        }

        system.debug(accountId);
        Account a = [SELECT Id,
             				Ultimate_Parent_ID__c
                     FROM Account
                     WHERE Id =: accountId];
        system.debug(a);
        
        Account top = [SELECT 	Name,
                               	ParentId,
                       			(SELECT Id, FirstName, LastName, Title FROM Contacts)
                   FROM Account
                   WHERE Id =: a.Ultimate_Parent_ID__c];

        AccountNode root = new AccountNode(top, 1);
        
        return root;
    }
}