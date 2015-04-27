# require 'net/http'
# require 'json'

# Dashing.scheduler.every '10s', :first_in => 0 do |job|
#   # repo_id = "5406f507e30ba0542305e4e3"
#   # repo_id = "550134e1695680688f009211"
#   # api_token = "f21310bb41e60a6890ee27343c865c3dc4784434ab7d32a6590ca637344451e1"
#   # api_token = "255887c05d5a64ea167e4d3455f63d8f71574536"
#   unless $dashboard_widget_code.nil?
#     uri = URI.parse("https://codeclimate.com/api/repos/#{$dashboard_widget_code.code_repo_id}")
#     http = Net::HTTP.new(uri.host, uri.port)
#     http.use_ssl = true
#     request = Net::HTTP::Get.new(uri.request_uri)
#     request.set_form_data({api_token: $dashboard_widget_code.code_api_token})
#     response = http.request(request)
#     stats = JSON.parse(response.body)
#     current_gpa = stats['last_snapshot']['gpa'].to_f
#     app_name = stats['name']
#     covered_percent = stats['last_snapshot']['covered_percent'].to_f
#     last_gpa = stats['previous_snapshot']['gpa'].to_f
#     Dashing.send_event("code-climate", {current: current_gpa, last: last_gpa, name: app_name, percent_covered: covered_percent })
#   end
# end