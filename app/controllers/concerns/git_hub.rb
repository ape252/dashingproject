module GitHub

  extend ActiveSupport::Concern

  def github_commits(obj)
    Dashing.scheduler.every '1m', :first_in => 0 do |job|
      client = Octokit::Client.new(:access_token => obj["access_token"])
      githubcommits = client.list_commits("#{obj["organization_name"]}/#{obj["repo_name"]}").map do |commit_obj|
       { 
        title: commit_obj.commit.message,
        repo: "#{obj["repo_name"]}", 
        creator: commit_obj.commit.author.name, 
        updated_at: commit_obj.commit.author.date
      }
    end
    Dashing.send_event("commits#{obj['dashboard_id']}", { header: "Github Commits", pulls: githubcommits })
  end
end

def github_status(obj)
  @traffic_lights = {
    'good' => 'green',
    'minor' => 'amber',
    'major' => 'red'
  }
    # GITHUB_STATUS_URI = obj["github_url"].to_str
    Dashing.scheduler.every '1m', :first_in => 0 do
      response = HTTParty.get("https://status.github.com/api/last-message.json")
      data = {
        status: @traffic_lights[response["status"]],
        message: response["body"]
      }
      Dashing.send_event("traffic-lights_#{obj['dashboard_id']}", data)
    end
  end

  def github_open_pr_job(obj)
    Dashing.scheduler.every '1s', :first_in => 0 do |job|
      client = Octokit::Client.new(:access_token => obj["access_token"])
      my_organization = obj["organization_name"]

      repos = client.organization_repositories(my_organization).map { |repo| repo.name }

      open_pull_requests = repos.inject([]) { |pulls, repo|
        if repo==obj["repo_name"]
          client.pull_requests("#{my_organization}/#{repo}", :state => 'open').each do |pull|
            pulls.push({
              title: pull.title,
              repo: repo,
              updated_at: pull.updated_at.strftime("%b %-d %Y, %l:%m %p"),
              creator: "@" + pull.user.login,
              })
          end
        end
        pulls[0..3]
      }
      Dashing.send_event("open_pr_#{obj['dashboard_id']}", { header: "Open Pull Requests", pulls: open_pull_requests })
    end
  end

  def github_closed_pr_job(obj)
    Dashing.scheduler.every '5m', :first_in => 0 do |job|
      client = Octokit::Client.new(:access_token => obj["access_token"])
      my_organization = obj["organization_name"]
      repos = client.organization_repositories(my_organization).map { |repo| repo.name }

      closed_pull_requests = repos.inject([]) { |pulls, repo|
        client.pull_requests("#{my_organization}/#{repo}", :state => 'close').each do |pull|
          if repo==obj["repo_name"]
            pulls.push({
              title: pull.title,
              repo: repo,
              updated_at: pull.updated_at.strftime("%b %-d %Y, %l:%m %p"),
              creator: "@" + pull.user.login,
              })
          end
        end
        pulls[0..3]
      }

      Dashing.send_event("closed_pr_#{obj['dashboard_id']}", { header: "Closed Pull Requests", pulls: closed_pull_requests })
    end
  end

end