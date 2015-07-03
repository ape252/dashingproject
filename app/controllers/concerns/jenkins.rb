module Jenkins
	extend ActiveSupport::Concern
	def jenkins_build_status(obj)
		@jenkins_rui = obj["jenkins_url"]

		@jenkins_auth = {
			'name' => obj["jenkins_name"],
			'password' => obj["jenkins_password"]
		}

		Dashing.scheduler.every '1m' do

			json = getFromJenkins(@jenkins_rui + 'api/json?pretty=true')

			failedJobs = Array.new
			succeededJobs = Array.new
			array = json['jobs']
			array.each {
				|job|

				next if job['color'] == 'disabled'
				next if job['color'] == 'notbuilt'
				next if job['color'] == 'blue'
				next if job['color'] == 'blue_anime'

				jobStatus = '';
				if job['color'] == 'yellow' || job['color'] == 'yellow_anime'
					jobStatus = getFromJenkins(job['url'] + 'lastUnstableBuild/api/json')
				elsif job['color'] == 'aborted'
					jobStatus = getFromJenkins(job['url'] + 'lastUnsuccessfulBuild/api/json')
				else
					jobStatus = getFromJenkins(job['url'] + 'lastFailedBuild/api/json')
				end

				culprits = jobStatus['culprits']

				culpritName = getNameFromCulprits(culprits)
				if culpritName != ''
					culpritName = culpritName.partition('<').first
				end

				failedJobs.push({ label: job['name'], value: culpritName})
			}

			failed = failedJobs.size > 0

			Dashing.send_event("jenkinsBuildStatus#{obj['dashboard_id']}", { failedJobs: failedJobs, succeededJobs: succeededJobs, failed: failed })
		end
	end

	def getFromJenkins(path)

		uri = URI.parse(path)
		http = Net::HTTP.new(uri.host, uri.port)
		request = Net::HTTP::Get.new(uri.request_uri)
		if @jenkins_auth['name']
			request.basic_auth(@jenkins_auth['name'], @jenkins_auth['password'])
		end
		response = http.request(request)

		json = JSON.parse(response.body)
		return json
	end

	def getNameFromCulprits(culprits)
		culprits.each {
			|culprit|
			return culprit['fullName']
		}
		return ''
	end

end