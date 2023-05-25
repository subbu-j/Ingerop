/*
----------------------------------------------------------------------
-- - Name          : LCCTRL_Explore_TEST
-- - Author        : Sid Ramdowar
-- - Description   : Test methods for LCCTRL_Explore
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 22-JUL-2019  SRA    1.0     Initial version
----------------------------------------------------------------------
*/

@isTest
Private class LCCTRL_Explore_TEST {
    
    static User user1;
    static List<Account> listCompte;
    static List<Operation__c> listOperation;
    static List<Annonce__c> listAnnonce;
    static List<AnnonceOperations__c> listAnnonceOperation;

    static{

        user1 = TestDataFactory.createTestUser(UserInfo.getProfileId(), 'Test', 'Test Code1');
        insert user1;

        System.runAs(user1){
            listCompte = new List<Account>{
                new Account(Name='Compte1', Activite__c='Ville & mobilité', Categorie__c='Architecte', Prive_public__c='Public', SIRET__c='123456789')
            };
            insert listCompte;

            listAnnonce = new List<Annonce__c>{
                new Annonce__c(Name = 'Annonce1', Contenu__c='Contenu annonce', Date_de_parution__c= date.today(), Date_d_echeance__c=date.today(), IdExplore__c='MP#1111111', Code_postal__c='06000', IdExploreSimplifie__c=1111111,Lien_vers_l_annonce__c='https://extranet.explore.fr/DotNet/AffichageMarchePublic.aspx?projet=1111111', Objet__c='Objet annonce',Statut__c='Diffusée', Type__c='Appel d\'offre', Ville__c='Nice'),
                new Annonce__c(Name = 'Annonce2', Contenu__c='Contenu annonce', Date_de_parution__c= date.today(), Date_d_echeance__c=date.today(), IdExplore__c='MP#2222222', Code_postal__c='06000', IdExploreSimplifie__c=2222222,Lien_vers_l_annonce__c='https://extranet.explore.fr/DotNet/AffichageMarchePublic.aspx?projet=2222222', Objet__c='Objet annonce',Statut__c='Diffusée', Type__c='Appel d\'offre', Ville__c='Paris'),
                new Annonce__c(Name = 'Annonce3', Contenu__c='Contenu annonce', Date_de_parution__c= date.today(), Date_d_echeance__c=date.today(), IdExplore__c='MP#3333333', Code_postal__c='06000', IdExploreSimplifie__c=3333333,Lien_vers_l_annonce__c='https://extranet.explore.fr/DotNet/AffichageMarchePublic.aspx?projet=3333333', Objet__c='Objet annonce',Statut__c='Diffusée', Type__c='Appel d\'offre', Ville__c='Paris'),
                new Annonce__c(Name = 'Annonce4', Contenu__c='Contenu annonce', Date_de_parution__c= date.today(), Date_d_echeance__c=date.today(), IdExplore__c='MP#4444444', Code_postal__c='06000', IdExploreSimplifie__c=4444444,Lien_vers_l_annonce__c='https://extranet.explore.fr/DotNet/AffichageMarchePublic.aspx?projet=4444444', Objet__c='Objet annonce',Statut__c='Diffusée', Type__c='Appel d\'offre', Ville__c='Paris')
            };
            insert listAnnonce;

            listOperation = new List<Operation__c>{
                new Operation__c(Name='Operation 1 - Annonce 1111111', Compte__c=listCompte[0].Id, Activite__c='Bâtiment', Code_postal__c='06000', Departement__c='6	Alpes-Maritimes', Objet__c='Objet operation', Pays__c='France', Phase_commerciale__c='Prospect', Privee_public__c='Public', Type_d_operation__c='Neuf',UFO__c='BUSINESS INGEROP CONTRACTING', Ville__c='NICE', Zone_geographique__c='Europe de l\'Ouest (zone "Euro")'),
                new Operation__c(Name='Operation 2 - Annonce 2222222', Compte__c=listCompte[0].Id, Activite__c='Bâtiment', Code_postal__c='75008', Departement__c='75	Paris', Objet__c='Objet operation', Pays__c='France', Phase_commerciale__c='Prospect', Privee_public__c='Public', Type_d_operation__c='Neuf',UFO__c='BUSINESS INGEROP CONTRACTING', Ville__c='PARIS', Zone_geographique__c='Europe de l\'Ouest (zone "Euro")'),
                new Operation__c(Name='Operation 3 - Annonce 3333333', Compte__c=listCompte[0].Id, Activite__c='Bâtiment', Code_postal__c='75008', Departement__c='75	Paris', Objet__c='Objet operation', Pays__c='France', Phase_commerciale__c='Prospect', Privee_public__c='Public', Type_d_operation__c='Neuf',UFO__c='BUSINESS INGEROP CONTRACTING', Ville__c='PARIS', Zone_geographique__c='Europe de l\'Ouest (zone "Euro")'),
                new Operation__c(Name='Operation 4 - Annonce 3333333', Compte__c=listCompte[0].Id, Activite__c='Bâtiment', Code_postal__c='75008', Departement__c='75	Paris', Objet__c='Objet operation', Pays__c='France', Phase_commerciale__c='Prospect', Privee_public__c='Public', Type_d_operation__c='Neuf',UFO__c='BUSINESS INGEROP CONTRACTING', Ville__c='PARIS', Zone_geographique__c='Europe de l\'Ouest (zone "Euro")'),
                new Operation__c(Name='Operation 5', Compte__c=listCompte[0].Id, Activite__c='Bâtiment', Code_postal__c='75008', Departement__c='75	Paris', Objet__c='Objet operation', Pays__c='France', Phase_commerciale__c='Prospect', Privee_public__c='Public', Type_d_operation__c='Neuf',UFO__c='BUSINESS INGEROP CONTRACTING', Ville__c='PARIS', Zone_geographique__c='Europe de l\'Ouest (zone "Euro")')
            };
            insert listOperation;
            
            listAnnonceOperation = new List<AnnonceOperations__c>{
                new AnnonceOperations__c(Annonce__c=listAnnonce[0].Id, Compte__c=listCompte[0].Id, Operation__c=listOperation[0].Id),
                new AnnonceOperations__c(Annonce__c=listAnnonce[1].Id, Compte__c=listCompte[0].Id, Operation__c=listOperation[1].Id),
                new AnnonceOperations__c(Annonce__c=listAnnonce[2].Id, Compte__c=listCompte[0].Id, Operation__c=listOperation[2].Id),
                new AnnonceOperations__c(Annonce__c=listAnnonce[2].Id, Compte__c=listCompte[0].Id, Operation__c=listOperation[3].Id)
            };
            insert listAnnonceOperation;
        }
    }
    
    static testMethod void testGetRelatedOperationsData(){
        System.runAs(user1){
            LCCTRL_Explore.getRelatedOperationsData('MP-3333333');
        }
    }
    
    static testMethod void testGetOtherOperationsData(){
        System.runAs(user1){
            LCCTRL_Explore.getOtherOperationsData('MP-1111111', listCompte[0].SIRET__c);
        }
    }
    
    static testMethod void testGetOperationsDataSearch(){
        System.runAs(user1){
            LCCTRL_Explore.getOperationsDataSearch('MP-3333333', 'Opé');
        }
    }
    
    static testMethod void testLinkAnnonceToOperation(){
        System.runAs(user1){

            Test.startTest();
            
			Test.setMock(HttpCalloutMock.class, new Explore_MockMarchePublic());
			String returnValue = LCCTRL_Explore.linkAnnonceToOperation(listOperation[4].Id, 'MP-5555555');
			String expectedValue = 'true';
			System.assertNotEquals(returnValue, null);

			Test.stopTest();
        }
    }

    static testMethod void testUnlinkOperation(){
        System.runAs(user1){
            LCCTRL_Explore.unlinkOperation(listOperation[0].Id, 'MP-1111111');
        }
    }

    static testMethod void testGetAnnonceMarchePublicData(){
        System.runAs(user1){

            Test.startTest();
            
			Test.setMock(HttpCalloutMock.class, new Explore_MockMarchePublic());
			String returnValue = LCCTRL_Explore.getAnnonceMarchePublicData('MP-1111111');
			System.assertNotEquals(returnValue, null);

			Test.stopTest();

        }
    }
    
    static testMethod void testGetAccountIdBySiret(){
        System.runAs(user1){
            LCCTRL_Explore.getAccountIdBySiret(listCompte[0].SIRET__c);
        }
    }

    static testMethod void testCreateAnnonce(){
        System.runAs(user1){
            
            Test.startTest();
            
			Test.setMock(HttpCalloutMock.class, new Explore_MockMarchePublic());
			String returnValue = LCCTRL_Explore.createAnnonce('MP-1111111');
			String expectedValue = 'true';
			System.assertNotEquals(returnValue, null);

			Test.stopTest();
        }
    }

    @IsTest(SeeAllData=true)
    static void testPostChatterFeedElement(){
        System.runAs(user1){
            List <Operation__c> lstOpe = [SELECT Id, Name, OwnerId FROM Operation__c ];
            Test.startTest();
            System.assertEquals(null, LCCTRL_Explore.postChatterFeedElement(listOperation[0].Id, 'Operation name', lstOpe[0].OwnerId, 'Object', listOperation[1].Id));
            Test.stopTest();
        }
    }

}