public class AccountNode {
    
    public static Integer levelHelper {
        get {
            if(levelHelper == null) {
                levelHelper = 1;
            }
            return levelHelper;
        }
        set;
    }
    
    @AuraEnabled
    public Account a { get; set; }
    
    @AuraEnabled
    public list<AccountNode> listChildNodes { get; set; }
    
    @AuraEnabled
    public list<Contact> listChildContacts { get; set; }
    
    @AuraEnabled
    public Integer iLevel { get; set; }
    
    @AuraEnabled
    public String getlevel() {
        return String.valueOf(iLevel);
    }
    
    public AccountNode (Account a, Integer i){
        this.a = a;
        this.iLevel = i;
        
        system.debug(a.Contacts);
        if(a.Contacts != null && !a.Contacts.isEmpty() && a.Id != null) {
            system.debug('## in if');
            listChildContacts = new list<Contact>();
            listChildContacts.addAll(a.Contacts);
        }
        system.debug(listChildContacts);
        
        list<account> listChildAccounts = [SELECT 	Name,
                                           			BillingCity,
                                           			Owner.Name,
					                       			(SELECT Id, FirstName, LastName, Title FROM Contacts)
                                           FROM Account
                                           WHERE ParentId =: a.id
                                           ORDER BY Name];
        
        if(!listChildAccounts.isEmpty() && a.Id!=null) {
            listChildNodes = new list<AccountNode>();
            levelHelper++;
            for (Account acc : listChildAccounts) {
                listChildNodes.add(new AccountNode(acc, levelHelper));
            }
            levelHelper--;
        }
    }
}