class Admin::DashboardWidgetsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
  end

  def new
    @dashboard = Dashboard.find_by_id params[:dashboard_id]
    @dw = DashboardWidget.all
    @dashboard_widget = DashboardWidget.new
    @widgets = Widget.all
    @github_widgets = @widgets.all.select{|w|w.name if w.widget_type=='Github'}
    @jira_widgets = @widgets.all.select{|w|w.name if w.widget_type=='Jira'}
    @code_widgets = @widgets.all.select{|w|w.name if w.widget_type=='Code Climate'}
    @jenkins_widgets = @widgets.all.select{|w|w.name if w.widget_type=='Jenkins'}
  end

  def create
    @dashboard = Dashboard.find_by_id params[:dashboard_id]
    @dashboard.widgets.destroy_all
    @dashboard_widget = DashboardWidget.new
    @dashboard_widget.savewidgets(widget_params, @dashboard)
    if @dashboard_widget.valid?
      @success = true
    else
      @success = false
    end
  end

  def edit
    @dashboard = Dashboard.find_by_id params[:dashboard_id]
    @widget = Widget.find_by_id params[:id]
    @dashboard_widget = DashboardWidget.find_by_widget_id(@widget.id)
  end

  def update
    @widget = Widget.find_by_id params[:id]
    @dashboard_widget = DashboardWidget.find_by_widget_id(@widget.id)
    @dashboard_widget.access_token = params[:dashboard_widget][:access_token]
    @dashboard_widget.organization_name = params[:dashboard_widget][:organization_name]
    @dashboard_widget.repo_name = params[:dashboard_widget][:repo_name]
    @dashboard_widget.status = params[:dashboard_widget][:status]
    @dashboard_widget.github_url = params[:dashboard_widget][:github_url]
    @dashboard_widget.code_api_token = params[:dashboard_widget][:code_api_token]
    @dashboard_widget.code_repo_id = params[:dashboard_widget][:code_repo_id]
    @dashboard_widget.jira_url = params[:dashboard_widget][:jira_url]
    @dashboard_widget.jira_view_id = params[:dashboard_widget][:jira_view_id]
    @dashboard_widget.jira_name = params[:dashboard_widget][:jira_name]
    @dashboard_widget.jira_password = params[:dashboard_widget][:jira_password]
    @dashboard_widget.jira_project_key = params[:dashboard_widget][:jira_project_key]
    if @dashboard_widget.valid?
      @dashboard_widget.save
      @success = true
    else
      @success = false
    end
  end

  def destroy
    @dashboard = Dashboard.find_by_id params[:dashboard_id]
    @widget = Widget.find_by_id params[:id]
    @dashboard_widget = DashboardWidget.find_by_widget_id @widget.id
    @dashboard_widget.destroy
  end

  def update_widgets
    dashboard = Dashboard.find_by_id params[:dashboard_id]
    if dashboard.present?
      params[:widget_ids].each do |widget_id|
        widget = Widget.find_by_id widget_id
        dashboard.widgets << dashboard if widget.present?
      end
    end
  end

  private

  def resource_url(obj)
    url_for([:admin, obj])
  end

  def default_item_name
    "dashboard_widget"
  end

  def widget_params
    [params["gitwidget"],params["jirawidget"],params["codewidget"],params["jenkinswidget"]].compact.reduce([], :|)
  end

  def set_navs
    set_nav("admin/dashboard_widgets")
  end

end