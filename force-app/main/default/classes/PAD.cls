/*
//Apex Class 
----------------------------------------------------------------------
-- - Name          : PAD
-- - Author        : Mélanie TEXEREAU - Bluetis
-- - Description   : class PAD
-- - Module        : CRM Mirion
--
-- Maintenance History:
--
-- Date         Name  Version  Remarks  
-- -----------  ----  -------  ---------------------------------------
-- 30-AUG-2016   MTE    1.0      Initial version
----------------------------------------------------------------------
*/

public with sharing class PAD {
  public static final string BypassTrigger;
  public static boolean BypassValidationRule;
  private static final Set<String> requiredOnce=new Set<String>{};//List of Apex codes that should run only once. Add any code to the list
  public static Set<String>hasRun=new Set<String>();//List of Apex code that has already been run. Keep this list empty.
  public static boolean flag;
  //flag to check used in MoveDown()
  public static boolean FlagCheckDown=false;
  public static boolean FlagCheckMoveChapitre=false;
  public static boolean FlagCheckDelete=false;
  public static boolean FlagCheckUptPro=false;
  public static boolean FlagCheckUptProDown=false;
  public static boolean FlagCheckAllPoste=false;
  public static boolean FlagCheckAllPosteDelete=false;
  ///Flag on Insert to block trigger update
  public static boolean FlagNiveauInsert=false;
  public static boolean FlagNumeroPrixInsert=false;
  public static boolean FlagSTInsert=false;
  public static boolean FlagOLInsert=false;
  public static boolean FlagPosInsert=false;
  public static boolean FlagTotalInsert=false;
  public static boolean FlagTest=false;
  public static boolean FlagDevisCmd=false;
   
  public static boolean FlagChapitreMove=false; 
    static{
      flag=false;
      System.Debug('## >>> PAD constructor :BEGIN <<< run by ' + UserInfo.getName());
      User user = [Select ByPass_Trigger__c, ByPass_VR__c from User where Id =:UserInfo.getUserId() limit 1];
      BypassTrigger = ';' + user.ByPass_Trigger__c + ';';
      BypassValidationRule = user.ByPass_VR__c;
      System.Debug('## >>> BypassTrigger: '+BypassTrigger);
      System.Debug('## >>> PAD constructor : END <<<');
    }
    
  public static boolean canTrigger(string ApexName){ //If no bypass
    if(requiredOnce.contains(ApexName)){//If it should run Once
      if(hasRun.contains(ApexName))return false;//Already run, should not run
        hasRun.add(ApexName);//Never run, can run only if not bypassed
      }
    return(BypassTrigger.indexOf(';'+ApexName+';')==-1);
  }
}