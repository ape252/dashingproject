module Newrelic
	extend ActiveSupport::Concern

	def newrelic_job(obj)
		# Newrelic API key
		key = obj["jira_url"]

		# Monitored application
		app_name = obj["jira_view_id"]

		# Emitted metrics:
		# - rpm_apdex
		# - rpm_error_rate
		# - rpm_throughput
		# - rpm_errors
		# - rpm_response_time
		# - rpm_db
		# - rpm_cpu
		# - rpm_memory

		NewRelicApi.api_key = key

		Dashing.scheduler.every '5m', :first_in => 0 do |job|
			app = NewRelicApi::Account.first.applications.select { |el|
				el.name == app_name
				}.first

				app.threshold_values.each do |v|
					Dashing.send_event("rpm#{obj['dashboard_id']}_" + v.name.downcase.gsub(/ /, '_'), { current: v.metric_value })
				end
			end
		end
	end