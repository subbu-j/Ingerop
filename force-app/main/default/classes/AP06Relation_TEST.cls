/*
----------------------------------------------------------------------
-- - Name          : AP06Relation_TEST
-- - Author        : Boris THOMAS - Bluetis
-- - Description   : Test methods for AP06Relation
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 10-NOV-2016   BTH    1.0      Initial version
----------------------------------------------------------------------
*/
@isTest
private class AP06Relation_TEST {
    static User utilisateur1;
    static User utilisateur2;
    static List<Account> listAccount;
    static List<Contact> listContact;
    static List<Relation__c> listRelation;

    static{
        utilisateur1 = TestDataFactory.createTestUser(UserInfo.getProfileId(), 'Test1', 'Test1');
        insert utilisateur1;

        utilisateur2 = TestDataFactory.createTestUser(UserInfo.getProfileId(), 'Test2', 'Test2');
        insert utilisateur2;

        System.runAs(utilisateur1){
            listAccount = new List<Account>{
                new Account(Name = 'Compte 1', Activite__c = 'Bâtiment', Categorie__c = 'Architecte', Prive_public__c = 'Public')
            };
            insert listAccount;

            listContact = new List<Contact>{
                new Contact(FirstName = 'Toto', LastName = 'Tutu', AccountId = listAccount[0].Id)
            };
            insert listContact;

            listRelation = new List<Relation__c>{
                new Relation__c(Contact__c = listContact[0].Id, Utilisateur__c = utilisateur2.Id, Niveau_de_la_relation__c = 'Niveau 2')
            };
        }
    }

    static testMethod void testInsertNewRelation(){
        System.runAs(utilisateur1){
            insert listRelation;
            List<Relation__c> relationAfterInsert = DAL.getRelationByUserAndContact(utilisateur1.Id, listContact[0].Id);
            System.assertNotEquals(0, relationAfterInsert.size());
        }
    }

    static testMethod void testUpdateNewRelation(){
        System.runAs(utilisateur1){
            insert listRelation;
            update listRelation;
            List<Relation__c> relationAfterInsert = DAL.getRelationByUserAndContact(utilisateur1.Id, listContact[0].Id);
            System.assertNotEquals(0, relationAfterInsert.size());
        }
    }
}