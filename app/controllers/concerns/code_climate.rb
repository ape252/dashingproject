module CodeClimate
  extend ActiveSupport::Concern

  def gpa(obj)
<<<<<<< Updated upstream
    Dashing.scheduler.every '10s', :first_in => 0 do |job|
=======
    Dashing.scheduler.every '5s', :first_in => 0 do |job|
>>>>>>> Stashed changes
      uri = URI.parse("https://codeclimate.com/api/repos/#{obj['code_repo_id']}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(uri.request_uri)
      request.set_form_data({api_token: obj['code_api_token']})
      response = http.request(request)
      stats = JSON.parse(response.body)
      current_gpa = stats['last_snapshot']['gpa'].to_f
      app_name = stats['name']
      covered_percent = stats['last_snapshot']['covered_percent'].to_f
      last_gpa = stats['previous_snapshot']['gpa'].to_f
      Dashing.send_event("code-climate_#{obj['dashboard_id']}", {current: current_gpa, last: last_gpa, name: app_name, percent_covered: covered_percent })
    end   
  end
end  