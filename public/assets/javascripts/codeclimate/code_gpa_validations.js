function code_gpa_validator() {
 $('#form_code_gpa_widget').validate({
  debug: true,
  rules: {
   "dashboard_widget[code_repo_id]": {
    required: true
  },
  "dashboard_widget[code_api_token]": {
    required:true
  }
},

errorElement: "span",

errorClass: "help-block",

messages: {
 "dashboard_widget[code_repo_id]" : {
  required: "This field is required"
},

"dashboard_widget[code_api_token]":{
  required: "This field is required"
  }
},
highlight: function(element) {
 $(element).parent().parent().addClass("has-error");
},

unhighlight: function(element) {
 $(element).parent().parent().removeClass("has-error");
},

      submitHandler: function(form){
      $(form)
      .submit()
      .always(function(){ hideLoadingScreen() });
      }
     });

}

