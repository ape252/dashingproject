$(".event-panels").click(function() {
   $(".active").removeClass("active");
  $(this).addClass("active");
});

function fnCountItem (_name) {
 if($("#"+ _name ).hasClass("selected")){
   $("#"+ _name).find("div.number-of-widgets").html($("#"+_name+"-widget input[type='checkbox']:checked").length +  " item(s) selected");
 }
}

$(document).on("change", "#git-widget input[type='checkbox'], #jira-widget input[type='checkbox'], #jenkins-widget input[type='checkbox'], #newrelic-widget input[type='checkbox'], #code-widget input[type='checkbox'] ", function () {
    fnCountItem(this.parentNode.parentNode.parentElement.id.split("-")[0]);
});

setTimeout(function(){
    $('#flash').remove();
  }, 5000);