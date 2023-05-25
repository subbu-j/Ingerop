/*
----------------------------------------------------------------------
-- - Name          : VFC10VeilleLue
-- - Author        : Bluetis
-- - Description   : Extension for VFP10VeilleLue
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 30-NOV-2016   BLU    1.0      Initial version
----------------------------------------------------------------------
*/
public without sharing class VFC10VeilleLue {
  public Annonce__c veille {get;set;}
   public id annonceId {get;set;}

  public VFC10VeilleLue(ApexPages.StandardController controller) {
    System.debug('## VFC10VeilleLue.init START');
    annonceId = ApexPages.currentPage().getParameters().get('AnnonceId');
    veille = DAL.getVeilleById(annonceId);
    System.debug('## VFC10VeilleLue.init END');
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
                  v.Statut__c = Label.AnnonceLuStatut;
                  insert v;
                }else{
                  listVeille[0].Statut__c = Label.AnnonceLuStatut;
                  update listVeille;
                }
            }                       
        } catch(Exception e) {
           System.debug('## ERREUR : '+ e.getMessage());
        }
    }
    }