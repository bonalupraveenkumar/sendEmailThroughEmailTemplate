({
	doInit : function(component) {
        var folderList = component.get("c.getEmailFolderList");
        folderList.setCallback(this, function(response) {
            if(response.getState() == "SUCCESS") {
                var flist = response.getReturnValue();
                component.set("v.emailFolderList", flist);
            }
        });
        $A.enqueueAction(folderList);
    },
    getTemplate : function(component) {
        component.set("v.isProcessing", true);
        var folder_id = component.get("v.selectedFolder");
        var emailTemplate_List = component.get("c.getEmailTemplateList");
        emailTemplate_List.setParams({
            folder_id: folder_id
   		});
        emailTemplate_List.setCallback(this, function(response) {
            if(response.getState() == "SUCCESS") {
                var templateList = response.getReturnValue();
                component.set("v.emailTemplateList", templateList);
                component.set("v.isProcessing", false);
            } else {
                component.set("v.isProcessing", false);
            }
        });
        $A.enqueueAction(emailTemplate_List);
    },
    getTemp_Body : function(component) {
        component.set("v.isProcessing", true);
        var template_id = component.get("v.selectedEmailTemplate");
        var eTemplateBody = component.get("c.getTemplateBody");
        eTemplateBody.setParams({
            template_id: template_id
   		});
        eTemplateBody.setCallback(this, function(response) {
            if(response.getState() == "SUCCESS") {
                var t_body = response.getReturnValue();
                component.set("v.temp_Body", t_body.Body);
                component.set("v.templateSubject", t_body.Subject);
                component.set("v.isProcessing", false);
            } else {
                component.set("v.isProcessing", false);
            }
        });
        $A.enqueueAction(eTemplateBody);
    },
    sendEmail : function(component) {
        component.set("v.isProcessing", true);
        var etemplate_address = component.get("v.emailToAddress");
        alert(etemplate_address);
        var etemplate_Subject = component.get("v.templateSubject");
        var etemplate_Body = component.get("v.temp_Body");
        var send_EmailTemplate = component.get("c.sendEmailTemplate");
        send_EmailTemplate.setParams({
            etemplate_Subject: etemplate_Subject,
            etemplate_Body: etemplate_Body,
            etemplate_address: etemplate_address
   		});
        send_EmailTemplate.setCallback(this, function(response) {
            var sendStatus = response.getReturnValue();
            if(sendStatus == 'SUCCESS') {
                component.set("v.isSuccess", true);
                component.set("v.temp_Body", '');
                component.set("v.templateSubject", '');
                component.set("v.selectedEmailTemplate", '');
                component.set("v.emailToAddress", '');
                component.set("v.isProcessing", false);
            } else {
                component.set("v.isProcessing", false);
            }
        });
        $A.enqueueAction(send_EmailTemplate);
    }
})