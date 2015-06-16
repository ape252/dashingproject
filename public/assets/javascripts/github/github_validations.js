function github_validator() {
 $('#form_github_widget').validate({
  debug: true,
  rules: {
   "dashboard_widget[access_token]": {
    required: true
  },
  "dashboard_widget[organization_name]": {
    required:true
  },
  "dashboard_widget[repo_name]": {
    required: true
  }
},

errorElement: "span",

errorClass: "help-block",

messages: {
 "dashboard_widget[access_token]" : {
  required: "This field is required"
},

"dashboard_widget[organization_name]":{
  required: "This field is required"
},

"dashboard_widget[repo_name]": {
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

