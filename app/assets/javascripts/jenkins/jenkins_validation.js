function jenkins_validator() {
 $('#form_jenkins_widget').validate({
  debug: true,
  rules: {
   "dashboard_widget[jenkins_url]": {
    required: true
  },
  "dashboard_widget[jenkins_name]": {
    required:true
  },
  "dashboard_widget[jenkins_password]": {
    required: true
  }
},

errorElement: "span",

errorClass: "help-block",

messages: {
 "dashboard_widget[jenkins_url]" : {
  required: "This field is required"
},

"dashboard_widget[jenkins_name]":{
  required: "This field is required"
},

"dashboard_widget[jenkins_password]": {
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

