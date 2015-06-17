function code_gpa_validator() {
 $('#form_rally_widget').validate({
  debug: true,
  rules: {
   "dashboard_widget[rally]": {
    required: true
  },
  "dashboard_widget[code_api_token]": {
    required:true
  }
},

errorElement: "span",

errorClass: "help-block",

messages: {
 "dashboard_widget[rally]" : {
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

