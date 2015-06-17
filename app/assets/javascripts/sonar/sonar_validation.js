function sonar_validator() {
 $('#form_sonar_widget').validate({
  debug: true,
  rules: {
   "dashboard_widget[matric]": {
    required: true
  },
  "dashboard_widget[key]": {
    required:true
  }
  "dashboard_widget[sonar_server]": {
    required:true
  }
},

errorElement: "span",

errorClass: "help-block",

messages: {
 "dashboard_widget[matric]" : {
  required: "This field is required"
},

"dashboard_widget[key]":{
  required: "This field is required"
  }

"dashboard_widget[sonar_server]":{
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

