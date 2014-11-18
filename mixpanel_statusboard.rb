require 'sinatra'
require 'mixpanel_client'
require 'json'

get '/mixpanel_html' do
	api_key = params[:api_key]
	api_secret = params[:api_secret]
	event = params[:event]

	event_type = 'general'
	if params[:event_type]
		event_type = params[:event_type]
	end

	title = params[:title]
	width = 698
	height = 506

	if params[:width]
		width = params[:width]
	end

	if params[:height]
		height = params[:height]
	end

	html = "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">
<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"en\" lang=\"en\">
	<head>
		<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf8\" />
		<meta http-equiv=\"Cache-control\" content=\"no-cache\" />

		<style type=\"text/css\">
			@font-face
			{
				font-family: \"Roadgeek2005SeriesD\";
				src: url(\"http://panic.com/fonts/Roadgeek 2005 Series D/Roadgeek 2005 Series D.otf\");
			}

			body, *
			{

			}
			body,div,dl,dt,dd,ul,ol,li,h1,h2,h3,h4,h5,h6,pre,form,fieldset,input,textarea,p,blockquote,th,td
			{
				margin: 0;
				padding: 0;
			}

			fieldset,img
			{
				border: 0;
			}


			/* Settin' up the page */

			html, body, #main
			{
				overflow: hidden; /* */
			}

			body
			{
				color: white;
				font-family: 'Roadgeek2005SeriesD', sans-serif;
				font-size: 20px;
				line-height: 24px;
			}
			body, html, #main
			{
				background: transparent !important;
			}

			#spacepeopleContainer
			{
				width: #{width}px;
				height: #{height}px;
				text-align: center;
			}
			#spacepeopleContainer *
			{
				font-weight: normal;
			}

			h1
			{
				font-size: 240px;
				line-height: 240px;
				margin-top: 15px;
				margin-bottom: 28px;
				color: white;
				text-shadow:0px -2px 0px black;
				text-transform: uppercase;
			}

			h2
			{
				width: 180px;
				margin: 0px auto;
				padding-top: 20px;
				font-size: 32px;
				line-height: 36px;
				color: #7e7e7e;
				text-transform: uppercase;
			}
		</style>

		<script type=\"text/javascript\">

		function refresh()
		{
		    var req = new XMLHttpRequest();
	   	 	console.log(\"Refreshing Count...\");

        req.onreadystatechange=function() {
          if (req.readyState==4 && req.status==200) {
    				document.getElementById('howmany').innerText = req.responseText;
          }
        }
		    req.open(\"GET\", '/mixpanel_number?api_key=#{api_key}&api_secret=#{api_secret}&event=#{event}&event_type=#{event_type}', true);
		    req.send(null);
		}

		function init()
		{
			// Change page background to black if the URL contains \"?desktop\", for debugging while developing on your computer
			if (document.location.href.indexOf('desktop') > -1)
			{
				document.getElementById('spacepeopleContainer').style.backgroundColor = 'black';
			}

			refresh()
			var int=self.setInterval(function(){refresh()},300000);
		}

		</script>
	</head>

	<body onload=\"init()\">
		<div id=\"main\">

			<div id=\"spacepeopleContainer\">

				<h2>#{title}</h2>
				<h1 id=\"howmany\"></h1>

			</div><!-- spacepeopleContainer -->

		</div><!-- main -->
	</body>
</html>"

	html
end

get '/mixpanel_number' do
	api_key = params[:api_key]
	api_secret = params[:api_secret]
	event = params[:event]

	interval = 1
	if params[:interval]
		interval = params[:interval]
	end

	unit = 'day'
	if params[:unit]
		unit = params[:unit]	
	end

	event_type = 'general'
	if params[:event_type]
		event_type = params[:event_type]
	end

	config = {api_key: api_key, api_secret: api_secret}
	client = Mixpanel::Client.new(config)
	if event == 'engage_total'
		data = client.request('engage', {
			where: "not properties[\"User Type\"]"
			})
		"#{data['total']}"
	elsif event == 'engage_wau'
		data = client.request('engage', {
			where: "not properties[\"User Type\"]"
			})

		total_users = data['total']

		data = client.request('engage', {
			where: "((datetime(#{Time.now.to_i} - 604800) < properties[\"$last_seen\"])) and (not properties[\"User Type\"])"
			})

		last_week_users = data['total']
		"#{((last_week_users.to_f / total_users.to_f) * 100.0).to_i }"		
	elsif event == 'engage_today'
		seconds_since_midnight = ((Time.now.hour.to_i + 2) * 60 * 60) + (Time.now.min.to_i * 60) + (Time.now.sec.to_i)
		data = client.request('engage', {
			where: "((datetime(#{Time.now.to_i} - #{seconds_since_midnight}) < properties[\"$last_seen\"])) and (not properties[\"User Type\"])"
			})
		"#{data['total']}"
	else		
		t = Time.now.utc - 18000

		today_date_string = t.strftime("%Y-%m-%d")

		data = client.request('events', {
		  event:     [ event ],
		  unit:     unit,
		  type:      event_type,
		  interval:  interval
		})

		if interval == 1
			date_string = data["data"]["series"][0]
			event_hash = data["data"]["values"][event]

			"#{event_hash[date_string]}"
		else
			output_number = 0
			data["data"]["values"][event].each do |unit_string,unitvalue|
				output_number += unitvalue
			end
			"#{output_number}"
		end
	end

end

get '/mixpanel_funnel' do
	return unless params[:funnel_id]

	api_key = params[:api_key]
	api_secret = params[:api_secret]
	funnel_id = params[:funnel_id]

	config = {api_key: api_key, api_secret: api_secret}
	client = Mixpanel::Client.new(config)

	today = Time.now.utc - 18000
	data = client.request('funnels', {
		funnel_id: funnel_id,
		from_date: '2014-07-14',
		to_date: today.strftime("%Y-%m-%d")
	})

	dates = data['meta']['dates']
	completed = 0
	started = 0
	dates.each do |date|
		completed += data['data'][date]['analysis']['completion']
		started += data['data'][date]['analysis']['starting_amount']
	end
	percentage = (completed.to_f / started.to_f).round(2) * 100
	"completed: #{completed}\nstarted: #{started}\npercentage: #{percentage}"
end

get '/mixpanel' do

	api_key = params[:api_key]
	api_secret = params[:api_secret]
	event = params[:event]
	on_prop = params[:on]
	title = params[:title]
	display_props = params[:display_props]

	layout = "80%,20%"
	if params[:layout]
		layout = params[:layout]
	end

	engage_prop = on_prop
	if params[:engage_prop]
		engage_prop = params[:engage_prop]
	end

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

	t = Time.now.utc - 18000

	today_date_string = t.strftime("%Y-%m-%d")

    response = "#{layout}\n#{title},\n"
	data = client.request('segmentation', {
	  event:     event,
	  name:      'feature',
	  limit:     limit,
	  type:      type,
	  from_date: today_date_string,
	  to_date:   today_date_string,
	  on:        "properties[\"#{on_prop}\"]"
	})

	date_string = data["data"]["series"][0]

	where_string = ""
	first_time = true
	prop_array = []
	launches = Hash[]
	data["data"]["values"].each do |prop, value|
		prop = prop.gsub(",","")
		prop = prop.gsub("\"","")
		if first_time
			where_string = "(properties[\"#{engage_prop}\"] == \"#{prop}\")"
			first_time = false
		else
			where_string = where_string + " or (properties[\"#{engage_prop}\"] == \"#{prop}\")"
		end
		prop_array.push(prop)
		launches[prop] = value[date_string]
	end

	array_to_sort = []
	if display_props and prop_array.count > 0
		engagedata = client.request('engage', {
		  where:        where_string
		})
		engagedata["results"].each do |person|
			response_string = "#{person['$properties'][engage_prop]}"
			display_props.each do |display_prop|
				response_string += ",#{person['$properties'][display_prop]}"
			end
			response_string += ",#{launches[person['$properties'][engage_prop]]}\n"
			array_to_sort.push(Hash[:response_string => response_string, :launches => launches[person['$properties'][engage_prop]] ] )
		end
	else

		prop_array.each do |prop|
			response_string = "#{prop},#{launches[prop]}\n"
			array_to_sort.push(Hash[:response_string => response_string, :launches => launches[prop] ])
		end
	end

	array_to_sort.sort_by { |hsh| hsh[:launches] }.reverse.each do |hsh|
		response += hsh[:response_string]
	end

	response
end