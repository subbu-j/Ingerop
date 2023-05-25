/*
----------------------------------------------------------------------
-- - Name          : VFC09PrendreVeille
-- - Author        : Boris THOMAS - Bluetis
-- - Description   : Extension for VFP09PrendreVeille
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 13-SEP-2016   BTH    1.0      Initial version
-- 28-OCT-2016   MTE    1.1      MAJ récuperation method and postToChatter
-- 20-JUL-2018   NDI    2.0      MAJ API 43 (modif postFeedElement)
----------------------------------------------------------------------
*/
public without sharing class VFC09PrendreVeille {
    public Annonce__c veille {get;set;}
     public id annonceId {get;set;}

    public VFC09PrendreVeille(ApexPages.StandardController controller) {
        System.debug('## VFC09PrendreVeille.init START');
        annonceId = ApexPages.currentPage().getParameters().get('AnnonceId');
        veille = DAL.getVeilleById(annonceId);
        System.debug('## VFC09PrendreVeille.init END');
    }
    
    @RemoteAction
    public static void recuperation(String veilleId) {
        try {
            /* MAJ de l'annonce */
            Annonce__c annonce = DAL.getVeilleById(veilleId);
            if(annonce != null){ 
                annonce.OwnerId = UserInfo.getUserId();
                annonce.Statut__c = Label.AnnoncePriseEnCompteStatut;
                update annonce;

                /*Recherche de veille ou création si destinataire absent*/
                List<Veille__c> listVeille = DAL.getVeilleByUserId(UserInfo.getUserId(), annonce.Id);
                
                if(listVeille.isEmpty()){
                    Veille__c v = new Veille__c();
                    v.Annonce__c = annonce.Id;
                    v.Destinataire__c = UserInfo.getUserId();
                    v.Statut__c = Label.VeillePrisEnCompteStatut;
                    v.Interet__c = true;
                    insert v;
                }else{
                    listVeille[0].Statut__c = Label.VeillePrisEnCompteStatut;
                    listVeille[0].Interet__c = true;
                    update listVeille;
                }
                if(annonce.Statut__c == Label.AnnoncePriseEnCompteStatut){    
                    VFC09PrendreVeille.postToChatter(annonce.Id);
                }
                
            }
                         
        } catch(Exception e) {
           System.debug('## ERREUR : '+ e.getMessage());
        }
    }
    
    public static void postToChatter(String idVeille) {
        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
        ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
        ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
        messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
        
        list<Veille__c> listVeille = new list<Veille__c>();
        listVeille = DAL.getVeillePrisEnCompteByAnnonceId(idVeille);
        if(listVeille != null){
            
            for(Veille__c v : listVeille){
                ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
                mentionSegmentInput.id = v.Destinataire__c;
                messageBodyInput.messageSegments.add(mentionSegmentInput);
            }
            
            textSegmentInput.text = ' ' + Label.VFP09PrendreVeille_Chatter;
            messageBodyInput.messageSegments.add(textSegmentInput);
            
            feedItemInput.body = messageBodyInput;
            feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
            feedItemInput.subjectId = idVeille;
            
            ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);//NDI20180720 passage API 43, null);
        }
    }
}