module Sonar
	extend ActiveSupport::Concern

	def sonar(obj)
		server = "#{obj["sonar_server"]}"
		key = "#{obj["key"]}"
		# binding.pry
		metrics = "#{obj["matric"]}"
		id = "idsonar#{obj['dashboard_id']}"
		Dashing.scheduler.every  '5m', :first_in => 0 do |job|
			uri = URI("#{server}/api/resources?resource=#{key}&metrics=#{metrics}&format=json")
			res = Net::HTTP.get(uri)
			j = JSON[res][0]['msr']

			send_event(id, { items: 
				[{ label: 'Metric 1', value: j[0]['val'] },
				{label:'Metric 2', value:j[1]['val']},
				{label:'Metric n', value:j[n]['val']}
				]})
		end
	end
end