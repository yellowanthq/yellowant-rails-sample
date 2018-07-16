class HomeController < ApplicationController
  
  protect_from_forgery :except => [:api_calls]

  def index
  	@accounts = Admin.all 
  end

  def red_yellowant
  	temp = SecureRandom.hex(20)
  	@tracker = Usertracker.new(:user=>1, :uhashid => temp)
  	@tracker.save
    rurl = "http://www.yellowant.com/api/oauth2/authorize/?client_id= <ENTER CLIENT id>"
  	rurl += "&state=#{temp}&response_type=code&redirect_url=http://localhost:3000/redirected_url/" 
    print "red_yellowant inside\n"
  	redirect_to rurl
  end

  def redirected
  	code = params[:code]
  	state = params[:state]
  	user = Usertracker.where(:uhashid => state)
    print"code "+code.to_s+"   state "+state.to_s+"   user="+user.to_s
    puts   "Inside redirected"

  	y = Yellowant::YellowantObj.new(:app_key => " <ENTER CLIENT id>", :app_secret => " <ENTER CLIENT SECRET>",
                  					:access_token => nil,
                  					:redirect_uri => "http://localhost:3000/redirected_url/")
  	print y.instance_variable_get(:@app_key) + "\n"
    print y.instance_variable_get(:@app_secret)
    json_token = y.get_access_token(code)
    print "json_token= "+json_token.to_s
  	token = json_token["access_token"]
    print "accesstoken "+token.to_s+"\n"
  	x = Yellowant::YellowantObj.new(access_token: token)
  	user_profile = x.get_user_profile()
  	create_integration = x.create_user_integration()
    puts create_integration
  	new_integration = Admin.new(:user_id => user[0].user, :integration_id => create_integration["user_application"],
  								:invoke_name => create_integration["user_invoke_name"], :token => token)
  	new_integration.save
    puts "Integration saved"

  	redirect_to :action => 'index'
  end

  def api_calls
    print "inside API"
    require 'mysql2'  
  	data = JSON.parse(params[:data])
  	if data["verification_token"] !=' <ENTER VERIFICATION TOKEN>'
  		render json: {"error": "wrong verification token"}, status: 403
  		return
  	end
  	args = data["args"]
  	integration_id = data["application"]
  	user = Admin.where(:integration_id => integration_id)
    require 'mysql2'
    client = Mysql2::Client.new(:host => "localhost", :username => "root",:password=>"<ENTER PASSWORD>",:database=>"todo")


  	if data["function_name"] == "list-items"
      results = client.query("SELECT * FROM todo_list where integ_id=\""+integration_id.to_s+"\"")
      m = Messages::MessageClass.new()
      m.message_text = "The list of all items is:\n"
      a=Messages::MessageAttachment.new()

      results.each do |row|
        #print row
        field=Messages::AttachmentClass.new()
        # m.message_text+=row["title"]+"\n"
        # m.message_text+=row["description"]+"\n\n"
        field.title=row["title"]
        if row["description"]!=nil
          field.value=row["description"]
        else
          field.value=""
        end
        a.attach_field(field)
      end
      m.attach(a)
  
  	elsif data["function_name"] == "create_item"
      content=data["args"]
      
      title=content["Title"]
      if content["Description"]!=nil
        description=content["Description"]
        client.query("INSERT INTO todo_list (title,description,integ_id) values(\""+title.to_s+"\",\""+description.to_s+"\",\""+integration_id.to_s+"\")")
      else
        client.query("INSERT INTO todo_list (title,integ_id) values(\""+title.to_s+"\",\""+integration_id.to_s+"\")")
      end
      puts title,description,integration_id
      print"hello"

      
      client.close
  	  m = Messages::MessageClass.new()
      m.message_text="Item has been created"

    elsif data["function_name"] == "delete_item"
      content=data["args"]
      
      title=content["Title"]
      puts title,"has been deleted"
      client.query("DELETE FROM todo_list Where integ_id=\""+integration_id.to_s+"\" AND title=\""+title.to_s+"\"")
      client.close
      m = Messages::MessageClass.new()
      m.message_text="Item has been deleted"
    elsif data["function_name"] == "get_item"
      content=data["args"]
      
      title=content["Title"]  
      m = Messages::MessageClass.new()
      results=client.query("SELECT * FROM todo_list where title=\""+title.to_s+"\" AND integ_id=\""+integration_id.to_s+"\"")
      client.close
      results.each do |row|
        print row
        m.message_text+=row["title"]+"\n"
        m.message_text+=row["description"]+"\n\n"
      end
    elsif data["function_name"] == "update_item"
      content=data["args"]
      old_title=content["Old-Title"]
      title=content["Title"]
      puts "Updating item",old_title,title
      m=Messages::MessageClass.new()  
      if content["Description"]!=nil
        description=content["Description"]
        puts description,"description ^"
        results = client.query("UPDATE todo_list SET title=\""+title.to_s+"\" ,description=\""+description.to_s+"\" where title=\""+old_title.to_s+"\"")
      else
        results = client.query("UPDATE todo_list SET title=\""+title.to_s+"\" where title=\""+old_title.to_s+"\"")
      end
      m.message_text="Item has been updated"
      
    else
  		m = Messages::MessageClass.new()
      print data["function_name"]
  		m.message_text="I don't recognize this command!"
  	end
  	render json: m.to_json
  	return
  end

end
