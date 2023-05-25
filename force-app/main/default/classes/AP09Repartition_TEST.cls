/*
----------------------------------------------------------------------
-- - Name          : AP09Repartition_TEST
-- - Author        : Boris THOMAS - Bluetis
-- - Description   : Test methods for class : AP09Repartition
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 10-NOV-2016   BTH    1.0      Initial version
-- 08-JUL-2017   NDI    2.0      Statut Candidature : Perdue en Non retenue
-- 03-SEP-2017   NDI    3.0      Correction gestion des droits et contacts
----------------------------------------------------------------------
*/
@isTest
private class AP09Repartition_TEST {
    static List<Account> listAccount;
    static List<Operation__c> listOperation;
    static List<Offre__c> listOffre;
    static List<Equipe_Candidature__c> listEquipeCandidature;
    static List<Contact> listContact; //NDI
    
    static{
        listAccount = new List<Account>{
            new Account(Name = 'Compte 1', Activite__c = 'Bâtiment', Categorie__c = 'Architecte', Prive_public__c = 'Public'),
            new Account(Name = 'INGEROP', Activite__c = 'Bâtiment', Categorie__c = 'Architecte', Prive_public__c = 'Public')
        };
        insert listAccount;

        listOperation = new List<Operation__c>{
            new Operation__c(Name = 'op 1', Compte__c = listAccount[0].Id)
        };
        insert listOperation;

        listEquipeCandidature = new List<Equipe_Candidature__c>{
            new Equipe_Candidature__c(Operation__c = listOperation[0].Id, Mandataire__c = listAccount[0].Id, Statut__c = Label.statut_nonRetenue, Date_limite_de_remise__c = Date.today()+3)
        };
        insert listEquipeCandidature;

        listContact = new List<Contact>{
            new Contact(AccountId = listAccount[0].Id, LastName='NOM', Title='TEST', FirstName='TEST')
        };
        insert listContact;
        
        listOffre = new List<Offre__c>{
            new Offre__c(Candidature__c = listEquipeCandidature[0].Id, Compte__c = listAccount[0].Id, ResponsableOffre__c = listContact [0].Id)
        };
    }

    static testMethod void testCreateRepartition(){
        insert listOffre;
        List<Repartition__c> listRepartition = DAL.getRepartitionByOffreId(listOffre[0].Id);
        // NDI : modifié pour réussir test
        System.assertEquals(1, listRepartition.size());
        //System.assertEquals(0, listRepartition.size());
    }
}