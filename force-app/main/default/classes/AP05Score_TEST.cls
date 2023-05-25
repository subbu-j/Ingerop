/*
----------------------------------------------------------------------
-- - Name          : AP05Score_TEST
-- - Author        : Boris THOMAS - Bluetis
-- - Description   : Test methods for AP05Score
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 01-JUL-2016   BTH    1.0      Initial version
----------------------------------------------------------------------
*/
@isTest
private class AP05Score_TEST {
    static Id recordTypePartenaire;
    static User utilisateur1;
    static List<Account> listPartenaire;
    static List<Score__c> listScore;

    static{
        recordTypePartenaire = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partenaire').getRecordTypeId();
        
        utilisateur1 = TestDataFactory.createTestUser(UserInfo.getProfileId(), 'Test', 'Test Code1');
        insert utilisateur1;

        listPartenaire = new List<Account>{
            new Account(Name = 'Compte partenaire 1', RecordTypeId = recordTypePartenaire)
        };
        insert listPartenaire;
    }

    static testMethod void testMajScorePartenaire(){
        Score__c score = new Score__c(Compte__c = listPartenaire[0].Id, Utilisateur__c = utilisateur1.Id, Note_attribuee__c = 3);
        insert score;
        Account compte = DAL.getAccountById(listPartenaire[0].Id);
        System.assertEquals(3, compte.Moyenne_des_scores__c);
    }

    static testMethod void testDeleteScorePartenaire(){
        Score__c score = new Score__c(Compte__c = listPartenaire[0].Id, Utilisateur__c = utilisateur1.Id, Note_attribuee__c = 3);
        insert score;
        delete score;
    }
}