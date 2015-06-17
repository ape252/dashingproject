module Sonar
	extend ActiveSupport::Concern

	def sonar(obj)
		server = "#{obj["sonar_server"]}"
		key = "#{obj["key"]}"
		metrics = "#{obj["metrics"]}".join(',')
		id = id"sonar#{obj['dashboard_id']}"

		Dashing.scheduler.every  '10s', :first_in => 0 do |job|
			uri = URI("#{server}/api/resources?resource=#{key}&metrics=#{metrics}&format=json")
			res = Net::HTTP.get(uri)
			j = JSON[res][0]['msr']

			send_event(sonar, { items: 
				[{ label: 'Metric 1', value: j[0]['val'] },
				{label:'Metric 2', value:j[1]['val']},
				{label:'Metric n', value:j[n]['val']}
				]})
		end
	end
end