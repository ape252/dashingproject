# require 'jira'

# host = "https://qwinix.atlassian.net"
# # username = "anjankumarhn"
# # password = "nenapu khushi"
# status = "OPEN"


# unless $dashboard_widget_jira_project_key.nil?

#   options = {
#     :username => $dashboard_widget_jira_project_key.username,
#     :password => $dashboard_widget_jira_project_key.password,
#     :context_path => '',
#     :site     => host,
#     :auth_type => :basic
#   }
#   Dashing.scheduler.every '5s', :first_in => 0 do |job|

#     client = JIRA::Client.new(options)
#     num = 0;
#     client.Issue.jql("PROJECT = \"#{$dashboard_widget_jira_project_key.jira_project_key}\" AND STATUS = \"#{status}\"").each do |issue|
#       num+=1

#     end

#     Dashing.send_event('jira', { current: num })
#   end
# end