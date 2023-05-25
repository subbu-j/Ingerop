/*
----------------------------------------------------------------------
-- - Name          : VFC02EquipeDuCompte_TEST
-- - Author        : Boris THOMAS - Bluetis
-- - Description   : Test methods for VFC02EquipeDuCompte
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 17-JUN-2016   BTH    1.0      Initial version
----------------------------------------------------------------------
*/
@isTest
private class VFC02EquipeDuCompte_TEST {
    static User utilisateur1;
    static User utilisateur2;
    static List<Account> listAccount;
    static List<Contact> listContact;
    static List<Operation__c> listOperation;
    static List<Membre_de_l_operation__c> listMembreOperation;
    static List<Membre_du_compte__c> listMembreDuCompte;
    static List<Information_du_compte__c> listInformationDuCompte;

    static{
        utilisateur1 = TestDataFactory.createTestUser(UserInfo.getProfileId(), 'Test', 'Test Code1'); 
        insert utilisateur1;

        utilisateur2 = TestDataFactory.createTestUser(UserInfo.getProfileId(), 'Test', 'Test Code2'); 
        insert utilisateur2;

        listAccount = new List<Account>{
            new Account(Name = 'Compte 1', Activite__c = 'Bâtiment', Categorie__c = 'Architecte', Prive_public__c = 'Public')
        };
        insert listAccount;

        listContact = new List<Contact>{
            new Contact(FirstName = 'Toto', LastName = 'Tutu', AccountId = listAccount[0].Id)
        };
        insert listContact;

        listOperation = new List<Operation__c>{
            new Operation__c(Name = 'op test', Compte__c = listAccount[0].Id)
        };
        insert listOperation;

        listMembreOperation = new List<Membre_de_l_operation__c>{
            new Membre_de_l_operation__c(Utilisateur__c = utilisateur1.Id, Operation__c = listOperation[0].Id)
        };
        insert listMembreOperation;

        listInformationDuCompte = new List<Information_du_compte__c>{
            new Information_du_compte__c(Compte__c = listAccount[0].Id, Observation__c = 'OK')
        };
        insert listInformationDuCompte;

        listMembreDuCompte = new List<Membre_du_compte__c>{
            new Membre_du_compte__c(Utilisateur__c = utilisateur2.Id, Compte__c = listAccount[0].Id)
        };
        insert listMembreDuCompte;
    }

    static VFC02EquipeDuCompte initController(){
        ApexPages.StandardController standardController = new ApexPages.StandardController(listAccount[0]);
        return new VFC02EquipeDuCompte(standardController);
    }

    static testmethod void testInit(){
        VFC02EquipeDuCompte controller = initController();
        System.assertEquals(listAccount[0].Id, controller.accountId);    
    }

    static testMethod void testInitListMembreDuCompte(){
        List<VFC02EquipeDuCompte.MembreDuCompte> listMembreDuCompteActuel = VFC02EquipeDuCompte.initListMembreDuCompte(listAccount[0].Id);
        System.assertEquals(1, listMembreDuCompteActuel.size());
    }

    static testMethod void testInitNewMembreDuCompte(){
        VFC02EquipeDuCompte.MembreDuCompte membreDuCompte = VFC02EquipeDuCompte.initNewMembreDuCompte(listAccount[0].Id);
        System.assertNotEquals(null, membreDuCompte);
    }

    static testMethod void testModifierMembreDuCompte(){
        VFC02EquipeDuCompte.MembreDuCompte membreDuCompte = VFC02EquipeDuCompte.modifierMembreDuCompte(listMembreDuCompte[0].Id);
        System.assertNotEquals(null, membreDuCompte);
    }

    static testMethod void testAutocomplete(){
        List<User> listUser = VFC02EquipeDuCompte.autocompleteUsers('User', 'Test Code1', 'Id,Name', 'Name', 10, listAccount[0].Id);
        System.assertEquals(1, listUser.size());
    }

    static testMethod void testDoSave(){
        VFC02EquipeDuCompte.MembreDuCompte membreDuCompte = new  VFC02EquipeDuCompte.MembreDuCompte();
        membreDuCompte.accessContact = 'Acteur/Lecteur';
        membreDuCompte.accessOperation = 'Acteur/Lecteur';
        membreDuCompte.accessInfo = 'Acteur/Lecteur';
        membreDuCompte.userId = utilisateur1.Id;
        membreDuCompte.accountId = listAccount[0].Id;
        VFC02EquipeDuCompte.doSave(membreDuCompte);
        List<Membre_du_compte__c> listMembreDuCompteActuelle = DAL.getMembreDuCompteByAccountId(listAccount[0].Id);
        Membre_de_l_operation__c mo = DAL.getMembreOperationByOperationIdAndUserId(listOperation[0].Id, utilisateur1.Id);
        System.assertEquals(2, listMembreDuCompteActuelle.size());
        System.assertEquals(null, mo);
    }

    static testMethod void testUpdateMembre(){
        VFC02EquipeDuCompte.MembreDuCompte membreDuCompte = VFC02EquipeDuCompte.modifierMembreDuCompte(listMembreDuCompte[0].Id);
        VFC02EquipeDuCompte.doSave(membreDuCompte);
        List<Membre_du_compte__c> listMembreDuCompteActuelle = DAL.getMembreDuCompteByAccountId(listAccount[0].Id);
        System.assertEquals(1, listMembreDuCompteActuelle.size());
    }

    static testMethod void testDoDelete(){
        VFC02EquipeDuCompte.doDelete(listMembreDuCompte[0].Id, utilisateur2.Id, listAccount[0].Id);
        List<Membre_du_compte__c> listMembreDuCompteActuelle = DAL.getMembreDuCompteByAccountId(listAccount[0].Id);
        System.assertEquals(0, listMembreDuCompteActuelle.size());
    }
}