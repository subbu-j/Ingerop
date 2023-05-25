/*
----------------------------------------------------------------------
-- - Name          : VFC09PrendreVeille_TEST
-- - Author        : Boris THOMAS - Bluetis
-- - Description   : Test methods for VFC09PrendreVeille
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 13-SEP-2016   BTH    1.0      Initial version
----------------------------------------------------------------------
*/
@isTest
private with sharing class VFC09PrendreVeille_TEST {
    static User utilisateur;
    static List<Annonce__c> listVeille;

    static{
        utilisateur = TestDataFactory.createTestUser(UserInfo.getProfileId(), 'Test', 'Test'); 
        insert utilisateur;

        System.runAs(utilisateur){
            listVeille = new List<Annonce__c>{
                new Annonce__c(Objet__c = 'Test Objet', Contenu__c = 'Contenu test')
            };
            insert listVeille;
        }
    }

    static testmethod void testRecuperer(){
        System.runAs(utilisateur){
            ApexPages.StandardController standardController = new ApexPages.StandardController(listVeille[0]);
            VFC09PrendreVeille controller = new VFC09PrendreVeille(standardController);
            VFC09PrendreVeille.recuperation(listVeille[0].Id);
            Annonce__c veille = DAL.getVeilleById(listVeille[0].Id);
            System.assertEquals(utilisateur.Id, veille.OwnerId);
            System.assertEquals('Prise en compte', veille.Statut__c);
        }   
    }
}