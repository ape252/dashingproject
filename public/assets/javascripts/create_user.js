function CreateUserValidator() {

 jQuery.validator.addMethod("pswd_match",function (value,element){
  return $("#user_password").val() == $('#user_password_confirmation').val();
});

 $('#create_user').validate({
  debug: true,
  rules: {
    "user[name]": {
      required:true
    },
    "user[email]": {
     email: true,
     required: true,
     remote: "/users/unique_email"
   },
   "user[password]" : {
    required: true,
  },
  "user[password_confirmation]": {
    required:true,
    pswd_match: true
  }
},

errorElement: "span",
errorClass: "help-block",

messages: {
 "user[name]":{
  required: "This field is required!"
},
"user[email]": {
  required: "This field is required!",
  email: "Please enter a valid E-Mail address!",
  remote: "Email has been already taken!"
},
"user[password]": {
  required:"This field is required!",
},
"user[password_confirmation]": {
  required: "This field is required!",
  pswd_match: "Password does not match!"
}
},

highlight: function(element) {
 $(element).parent().parent().addClass("has-error");
},

unhighlight: function(element) {
 $(element).parent().parent().removeClass("has-error");
},

invalidHandler: function(event, validator) {
        // 'this' refers to the form
        var errors = validator.numberOfInvalids();
        if (errors) {

          // Populating error message
          var errorMessage = errors == 1
          ? 'You missed 1 field. It has been highlighted'
          : 'You missed ' + errors + ' fields. They have been highlighted';

          // Removing the form error if it already exists
          $("#div_user_js_validation_error").remove();

          errorHtml = "<div id='div_user_js_validation_error' class=\"alert alert-danger\" data-alert=\"alert\" style=\"margin-bottom:5px;\">"+ errorMessage +"</div>"
          //$("#div_user_details").prepend(errorHtml);
          $("#div_modal_generic div.modal-body-main").prepend(errorHtml);

          // Show error labels
          $("div.error").show();

        } else {
          // Hide error labels
          $("div.error").hide();
          // Removing the error message
          $("#div_user_js_validation_error").remove();
        }

      },
      submitHandler: function(form){
      showLoadingScreen();
      $(form)
      .submit()
      .always(function(){ hideLoadingScreen() });
      }
    });

}