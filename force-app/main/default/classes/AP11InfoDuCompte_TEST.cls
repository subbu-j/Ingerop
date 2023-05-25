/*
----------------------------------------------------------------------
-- - Name          : AP11InfoDuCompte_TEST
-- - Author        : Boris THOMAS - Bluetis
-- - Description   : Test methods for class : AP11InfoDuCompte
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
private class AP11InfoDuCompte_TEST {
    static User utilisateur;
    static List<Account> listAccount;
    static List<Membre_du_compte__c> listMembreDuCompte;
    static List<Information_du_compte__c> listInformationDuCompte;

    static{
        utilisateur = TestDataFactory.createTestUser(UserInfo.getProfileId(), 'test', 'test');
        insert utilisateur;

        listAccount = new List<Account>{
            new Account(Name = 'Compte 1', Activite__c = Label.Batiment, Prive_public__c = 'Public')
        };
        insert listAccount;

        listMembreDuCompte = new List<Membre_du_compte__c>{
            new Membre_du_compte__c(Utilisateur__c = utilisateur.Id, Compte__c = listAccount[0].Id)
        };
        insert listMembreDuCompte;

        listInformationDuCompte = new List<Information_du_compte__c>{
            new Information_du_compte__c(Compte__c = listAccount[0].Id, Observation__c = 'OK')
        };
        insert listInformationDuCompte;
    }

    static testMethod void testCannotInsertInformationDuCompte(){
        try{
            Information_du_compte__c newInfo = new Information_du_compte__c(Compte__c = listAccount[0].Id, Observation__c = 'KO');
            insert newInfo;
            throw new UnexpectedTryException('An exception should have been thrown by the trigger but was not.');
        }catch(Exception e){
            Boolean expectedExceptionThrown = e.getMessage().contains(Label.ErrorInfoDuCompte);
            System.assert(expectedExceptionThrown);
        }
    }

    public class UnexpectedTryException extends Exception {}
}