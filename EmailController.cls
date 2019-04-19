public class EmailController {
	//Get Folder List
    @AuraEnabled
    public static List<Map<String, String>> getEmailFolderList() {
        List<Map<String, String>> gocFolderList = new List<Map<String, String>>();
        for(Folder gocFolderName : [SELECT id, Name FROM Folder WHERE Type = 'Email' ORDER BY Name]) {
            gocFolderList.add(new Map<String, String>{'value' => gocFolderName.Id, 'label' => gocFolderName.Name});
        }
        return gocFolderList;
    }
    //Get Template List
    @AuraEnabled
    public static List<Map<String, String>> getEmailTemplateList(String folder_id) {
        List<Map<String, String>> gocEmailTemplateList = new List<Map<String, String>>();
        for(EmailTemplate gocEmailTemplateName : [SELECT Id, Name, DeveloperName, FolderId FROM EmailTemplate WHERE FolderId =: folder_id ORDER BY Name]) {
            gocEmailTemplateList.add(new Map<String, String>{'value' => gocEmailTemplateName.Id, 'label' => gocEmailTemplateName.Name});
        }
        return gocEmailTemplateList;
    }
    //Get Template Body
    @AuraEnabled
    public static EmailTemplate getTemplateBody(String template_id) {
        return [SELECT Id, Name, Subject, Body FROM EmailTemplate WHERE id =: template_id];
    }
    //Send Email
    @AuraEnabled
    public static String sendEmailTemplate(String etemplate_Subject, String etemplate_Body, String etemplate_address) {
        System.debug('etemplate_Subject ' + etemplate_Subject);
        System.debug('etemplate_Body ' + etemplate_Body);
        System.debug('etemplate_address ' + etemplate_address);
        if(etemplate_Subject != '' && etemplate_Subject != null 
          	&& etemplate_Body != '' && etemplate_Body != null 
          	&& etemplate_address != '' && etemplate_address != null) {
            List<String> toaddress = new List<String>();
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address ='kansagaramarteen@yahoo.com'];
            if(etemplate_address.contains(',')) {
            	String[] toString = etemplate_address.split(',');
                for(String s : toString) {
                	toaddress.add(s);
                }
            } else {
            	toaddress.add(etemplate_address);
           	}
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            if(owea.size() > 0) {
            	email.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            email.setToAddresses(toaddress);
        	email.setSubject(etemplate_Subject);
        	email.setHtmlBody(etemplate_Body);
           	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
        	try {
            	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
                system.debug('===> Email Send');
        	} catch(exception e) {
            	system.debug('===> e ' + e.getMessage());
            }
            return 'SUCCESS';
		} else {
            return 'FAIL';   
		}
    }
}