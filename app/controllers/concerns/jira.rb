module Jira
  extend ActiveSupport::Concern
  def sprint_progress(obj)
    host = obj["jira_url"]
    username = obj["jira_name"]
    password = obj["jira_password"]
    project = obj["jira_project_key"]
    resolved = "RESOLVED"
    done = "DONE"
    closed = "CLOSED"

    sprint_name = obj["jira_view_id"]

    options = {
      :username => username,
      :password => password,
      :context_path => '',
      :site     => host,
      :auth_type => :basic
    }

    Dashing.scheduler.every '5m', :first_in => 0 do |job|

      client = JIRA::Client.new(options)
      total_points = 0;
      client.Issue.jql("PROJECT = \"#{project}\" AND SPRINT = \"#{sprint_name}\"").each do |issue|
        total_points+=1
      end
      closed_points = 0;
      client.Issue.jql("PROJECT = \"#{project}\" AND SPRINT = \"#{sprint_name}\" AND STATUS = \"#{resolved}\"").each do |issue|
        closed_points+=1
      end
      client.Issue.jql("PROJECT = \"#{project}\" AND SPRINT = \"#{sprint_name}\" AND STATUS = \"#{done}\"").each do |issue|
        closed_points+=1
      end
      client.Issue.jql("PROJECT = \"#{project}\" AND SPRINT = \"#{sprint_name}\" AND STATUS = \"#{closed}\"").each do |issue|
        closed_points+=1
      end

      if total_points == 0
        percentage = 0
        moreinfo = "No sprint currently in progress"
      else
        percentage = (((closed_points/1.0)/(total_points/1.0))*100).to_i
        moreinfo = "#{closed_points.to_i} / #{total_points.to_i}"
      end

      Dashing.send_event("sprint_progress_#{obj['dashboard_id']}", { title: "Sprint Progress", min: 0, value: percentage, max: 100, moreinfo: moreinfo })
    end
  end

  def sprint_remaining_days(obj)
    @jira_uri = URI.parse(obj["jira_url"])

    @jira_auth = {
      'name' => obj["jira_name"],
      'password' => obj["jira_password"]
    }

    view_mapping = {
      "view#{obj['dashboard_id']}" => { :view_id => obj["jira_view_id"].to_i },
    }

    def get_view_for_viewid(view_id)
      http = create_http
      request = create_request("/rest/greenhopper/1.0/rapidviews/list")
      response = http.request(request)
      views = JSON.parse(response.body)['views']
      views.each do |view|
        if view['id'] == view_id
          return view
        end
      end
    end

    def get_active_sprint_for_view(view_id)
      http = create_http
      request = create_request("/rest/greenhopper/1.0/sprintquery/#{view_id}")
      response = http.request(request)
      sprints = JSON.parse(response.body)['sprints']
      sprints.each do |sprint|
        if sprint['state'] == 'ACTIVE'
          return sprint
        end
      end
    end

    def get_remaining_days(view_id, sprint_id)
      http = create_http
      request = create_request("/rest/greenhopper/1.0/gadgets/sprints/remainingdays?rapidViewId=#{view_id}&sprintId=#{sprint_id}")
      response = http.request(request)
      JSON.parse(response.body)
    end

    def create_http
      http = Net::HTTP.new(@jira_uri.host, @jira_uri.port)
      if ('https' == @jira_uri.scheme)
        http.use_ssl     = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      return http
    end

    def create_request(path)
      request = Net::HTTP::Get.new(@jira_uri.path + path)
      if @jira_auth['name']
        request.basic_auth(@jira_auth['name'], @jira_auth['password'])
      end
      return request
    end

    view_mapping.each do |view, view_id|
      Dashing.scheduler.every '5m', :first_in => 0 do |id|
        view_name = ""
        sprint_name = ""
        days = ""
        view_json = get_view_for_viewid(view_id[:view_id])
        if (view_json)
          view_name = view_json['name']
          sprint_json = get_active_sprint_for_view(view_json['id'])
          if (sprint_json)
            sprint_name = sprint_json['name']
            days_json = get_remaining_days(view_json['id'], sprint_json['id'])
            days = days_json['days']
          end
        end
        Dashing.send_event(view, {
          viewName: view_name,
          sprintName: sprint_name,
          daysRemaining: days
          })
      end
    end
  end

  def number_of_open_issues(obj)
    host = obj["jira_url"]
    username = obj["jira_name"]
    password = obj["jira_password"]
    project = obj["jira_project_key"]
    to_do = "TO DO"
    open = "OPEN"
    reopened = "REOPENED"
    in_progress = "IN PROGRESS"
    dev_done = "DEV DONE"
    qa = "READY FOR QA"
    uat = "UAT"
    resolved = "RESOLVED"
    done = "DONE"
    closed = "CLOSED"

    sprint_name = obj["jira_view_id"]

    options = {
      :username => username,
      :password => password,
      :context_path => '',
      :site     => host,
      :auth_type => :basic
    }

    Dashing.scheduler.every '5m', :first_in => 0 do |job|

      client = JIRA::Client.new(options)
      todo_count = 0;
      client.Issue.jql("PROJECT = \"#{project}\" AND STATUS = \"#{to_do}\" AND SPRINT = \"#{sprint_name}\"").each do |issue|
        todo_count+=1
      end
      open_count = 0;
      client.Issue.jql("PROJECT = \"#{project}\" AND STATUS = \"#{open}\" AND SPRINT = \"#{sprint_name}\"").each do |issue|
        open_count+=1
      end
      reopened_count = 0;
      client.Issue.jql("PROJECT = \"#{project}\" AND STATUS = \"#{reopened}\" AND SPRINT = \"#{sprint_name}\"").each do |issue|
        reopened_count+=1
      end
      in_progress_count = 0;
      client.Issue.jql("PROJECT = \"#{project}\" AND STATUS = \"#{in_progress}\" AND SPRINT = \"#{sprint_name}\"").each do |issue|
        in_progress_count+=1
      end
      dev_done_count = 0;
      client.Issue.jql("PROJECT = \"#{project}\" AND STATUS = \"#{dev_done}\" AND SPRINT = \"#{sprint_name}\"").each do |issue|
        dev_done_count+=1
      end
      qa_count = 0;
      client.Issue.jql("PROJECT = \"#{project}\" AND STATUS = \"#{qa}\" AND SPRINT = \"#{sprint_name}\"").each do |issue|
        qa_count+=1
      end
      uat_count = 0;
      client.Issue.jql("PROJECT = \"#{project}\" AND STATUS = \"#{uat}\" AND SPRINT = \"#{sprint_name}\"").each do |issue|
        uat_count+=1
      end
      resolved_count = 0;
      client.Issue.jql("PROJECT = \"#{project}\" AND STATUS = \"#{resolved}\" AND SPRINT = \"#{sprint_name}\"").each do |issue|
        resolved_count+=1
      end
      done_count = 0;
      client.Issue.jql("PROJECT = \"#{project}\" AND STATUS = \"#{done}\" AND SPRINT = \"#{sprint_name}\"").each do |issue|
        done_count+=1
      end
      closed_count = 0;
      client.Issue.jql("PROJECT = \"#{project}\" AND STATUS = \"#{closed}\" AND SPRINT = \"#{sprint_name}\"").each do |issue|
        closed_count+=1
      end
      total_points = todo_count + open_count + reopened_count + in_progress_count + done_count + dev_done_count + qa_count + uat_count + resolved_count
      Dashing.send_event("jira#{obj['dashboard_id']}", { title: "Jira Story Details", todo: todo_count, open: open_count, reopened: reopened_count, inprogress: in_progress_count, qa: qa_count, uat: uat_count, dev_done: dev_done_count, resolved:resolved_count, done: done_count, closed: closed_count, total: total_points })
    end
  end
end