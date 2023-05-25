/*
----------------------------------------------------------------------
-- - Name          : AP09Repartition
-- - Author        : Paul BENARD - Bluetis
-- - Description   : Methods for SObject Repartition__c
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 21-OCT-2016   ACU    1.0      Initial version
----------------------------------------------------------------------
*/
public class AP09Repartition {

    public static void createRepartition(Map<Id, Offre__c> mapOffreOld, List<Offre__c> listOffreNew){
        System.debug('## AP09Repartition.createRepartition START');
        List<Repartition__c> listRepartition = new List<Repartition__c>();
        Set<Id> offreIds = new Set<Id>();
        for(Offre__c offreNew : listOffreNew){
            if(offreNew.Operation__c != mapOffreOld.get(offreNew.Id).Operation__c){
                offreIds.add(offreNew.Id);
            }
        }
        if(offreIds.size()>0){
            List<Offre__c> listOffre = DAL.getOffreByIds(offreIds);
            for(Offre__c offre : listOffre){
                Repartition__c repartition = new Repartition__c();
                repartition.Offre__c = offre.Id;
                repartition.UFO__c = offre.Operation__r.UFO__c;
                repartition.Pole__c = offre.Operation__r.Pole__c;
                repartition.Departement__c = offre.Operation__r.Departement_du_pole__c;
                repartition.Service__c = offre.Operation__r.Service__c;
                repartition.Montant__c = offre.Montant_part_Ingerop__c == null ? 0 : offre.Montant_part_Ingerop__c;
                listRepartition.add(repartition);
            }
            if(listRepartition.size()>0){
                insert listRepartition;
            }
        }
        System.debug('## AP09Repartition.createRepartition END');
    }   
}