require 'sinatra'
require 'mixpanel_client'
require 'json'

get '/mixpanel' do

	api_key = params[:api_key]
	api_secret = params[:api_secret]
	event = params[:event]
	on_prop = params[:on]
	title = params[:title]

	limit = 50
	if params[:limit]
		limit = params[:limit]
	end

	type = 'general'
	if params[:type]
		type = params[:type]
	end

	config = {api_key: api_key, api_secret: api_secret}
	client = Mixpanel::Client.new(config)

	t = Time.now
	today_date_string = t.strftime("%Y-%m-%d")  

    response = "80%,20%\n#{title},\n"
	data = client.request('segmentation', {
	  event:     event,
	  name:      'feature',
	  limit:     limit,
	  type:      type,
	  from_date: today_date_string,
	  to_date:   today_date_string,
	  on:        'properties["' + on_prop + '"]'
	})

	date_string = data["data"]["series"][0]
	
	array_to_sort = []
	data["data"]["values"].each do |prop, value|
		array_to_sort.push(Hash[:prop => prop, :launches => value[date_string]])
	end

	array_to_sort.sort_by { |hsh| hsh[:launches] }.reverse.each do |hsh|
		response += "#{hsh[:prop]},#{hsh[:launches]}\n"
	end

	response
end