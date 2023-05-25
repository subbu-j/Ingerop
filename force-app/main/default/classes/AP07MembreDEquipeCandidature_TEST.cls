/*
----------------------------------------------------------------------
-- - Name          : AP07MembreDEquipeCandidature_TEST
-- - Author        : Boris THOMAS - Bluetis
-- - Description   : Test methods for AP07MembreDEquipeCandidature
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 10-NOV-2016   BTH    1.0      Initial version
-- 08-JUL-2017   NDI    2.0      Statut candidature Perdue en Non retenue
----------------------------------------------------------------------
*/
@isTest
private class AP07MembreDEquipeCandidature_TEST {
    static List<Account> listAccount;
    static List<Operation__c> listOperation;
    static List<Equipe_Candidature__c> listEquipeCandidature;
    static List<Membre_d_Equipe_Candidature__c> listMembreDEquipeCandidature;

    static{
        listAccount = new List<Account>{
            new Account(Name = 'Compte 1', Activite__c = 'Bâtiment', Categorie__c = 'Architecte', Prive_public__c = 'Public'),
            new Account(Name = 'Compte 2', Activite__c = 'Bâtiment', Categorie__c = 'Architecte', Prive_public__c = 'Public'),
            new Account(Name = 'INGEROP', Activite__c = 'Bâtiment', Categorie__c = 'Architecte', Prive_public__c = 'Public')
        };
        insert listAccount;

        listOperation = new List<Operation__c>{
            new Operation__c(Name = 'test', Compte__c = listAccount[0].Id, Phase_commerciale__c = Label.PhaseCommerciale_Candidature)
        };
        insert listOperation;

        listEquipeCandidature = new List<Equipe_Candidature__c>{
            new Equipe_Candidature__c(Operation__c = listOperation[0].Id, Mandataire__c = listAccount[0].Id, Statut__c = Label.statut_nonRetenue, Date_limite_de_remise__c = Date.today()+3)
        };
        insert listEquipeCandidature;

        listMembreDEquipeCandidature = new List<Membre_d_Equipe_Candidature__c>{
            new Membre_d_Equipe_Candidature__c(Equipe_Candidature__c = listEquipeCandidature[0].Id, Compte__c = listAccount[0].Id, Mandataire__c = true),
            new Membre_d_Equipe_Candidature__c(Equipe_Candidature__c = listEquipeCandidature[0].Id, Compte__c = listAccount[1].Id)
        };
        insert listMembreDEquipeCandidature;
    }

    static testMethod void testUpdateMandataireToFalse(){
        listMembreDEquipeCandidature[0].Mandataire__c = false;
        update listMembreDEquipeCandidature[0];
        Equipe_Candidature__c ec = DAL.getEquipeCandidatureById(listEquipeCandidature[0].Id);
        System.assertEquals(null, ec.Mandataire__c);
    }

    static testMethod void testUpdateMandataireToTrue(){
        listMembreDEquipeCandidature[1].Mandataire__c = true;
        update listMembreDEquipeCandidature[1];
        Equipe_Candidature__c ec = DAL.getEquipeCandidatureById(listEquipeCandidature[0].Id);
        Membre_d_Equipe_Candidature__c mec = DAL.getMembreEquipeCandidatureById(listMembreDEquipeCandidature[0].Id);
        System.assertEquals(listAccount[1].Id, ec.Mandataire__c);
        System.assertEquals(false, mec.Mandataire__c);
    }

    static testMethod void testDeleteMandataire(){
        delete listMembreDEquipeCandidature[0];
        Equipe_Candidature__c ec = DAL.getEquipeCandidatureById(listEquipeCandidature[0].Id);
        System.assertEquals(null, ec.Mandataire__c);
    }
}