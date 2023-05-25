/*
----------------------------------------------------------------------
-- - Name          : VFC03MembreDEquipeCandidature_TEST
-- - Author        : Boris THOMAS - Bluetis
-- - Description   : Test methods for class : VFC03MembreDEquipeCandidature
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 21-NOV-2016   BTH    1.0      Initial version
----------------------------------------------------------------------
*/
@isTest
private class VFC03MembreDEquipeCandidature_TEST {
    static User utilisateur;
    static List<Account> listAccount;
    static List<Contact> listContact;
    static List<Operation__c> listOperation;
    static List<Equipe_Candidature__c> listEquipeCandidature;

    static{
        utilisateur = TestDataFactory.createTestUser(UserInfo.getProfileId(), 'Test1', 'Test1');
        insert utilisateur;

        System.runAs(utilisateur){
            listAccount = new List<Account>{
                new Account(Name = 'Compte 1', Activite__c = 'Bâtiment', Categorie__c = 'Architecte', Prive_public__c = 'Public', ShippingCity = 'Bordeaux', ShippingPostalCode = '33300'),
                new Account(Name = 'Ingerop', Activite__c = 'Bâtiment', Categorie__c = 'Architecte', Prive_public__c = 'Public')
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

            listEquipeCandidature = new List<Equipe_Candidature__c>{
                new Equipe_Candidature__c(Operation__c = listOperation[0].Id)
            };
            insert listEquipeCandidature;
        }       
    }

    static VFC03MembreDEquipeCandidature initController(Equipe_Candidature__c equipe){
        PageReference pageRef = Page.VFP03MembreDEquipeCandidature;
        Test.setCurrentPageReference(pageRef);
        ApexPages.CurrentPage().getparameters().put('id', equipe.Id);
        return new VFC03MembreDEquipeCandidature();
    }

    static testMethod void testInit(){
        System.runAs(utilisateur){
            VFC03MembreDEquipeCandidature controller = initController(listEquipeCandidature[0]);
            System.assertEquals(listEquipeCandidature[0].Id, controller.myEquipe.Id);
        }
    }

    static testMethod void testGetSelectOption(){
        System.runAs(utilisateur){
            VFC03MembreDEquipeCandidature controller = initController(listEquipeCandidature[0]);
            controller.typeCompte = label.RTComptePartenaire;
            List<SelectOption> listCategorie = controller.getCategorieOnAccount();
            List<SelectOption> listRecordType = controller.getRecordTypeOnAccount();
            List<SelectOption> listPrivePublic = controller.getPrivepublicOnAccount();
            List<SelectOption> listTypes = controller.getTypes();
            List<SelectOption> listScore = controller.getScore();
            System.assertNotEquals(0, listCategorie.size());
            System.assertNotEquals(0, listRecordType.size());
            System.assertNotEquals(0, listPrivePublic.size());
            System.assertNotEquals(0, listTypes.size());
            System.assertNotEquals(0, listScore.size());
        }
    }

    static testMethod void testInitPaginationAndSearch(){
        System.runAs(utilisateur){
            VFC03MembreDEquipeCandidature controller = initController(listEquipeCandidature[0]);
            controller.initPaginationAndSearch();
            System.assert(!controller.mapContactByAccount.isEmpty());
            System.assertEquals(listAccount.size(), controller.listAccountWrapper.size());
        }
    }

    static testMethod void testInitPaginationAndSearchWithCriteria(){
        System.runAs(utilisateur){
            VFC03MembreDEquipeCandidature controller = initController(listEquipeCandidature[0]);
            controller.activite = 'Bâtiment';
            controller.categorie = 'Architecte';
            controller.typeCompte = Label.RTCompteClient;
            controller.scoreCompte = 0;
            controller.nomCompte = 'Compte 1';
            controller.codePostal = '33300';
            controller.ville = 'Bordeaux';
            controller.privepublic = 'Public';
            controller.initPaginationAndSearch();
            System.assertEquals(1, controller.listAccountWrapper.size());
        }
    }

    static testMethod void testAjouter(){
        System.runAs(utilisateur){
            VFC03MembreDEquipeCandidature controller = initController(listEquipeCandidature[0]);
            controller.initPaginationAndSearch();
            controller.listAccountWrapper[0].toInsert = true;
            controller.ajouter();
            List<Membre_d_Equipe_Candidature__c> listMembreEquipeCandidature = DAL.getMembreEquipeCandidatureByEquipeCandidatureId(listEquipeCandidature[0].Id);
            System.assertEquals(2, listMembreEquipeCandidature.size());
        }
    }

    static testMethod void testBeginning(){
        System.runAs(utilisateur){
            VFC03MembreDEquipeCandidature controller = initController(listEquipeCandidature[0]);
            controller.Beginning();
            System.assertEquals(0, controller.counter);
        }
    }

    static testMethod void testNext(){
        System.runAs(utilisateur){
            VFC03MembreDEquipeCandidature controller = initController(listEquipeCandidature[0]);
            controller.Next();
            System.assertEquals(controller.list_size, controller.counter);
        }
    }

    static testMethod void testPrevious(){
        System.runAs(utilisateur){
            VFC03MembreDEquipeCandidature controller = initController(listEquipeCandidature[0]);
            controller.Next();
            controller.Previous();
            System.assertEquals(0, controller.counter);
        }
    }

    static testMethod void testEnd(){
        System.runAs(utilisateur){
            VFC03MembreDEquipeCandidature controller = initController(listEquipeCandidature[0]);
            controller.initPaginationAndSearch();
            controller.End();
            System.assertEquals(0, controller.counter);
        }
    }

    static testMethod void testGetDisablePrevious(){
        System.runAs(utilisateur){
            VFC03MembreDEquipeCandidature controller = initController(listEquipeCandidature[0]);
            Boolean disabled = controller.getDisablePrevious();
            System.assert(disabled);
        }
    }

    static testMethod void testGetDisableNext(){
        System.runAs(utilisateur){
            VFC03MembreDEquipeCandidature controller = initController(listEquipeCandidature[0]);
            Boolean disabled = controller.getDisableNext();
            System.assert(disabled);
        }
    }

    static testMethod void testGetTotalSize(){
        System.runAs(utilisateur){
            VFC03MembreDEquipeCandidature controller = initController(listEquipeCandidature[0]);
            Integer total = controller.getTotal_size();
            System.assertEquals(controller.total_size, total);
        }
    }

    static testMethod void testGetPageNumber(){
        System.runAs(utilisateur){
            VFC03MembreDEquipeCandidature controller = initController(listEquipeCandidature[0]);
            controller.search();
            Integer pageNumber = controller.getPageNumber();
            System.assertEquals(1, pageNumber);
        }
    }

    static testMethod void testGetTotalPages(){
        System.runAs(utilisateur){
            VFC03MembreDEquipeCandidature controller = initController(listEquipeCandidature[0]);
            controller.search();
            Integer pageTotal = controller.getTotalPages();
            System.assertEquals(1, pageTotal);
        }
    }
}