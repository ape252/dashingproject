User.delete_all
User.create(name:'Admin', username: 'admin',email:'admin@qwinixtech.com',status:'active',user_type:'admin', password:"Password@1", password_confirmation:"Password@1")
User.all.each do |u|
  puts "User '#{u.name}' created"
end

Widget.delete_all
Widget.create(name:'Github-Status', widget_type: 'Github')
Widget.create(name:'Github-Open-PR', widget_type: 'Github')
Widget.create(name:'Github-Closed-PR', widget_type: 'Github')
Widget.create(name:'Github-Last-10-Commits', widget_type: 'Github')

Widget.create(name:'Sprint-remaning-days', widget_type: 'Jira')
Widget.create(name:'Sprint-progress', widget_type: 'Jira')
Widget.create(name:'Jira Stories Details', widget_type: 'Jira')
Widget.create(name:'Burn Down Chart', widget_type: 'Jira')

Widget.create(name:'GPA', widget_type: 'Code Climate')

Widget.create(name:'Build-test', widget_type: 'Jenkins')

Widget.create(name:'Error-Rate', widget_type: 'Newrelic')
Widget.create(name:'Response-Time', widget_type: 'Newrelic')


Widget.create(name:'sonar', widget_type: 'sonar')

Widget.create(name:'rally', widget_type: 'rally')
Widget.create(name:'rally1', widget_type: 'rally1')
Widget.create(name:'rally2', widget_type: 'rally2')



Widget.all.each do |u|
	puts "Widget '#{u.name}' created"
end