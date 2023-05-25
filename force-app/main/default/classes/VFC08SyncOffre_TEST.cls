/*
----------------------------------------------------------------------
-- - Name          : VFC08SyncOffre_TEST
-- - Author        : Boris THOMAS - Bluetis
-- - Description   : Test methods for VFC08SyncOffre
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 10-NOV-2016   BTH    1.0      Initial version
-- 03-SEP-2017   NDI    2.0      Correction gestion des droits et contacts
----------------------------------------------------------------------
*/
@isTest
private class VFC08SyncOffre_TEST {
    static User utilisateur;
    static List<Account> listAccount;
    static List<Operation__c> listOperation;
    static List<Offre__c> listOffre;
    static List<Equipe_Candidature__c> listEquipeCandidature;
    static List<Contact> listContact; //NDI
    
    static{
        utilisateur = TestDataFactory.createTestUser(UserInfo.getProfileId(), 'Test', 'Test'); 
        insert utilisateur;

        System.runAs(utilisateur){
            listAccount = new List<Account>{
                new Account(Name = 'Compte 1', Activite__c = Label.Batiment, Prive_public__c = 'Public'),
                new Account(Name = 'INGEROP', Activite__c = Label.Batiment, Prive_public__c = 'Public')
            };
            insert listAccount;

            listOperation = new List<Operation__c>{
                new Operation__c(Name = 'Op test', Compte__c = listAccount[0].Id)
            };
            insert listOperation;

            listEquipeCandidature = new List<Equipe_Candidature__c>{
                new Equipe_Candidature__c(Operation__c = listOperation[0].Id, Mandataire__c = listAccount[0].Id, Date_limite_de_remise__c = Date.today()+3)
            };
            insert listEquipeCandidature;
            
            listContact = new List<Contact>{
                new Contact(AccountId = listAccount[0].Id, LastName='NOM', Title='TEST', FirstName='TEST')
            };
            insert listContact;

            listOffre = new List<Offre__c>{
                new Offre__c(Candidature__c = listEquipeCandidature[0].Id, Operation__c = listOperation[0].Id, Compte__c = listAccount[0].Id, ResponsableOffre__c = listContact [0].Id, Statut__c = Label.statut_Perdue)
            };
            insert listOffre;
        }
    }

    static VFC08SyncOffre initController(){
        ApexPages.StandardController standardController = new ApexPages.StandardController(listOffre[0]);
        return new VFC08SyncOffre(standardController);
    }

    static testmethod void testInit(){
        System.runAs(utilisateur){
            VFC08SyncOffre controller = initController();
            System.assertEquals(listOffre[0].Id, controller.offre.Id);
        }   
    }

    static testmethod void testSynchronise(){
        System.runAs(utilisateur){
            VFC08SyncOffre controller = initController();
            controller.offre.Statut__c = 'Gagnée';
            controller.synchroniser();
            Operation__c operation = DAL.getOperationById(listOperation[0].Id);
            System.assertEquals('Traitée', operation.Statut__c);
            controller.offre.Statut__c = 'Perdue';
            controller.synchroniser();
            operation = DAL.getOperationById(listOperation[0].Id);
            System.assertEquals('Perdue', operation.Statut__c);
            controller.offre.Statut__c = 'Sans suite';
            controller.synchroniser();
            operation = DAL.getOperationById(listOperation[0].Id);
            System.assertEquals('Sans suite', operation.Statut__c);
        }   
    }
}