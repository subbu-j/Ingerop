/*
----------------------------------------------------------------------
-- - Name          : TestDataFactory
-- - Author        : Boris THOMAS - Bluetis
-- - Description   : Methods for test classes
-- - Module        : CRM Ingerop
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 10-NOV-2016   BTH    1.0      Initial version
----------------------------------------------------------------------
*/
public without sharing class TestDataFactory {
    
    public static Boolean TEST_returnEmpty;
    public static final String JSON_RESULT_CRCC = '{"Ext_Name":"Test", "Ext_AnnualRevenue":"30000", "Ext_ShippingPostalCode":"92000", "Ext_ShippingLongitude":"3.141592", "Ext_SIRET":"12334567"}';
    public static final String JSON_RESULT_EXPLORE = '{ "NOTICE80": { "SIRET": "52504601700030", "SIREN": "525046017", "NIC": "00030", "L1_NOMEN": "SOCIETE DU GRAND PARIS", "L2_COMP": "", "L3_CADR": "IMMEUBLE LE CEZANNE", "L4_VOIE": "30 AVENUE DES FRUITIERS", "L5_DISP": "CS 10011 ST DENIS", "L6_POST": "93212 LA PLAINE ST DENIS CEDEX", "L7_ETRG": "FRANCE", "RPET": "11", "DEPET": "93", "ARRONET": "3", "CTONET": "99", "COMET": "066", "LIBCOM": "SAINT DENIS", "DU": "00", "TU": "8", "UU": "51", "EPCI": "200054781", "TCD": "61", "ZEMET": "11", "CODEVOIE": "", "NUMVOIE": "30", "INDREP": "", "TYPVOIE": "AV", "LIBVOIE": "DES FRUITIERS", "CODPOS": "93210", "CEDEX": "", "ZR1": "", "SIEGE": "1", "ENSEIGNE": "", "NOMCOM": "", "NATETAB": "", "LIBNATETAB": "", "APET700": "8413Z", "LIBAPET": "Administration publique (tutelle) des activités économiques", "DAPET": "2011", "TEFET": "31", "EFETCENT": "200", "DEFET": "2016", "ORIGINE": "1", "DCRET": "201111", "AMINTRET": "201209", "ACTIVNAT": "", "LIEUACT": "", "ACTISURF": "", "SAISONAT": "P", "MODET": "S", "PRODET": "O", "PRODPART": "", "AUXILT": "0", "ZR2": "", "NOMEN_LONG": "SOCIETE DU GRAND PARIS", "SIGLE": "SGP", "CIVILITE": "", "NJ": "4110", "LIBNJ": "Établissement public national à caractère industriel ou commercial doté d\'un comptable public ", "APEN700": "8413Z", "LIBAPEN": "Administration publique (tutelle) des activités économiques", "DAPEN": "2010", "APRM": "", "TEFEN": "31", "EFENCENT": "200", "DEFEN": "2016", "CATEGORIE": "PME", "DCREN": "201007", "AMINTREN": "201209", "MONOACT": "1", "MODEN": "S", "PRODEN": "O", "ESAANN": "", "TCA": "", "ESAAPEN": "", "ESASEC1N": "", "ESASEC2N": "", "ESASEC3N": "", "ESASEC4N": "", "REGIMP": "11", "MONOREG": "1", "ZR3": "", "RPEN": "11", "DEPCOMEN": "93066", "VMAJ": "", "VMAJ1": "", "VMAJ2": "", "VMAJ3": "", "INDPUBLIPO": "1" }, "COMPLEMENTS": { "TELEPHONE": "0182462000", "SITE_WEB": "www.societedugrandparis.fr", "LATITUDE": 48.919329, "LONGITUDE": 2.354677 } }';
    
	public static User createTestUser(Id profID, String fName, String lName) {
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User tuser = new User(  Firstname = fName,
                                LastName = lName,
                                Email = uniqueName + '@testxx' + orgId + '.org',
                                Username = uniqueName + '@testxx' + orgId + '.org',
                                EmailEncodingKey = 'ISO-8859-1',
                                Alias = uniqueName.substring(18, 23),
                                TimeZoneSidKey = 'Europe/Paris',
                                LocaleSidKey = 'fr_FR_EURO',
                                LanguageLocaleKey = 'fr',
                                ProfileId = profId);
        return tuser;
    }   
    
    public static List<CustomRecordComparaison__mdt> generateTestCustomMetadataCastJSONToSObject(){
        
        
        List<CustomRecordComparaison__mdt> lstCRC = new List<CustomRecordComparaison__mdt>();
        if(!TEST_returnEmpty){
            lstCRC.add(new CustomRecordComparaison__mdt(
                        MappedField__c = 'Ext_Name',
                        SalesforceFieldAPIName__c = 'Name',
                        SalesforceObject__c = 'Account',
                        ToBeCastedIn__c = 'String')
                      );
            lstCRC.add(new CustomRecordComparaison__mdt(
                        MappedField__c = 'Ext_AnnualRevenue',
                        SalesforceFieldAPIName__c = 'AnnualRevenue',
                        SalesforceObject__c = 'Account',
                        ToBeCastedIn__c = 'Integer')
                      );
            lstCRC.add(new CustomRecordComparaison__mdt(
                        MappedField__c = 'Ext_ShippingPostalCode',
                        SalesforceFieldAPIName__c = 'ShippingPostalCode',
                        SalesforceObject__c = 'Account',
                        ToBeCastedIn__c = 'String')
                      );
            lstCRC.add(new CustomRecordComparaison__mdt(
                        MappedField__c = 'Ext_ShippingLongitude',
                        SalesforceFieldAPIName__c = 'ShippingLongitude',
                        SalesforceObject__c = 'Account',
                        ToBeCastedIn__c = 'Decimal')
                      );
            lstCRC.add(new CustomRecordComparaison__mdt(
                        MappedField__c = 'Ext_SIRET',
                        SalesforceFieldAPIName__c = 'SIRET__c',
                        SalesforceObject__c = 'Account',
                        ToBeCastedIn__c = 'String')
                      );
        }
        
        return lstCRC;
    }
}