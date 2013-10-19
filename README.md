Mixpanel StatusBoard
====================

A simple Sinatra app for sending [Mixpanel](https://mixpanel.com/docs/api-documentation/data-export-api#segmentation-default) data to [Status Board](http://panic.com/statusboard/)


### Parameters Supported

```
api_key: (required) Mixpanel API key
api_secret: (required) Mixpanel API secret
event: (required) Mixpanel event to segment
on: (required) Property segment your event on
title: (required) Title for StatusBoard
type: (optional) general,unique,average -- see Mixpanel docs for details
limit: (optional) max number to return
```

### Local Testing

Use shotgun for autoreloading, runs on port 9393
```
shotgun mixpanel_statusboard.rb
```

#### Example Request

```
curl "http://localhost:9393/mixpanel?api_key=<apikey>&api_secret=<apisecret>&on=OID&title=Users+By+OID&event=application+started&type=unique"
```

Output should be a CSV that looks something like:

```
80%,20%
Users By OID,
bar1,16
foo2,15
derp3,13
foo4,9
bar4,8
```

### To The Cloud!

I followed the instructions [here](https://devcenter.heroku.com/articles/getting-started-with-ruby) to deploy to Heroku.  Basically, you can just do:

```
heroku create [app name]
bundle install
git push heroku master
```

Obviously, that is skipping over some, but the steps are very easy for a little sintra app like this.  Just read that link and you'll be going in a few minutes.

### URLs For StatusBoard
Building the URLs for StatusBoard can be annoying, so I wrote a little script to help you out.  Run this script:

```
~/projects/mixpanel_statusboard ] ./utils/url_builder.rb               

Enter URL (no http): 
mpstatus.herokuapp.com
Enter API key: 
<apikey>
Enter API secret: 
<apisecret>
Enter Mixpanel Event: 
application initialized after authentication
Enter Mixpanel Event Property: 
gt_displayname
Enter StatusBoard Title: 
todays givingtree users
Enter Limit [default=50]: 

Enter Type [default=general]: 

Enter Provider [default=MPStatus]: 

LOCAL:
curl "http://mpstatus.herokuapp.com/mixpanel?api_key=&api_secret=&on=gt_displayname&title=todays%20givingtree%20users&event=application%20initialized%20after%20authentication&type=general&limit=50"

APP:
panicboard://?url=http%3A%2F%2Fmpstatus.herokuapp.com%2Fmixpanel%3Fapi_key%3D%26api_secret%3D%26on%3Dgt_displayname%26title%3Dtodays%2520givingtree%2520users%26event%3Dapplication%2520initialized%2520after%2520authentication%26type%3Dgeneral%26limit%3D50&panel=table&sourceDisplayName=MPStatus
```

Answer the questions and you will get two URLs.  One for local testing, and one for status board.  Email the status board link to yourself, open it on your device, and tap it.  It should open automatically into status board!

