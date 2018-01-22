class HomeController < ApplicationController
  
  protect_from_forgery :except => [:api_calls]

  def index
  	@accounts = Admin.all 
  end

  def red_yellowant
  	temp = SecureRandom.hex(20)
  	@tracker = Usertracker.new(:user=>1, :uhashid => temp)
  	@tracker.save
  	rurl = "http://www.spendse.com/api/oauth2/authorize/?client_id=#{ENV['CLIENT_ID']}"
  	rurl += "&state=#{temp}&response_type=code&redirect_url=http://localhost:3000/redirected_url/" 
  	redirect_to rurl
  end

  def redirected
  	code = params[:code]
  	state = params[:state]
  	user = Usertracker.where(:uhashid => state)

  	y = Yellowant::YellowantObj.new(:app_key => ENV['CLIENT_ID'], :app_secret => ENV['CLIENT_SECRET'],
                  					:access_token => nil,
                  					:redirect_uri => "http://localhost:3000/redirected_url/")
  	json_token = y.get_access_token(code)
  	token = json_token["access_token"]
  	x = Yellowant::YellowantObj.new(access_token: token)
  	user_profile = x.get_user_profile()
  	create_integration = x.create_user_integration()
  	new_integration = Admin.new(:user_id => user[0].user, :integration_id => create_integration["user_application"],
  								:invoke_name => create_integration["user_invoke_name"], :token => token)
  	new_integration.save

  	redirect_to :action => 'index'
  end

  def api_calls
  	data = JSON.parse(params[:data])
  	if data["verification_token"] != ENV["VERIFICATION_TOKEN"]
  		render json: {"error": "wrong verification token"}, status: 403
  		return
  	end
  	args = data["args"]
  	integration_id = data["application"]
  	user = Admin.where(:integration_id => integration_id)
  	if data["function_name"] == "hello"
  		m = Messages::MessageClass.new()
  		m.message_text = "Hello #{user[0].user_id}"
  	else
  		m = Messages::MessageClass.new()
  		m.message_text="I don't recognize this command!"
  	end
  	render json: m.to_json
  	return
  end

end
