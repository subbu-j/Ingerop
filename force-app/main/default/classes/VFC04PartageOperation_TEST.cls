/*
----------------------------------------------------------------------
-- - Name          : VFC04PartageOperation_TEST
-- - Author        : Boris THOMAS - Bluetis
-- - Description   : Test methods for VFC04PartageOperation
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 27-JUN-2016   BTH    1.0      Initial version
----------------------------------------------------------------------
*/
@isTest
private class VFC04PartageOperation_TEST {
    static User utilisateur;
    static User utilisateur1;
    static List<Account> listAccount;
    static List<Operation__c> listOperation;
    static List<Membre_de_l_operation__c> listMembreOperation;

    static{
        utilisateur = TestDataFactory.createTestUser(UserInfo.getProfileId(), 'Test', 'Test'); 
        insert utilisateur;

        utilisateur1 = TestDataFactory.createTestUser(UserInfo.getProfileId(), 'Test', 'Test Code1'); 
        insert utilisateur1;

        System.runAs(utilisateur){
            listAccount = new List<Account>{
                new Account(Name = 'Compte 1', Activite__c = 'Bâtiment', Categorie__c = 'Architecte', Prive_public__c = 'Public')
            };
            insert listAccount;

            listOperation = new List<Operation__c>{
                new Operation__c(Name = 'Op test', Compte__c = listAccount[0].Id)
            };
            insert listOperation;

            listMembreOperation = new List<Membre_de_l_operation__c>{
                new Membre_de_l_operation__c(Utilisateur__c = utilisateur1.Id, Operation__c = listOperation[0].Id)
            };
            insert listMembreOperation;
        }
    }

    static VFC04PartageOperation initController(){
        ApexPages.StandardController standardController = new ApexPages.StandardController(listOperation[0]);
        return new VFC04PartageOperation(standardController);
    }

    static testMethod void testInit(){
        System.runAs(utilisateur){
            VFC04PartageOperation controller = initController();
            System.assertEquals(listOperation[0].Id, controller.operation.Id);
            System.assert(controller.autorisation);
        }
    }

    static testMethod void testGetDroits(){
        System.runAs(utilisateur){
            VFC04PartageOperation controller = initController();
            List<SelectOption> listDroits = controller.getDroits();
            System.assertEquals(2, listDroits.size());
        }
    }

    static testMethod void testInitListUtilisateurPartage(){
        System.runAs(utilisateur){
            List<VFC04PartageOperation.UtilisateurPartage> listUtilisateurPartage = VFC04PartageOperation.initListUtilisateurPartage(listOperation[0].Id, utilisateur.Id);
            System.assertEquals(listMembreOperation.size(), listUtilisateurPartage.size());
        }
    }

    static testMethod void testInitNewUtilisateurPartage(){
        System.runAs(utilisateur){
            VFC04PartageOperation.UtilisateurPartage newUtilisateurPartage = new VFC04PartageOperation.UtilisateurPartage();
            newUtilisateurPartage = VFC04PartageOperation.initNewUtilisateurPartage(listOperation[0].Id);
            System.assertEquals(listOperation[0].Id, newUtilisateurPartage.operationId);
        }
    }

    static testMethod void testAutocomplete(){
        System.runAs(utilisateur){
            List<User> listUser = VFC04PartageOperation.autocompleteUsers('User', 'Test Code1', 'Id,Name', 'Name', 10, listAccount[0].Id);
            System.assertEquals(1, listUser.size());
        }
    }

    static testMethod void testModifierUtilisateurPartage(){
        System.runAs(utilisateur){
            VFC04PartageOperation.UtilisateurPartage utilisateurPartage = VFC04PartageOperation.modifierUtilisateurPartage(listOperation[0].Id, utilisateur1.Id);
            System.assertNotEquals(null, utilisateurPartage);
        }
    }

    static testMethod void testDoSave(){
        System.runAs(utilisateur){
            VFC04PartageOperation.UtilisateurPartage utilisateurPartage = VFC04PartageOperation.modifierUtilisateurPartage(listOperation[0].Id, utilisateur1.Id);
            VFC04PartageOperation.doSave(utilisateurPartage);
            List<Membre_de_l_operation__c> listMembreOperationActuelle = DAL.getMembreOperationByOperationId(listOperation[0].Id);
            System.assertEquals(1, listMembreOperationActuelle.size());
        }
    }

    static testMethod void testDoDelete(){
        System.runAs(utilisateur){
            VFC04PartageOperation.UtilisateurPartage utilisateurPartage = VFC04PartageOperation.modifierUtilisateurPartage(listOperation[0].Id, utilisateur1.Id);
            VFC04PartageOperation.doSave(utilisateurPartage);
            VFC04PartageOperation.doDelete(utilisateur1.Id, listOperation[0].Id);
            List<Membre_de_l_operation__c> listMembreOperationActuelle = DAL.getMembreOperationByOperationId(listOperation[0].Id);
            System.assertEquals(0, listMembreOperationActuelle.size());
        }
    }
}