/*
----------------------------------------------------------------------
-- - Name          : AP04Operation_TEST
-- - Author        : Boris THOMAS - Bluetis
-- - Description   : Test methods for AP04Operation
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 17-JUN-2016   BTH    1.0      Initial version
-- 20-JUL-2018   NDI    2.0      Ouverture de droits
----------------------------------------------------------------------
*/
@isTest
private class AP04Operation_TEST {
    static User principalUser;
    static User user1;
    static User user2;
    static List<Account> listCompte;
    static List<Operation__c> listOperation;
    static List<Membre_du_compte__c> listMembreDuCompte;

    static{
        principalUser = TestDataFactory.createTestUser(UserInfo.getProfileId(), 'Test', 'Test');
        insert principalUser;

        user1 = TestDataFactory.createTestUser(UserInfo.getProfileId(), 'Test', 'Test Code1');
        insert user1;

        user2 = TestDataFactory.createTestUser(UserInfo.getProfileId(), 'Test', 'Test Code2');
        insert user2;

        System.runAs(principalUser){
            listCompte = new List<Account>{
                new Account(Name = 'Compte 1', Activite__c = 'Ville & mobilité', Categorie__c = 'Architecte', Prive_public__c = 'Public')
            };
            insert listCompte;

            listOperation = new List<Operation__c>{
                new Operation__c(Name = 'Test', Compte__c = listCompte[0].Id)
            };
            insert listOperation;

            listMembreDuCompte = new List<Membre_du_compte__c>{
                new Membre_du_compte__c(Utilisateur__c = user1.Id, Compte__c = listCompte[0].Id, Acces_a_operation__c = 'Lecteur'),
                new Membre_du_compte__c(Utilisateur__c = user2.Id, Compte__c = listCompte[0].Id, Acces_a_operation__c = 'Acteur/Lecteur')
            };
            insert listMembreDuCompte;
        }
    }

/*NDI20180720
    static testMethod void testCreateOperationShareOnAccount(){
        System.runAs(principalUser){
            AP04Operation.createOperationShareOnAccount(listOperation);
        }
        List<Operation__Share> listOperationShare = DAL.getOperationShareByOperationId(listOperation[0].Id);
        System.assertEquals(listMembreDuCompte.size(), listOperationShare.size());
    }
*/    
}