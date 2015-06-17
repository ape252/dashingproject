module Dashing
  class DashboardsController < ApplicationController
    require 'octokit'
    require 'httparty'
    require 'net/http'
    require 'json'
    require 'jira'
    require 'time'
    require 'newrelic_api'
    require 'open-uri'
    require 'cgi'

    include GitHub
    include CodeClimate
    include Jira
    include Jenkins
    include Newrelic
    include BurnDownChart
    include Sonar

    before_filter :check_dashboard_name, only: :show

    rescue_from ActionView::MissingTemplate, with: :template_not_found

    def index
      get_the_job_done(params[:dashboard_id])
      render file: dashboard_path(Dashing.config.default_dashboard || Dashing.first_dashboard || ''), layout: Dashing.config.dashboard_layout_path
    end

    def show
      render file: dashboard_path(params[:name]), layout: Dashing.config.dashboard_layout_path
    end

    private

    def check_dashboard_name
      raise 'bad dashboard name' unless params[:name] =~ /\A[a-zA-z0-9_\-]+\z/
    end

    def dashboard_path(name)
      Dashing.config.dashboards_views_path.join(name)
    end

    def template_not_found
      raise "Count not find template for dashboard '#{params[:name]}'. Define your dashboard in #{dashboard_path('')}"
    end

    def get_the_job_done(id)
      @json_obj = []
      dashboard = Dashboard.find id
      dashboard.dashboard_widgets.each do |dash_wid|
        @json_obj << JSON.parse(dash_wid.to_json).compact
      end   
      @json_obj.each do |obj|
        case (Widget.find obj["widget_id"]).name 
        when "Github-Open-PR" 
          github_open_pr_job(obj) if obj["status"] == "configured"
        when "Github-Closed-PR" 
          github_closed_pr_job(obj) if obj["status"] == "configured"
        when "GPA" 
          gpa(obj) if obj["status"] == "configured"
        when "Github-Status" 
          github_status(obj) if obj["status"] == "configured"
        when "Sprint-progress" 
          sprint_progress(obj) if obj["status"] == "configured"
        when "Sprint-remaning-days" 
          sprint_remaining_days(obj) if obj["status"] == "configured"
        when "Jira Stories Details" 
          number_of_open_issues(obj) if obj["status"] == "configured" 
        when "Build-test" 
          jenkins_build_status(obj) if obj["status"] == "configured"
        when "Github-Last-10-Commits" 
          github_commits(obj) if obj["status"] == "configured"
        when "Error-Rate" 
          newrelic_job(obj) if obj["status"] == "configured"
        when "Response-Time" 
          newrelic_job(obj) if obj["status"] == "configured"
        when "sonar" 
          sonar(obj) if obj["status"] == "configured"
        when "Burn Down Chart" 
          BurnDown.burn_down_chart(obj) if obj["status"] == "configured"
        end
      end
    end
  end
end