function jira_validator() {
 $('#form_jira_widget').validate({
  debug: true,
  rules: {
  "dashboard_widget[jira_url]": {
    required: true
  },
   "dashboard_widget[jira_view_id]": {
    required: true
  },
  "dashboard_widget[jira_name]": {
    required:true
  },
  "dashboard_widget[jira_password]": {
    required: true
  }
},

errorElement: "span",

errorClass: "help-block",

messages: {
"dashboard_widget[jira_url]" : {
  required: "This field is required"
},

 "dashboard_widget[jira_view_id]" : {
  required: "This field is required"
},

"dashboard_widget[jira_name]":{
  required: "This field is required"
},

"dashboard_widget[jira_password]": {
  required: "This field is required",
  }
},


highlight: function(element) {
 $(element).parent().parent().addClass("has-error");
},

unhighlight: function(element) {
 $(element).parent().parent().removeClass("has-error");
},

      submitHandler: function(form){
      showLoadingScreen();
      $(form)
      .submit()
      .always(function(){ hideLoadingScreen() });
      }
     });

}