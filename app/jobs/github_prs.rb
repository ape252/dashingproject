# require 'octokit'


# Dashing.scheduler.every '15s', :first_in => 0 do |job|

#   if $dashboard_widget_github.present? && $dashboard_widget_github.github_status_prs == 'open'
    
#     client = Octokit::Client.new(:access_token => $dashboard_widget_github.access_token)
#     my_organization = $dashboard_widget_github.organization_name
#     repos = client.organization_repositories(my_organization).map { |repo| repo.name }

#     open_pull_requests = repos.inject([]) { |pulls, repo|
#       client.pull_requests("#{my_organization}/#{$dashboard_widget_github.repo_name}", :state => 'open').each do |pull|
#         pulls.push({
#           title: pull.title,
#           repo: $dashboard_widget_github.repo_name,
#           updated_at: pull.updated_at.strftime("%b %-d %Y, %l:%m %p"),
#           creator: "@" + pull.user.login,
#           })
#       end
#       pulls
#     }
#     Dashing.send_event('open_pull_requests', { header: "Open Pull Requests", pulls: open_pull_requests })
#   else
#     client = Octokit::Client.new(:access_token => $dashboard_widget_github.access_token)
#     my_organization = $dashboard_widget_github.organization_name
#     repos = client.organization_repositories(my_organization).map { |repo| repo.name }

#     close_pull_requests = repos.inject([]) { |pulls, repo|
#       client.pull_requests("#{my_organization}/#{$dashboard_widget_github.repo_name}", :state => 'close').each do |pull|
#         pulls.push({
#           title: pull.title,
#           repo: $dashboard_widget_github.repo_name,
#           updated_at: pull.updated_at.strftime("%b %-d %Y, %l:%m %p"),
#           creator: "@" + pull.user.login,
#           })
#       end
#       pulls
#     }
#     Dashing.send_event('closed_pull_requests', { header: "Closed Pull Requests", pulls: close_pull_requests })
#   end
# end

