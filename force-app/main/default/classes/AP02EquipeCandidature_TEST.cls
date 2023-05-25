/*
----------------------------------------------------------------------
-- - Name          : AP02EquipeCandidature_TEST
-- - Author        : Boris THOMAS - Bluetis
-- - Description   : Test methods for AP02EquipeCandidature
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 10-NOV-2016   BTH    1.0      Initial version
-- 09-JUL-2017	 NDI	2.0 	 Statut Candidature Perdue en Non Retenue
----------------------------------------------------------------------
*/
@isTest
private class AP02EquipeCandidature_TEST {
    static List<Account> listAccount;
    static List<Operation__c> listOperation;
    static List<Equipe_Candidature__c> listEquipeCandidature;

    static{
        listAccount = new List<Account>{
            new Account(Name = 'Compte 1', Activite__c = 'Bâtiment', Categorie__c = 'Architecte', Prive_public__c = 'Public'),
            new Account(Name = 'INGEROP', Activite__c = 'Bâtiment', Categorie__c = 'Architecte', Prive_public__c = 'Public')
        };
        insert listAccount;

        listOperation = new List<Operation__c>{
            new Operation__c(Name = 'test', Compte__c = listAccount[0].Id, Phase_commerciale__c = Label.PhaseCommerciale_Candidature),
            new Operation__c(Name = 'test2', Compte__c = listAccount[0].Id, Phase_commerciale__c = Label.PhaseCommerciale_Candidature, Date_previsionnelle_de_candidature__c = Date.today())
        };
        insert listOperation;

        listEquipeCandidature = new List<Equipe_Candidature__c>{
            //new Equipe_Candidature__c(Operation__c = listOperation[0].Id, Mandataire__c = listAccount[0].Id, Statut__c = Label.statut_Perdue, Date_limite_de_remise__c = Date.today()+3),
            //new Equipe_Candidature__c(Operation__c = listOperation[0].Id, Mandataire__c = listAccount[0].Id, Statut__c = Label.statut_Perdue),
            //NDI 20170708 : Perdue en Non Retenue
            new Equipe_Candidature__c(Operation__c = listOperation[0].Id, Mandataire__c = listAccount[0].Id, Statut__c = Label.statut_nonRetenue, Date_limite_de_remise__c = Date.today()+3),
            new Equipe_Candidature__c(Operation__c = listOperation[0].Id, Mandataire__c = listAccount[0].Id, Statut__c = Label.statut_nonRetenue),
            new Equipe_Candidature__c(Operation__c = listOperation[0].Id, Mandataire__c = listAccount[0].Id),
            new Equipe_Candidature__c(Operation__c = listOperation[1].Id, Mandataire__c = listAccount[0].Id)
        };
    }

    static testmethod void testCreateIngeropCoTraitant(){
        insert listEquipeCandidature;
        Equipe_Candidature__c ec = DAL.getEquipeCandidatureById(listEquipeCandidature[0].Id);
        List<Membre_d_Equipe_Candidature__c> listIngeropCoTraitant = DAL.getMembreEquipeCandidatureByEquipeCandidatureId(listEquipeCandidature[0].Id);
        System.assertEquals(listAccount[1].Id, ec.Mandataire__c);
        System.assertEquals(1, listIngeropCoTraitant.size());
    }

    static testmethod void testMajDateLimiteDeRemise(){
        insert listEquipeCandidature[3];
        Equipe_Candidature__c equipeDateNormale = DAL.getEquipeCandidatureById(listEquipeCandidature[3].Id);
        System.assertEquals(listOperation[1].Date_previsionnelle_de_candidature__c, equipeDateNormale.Date_limite_de_remise__c);
    }

    static testmethod void testMajOperationStatut(){
        insert listEquipeCandidature;
        //listEquipeCandidature[2].Statut__c = Label.statut_Perdue;
        //NDI 20170708 : Statut Candidature Perdue en Non Retenue
        listEquipeCandidature[2].Statut__c = Label.statut_nonRetenue;
        update listEquipeCandidature;
        Operation__c operation = DAL.getOperationById(listOperation[0].Id);
        System.assertEquals(Label.statut_Perdue, operation.Statut__c);
    }

    static testmethod void testEmptyMandataire(){
        insert listEquipeCandidature;
        AP02EquipeCandidature.emptyMandataireOnEquipe(new Map<Id, SObject>(listEquipeCandidature).keySet());
        Equipe_Candidature__c ec = DAL.getEquipeCandidatureById(listEquipeCandidature[0].Id);
        System.assertEquals(null, ec.Mandataire__c);
    }
}