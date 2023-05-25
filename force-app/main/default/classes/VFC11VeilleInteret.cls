/*
----------------------------------------------------------------------
-- - Name          : VFC11VeilleInteret
-- - Author        : Bluetis
-- - Description   : Extension for VFP11VeilleInteret
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 30-NOV-2016   BLU    1.0      Initial version
----------------------------------------------------------------------
*/
public without sharing class VFC11VeilleInteret {
  public Annonce__c veille {get;set;}
   public id annonceId {get;set;}

  public VFC11VeilleInteret(ApexPages.StandardController controller) {
    System.debug('## VFC11VeilleInteret.init START');
    annonceId = ApexPages.currentPage().getParameters().get('AnnonceId');
    veille = DAL.getVeilleById(annonceId);
    System.debug('## VFC11VeilleInteret.init END');
  }
    
    @RemoteAction
    public static void recuperation(String veilleId) {
        try {
          /* MAJ de l'annonce */
            Annonce__c annonce = DAL.getVeilleById(veilleId);
            if(annonce != null){ 
                /*Recherche de veille ou création si destinataire absent*/
                List<Veille__c> listVeille = DAL.getVeilleByUserId(UserInfo.getUserId(), annonce.Id);
                
                if(listVeille.isEmpty()){
                  Veille__c v = new Veille__c();
                  v.Annonce__c = annonce.Id;
                  v.Destinataire__c = UserInfo.getUserId();
                  v.Interet__c = true;
                  v.Statut__c = Label.AnnonceLuStatut;
                  insert v;
                }else{

                  if(listVeille[0].Interet__c){
                      listVeille[0].Interet__c = false;                     
                  }
                  else{
                      listVeille[0].Interet__c = true;
                  }
                  listVeille[0].Statut__c = Label.AnnonceLuStatut;
                  update listVeille;
                }
            }                       
        } catch(Exception e) {
           System.debug('## ERREUR : '+ e.getMessage());
        }
    }
    }