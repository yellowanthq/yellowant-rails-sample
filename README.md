# README
 
This repository contains sample app demonstrating yellowant gem usage. This sample app is for sole purpose of introducing developers to YellowAnt API
This repository contains a sample app demonstrating yellowant gem usage. This sample app is for sole purpose of introducing developers to YellowAnt API
 
## Requirments 
## Requirements 
 
 * [Ruby](https://www.rubylang.org/en/documentation/installation/) (sample apps were written with Ruby 2.2.1)
 * [Rails 5.1.4](http://rubyonrails.org/)
 * [YellowAnt Gem](https://github.com/yellowanthq/yellowantrubysdk)
 
## YELLOWANT SAMPLE TODO APP
# yellowantrailssample

Sample Ruby on Rails application for creating a TODO List application for YellowAnt. For API documentation, please visit https://apidocs.yellowant.com

## Getting Started

These instructions will get you started with building basic YellowAnt application.

## Register this application with your YellowAnt Developer account

1. Once you have logged into YellowAnt, head over to your team's subdomain developer page, <https://yourteamsubdomain.yellowant.com/developers/>

2. Click on the button "Create New Application"

3. Fill the form and click on "Create Application":
![YellowAnt Create New App](https://github.com/yellowanthq/yellowantsampledjangoapp/blob/master/docs/yellowantcreatenewapp.jpg "YellowAnt Create New App")
     Display Name: A human readable display name for the application.
     Invoke Name: A simple single word which users can use to control this app.
     Short Description: A human readable short description

4. After the application is created you will be at the application overview page. You need to update the application with more information and click on "Update Application".
![YellowAnt Update App](https://github.com/yellowanthq/yellowantsampledjangoapp/blob/master/docs/yellowantappoverview1.jpg "YellowAnt Update App")
![YellowAnt Update App](https://github.com/yellowanthq/yellowantsampledjangoapp/blob/master/docs/yellowantappoverview2.jpg "YellowAnt Update App")
     API URL: The endpoint through which YellowAnt will communicate with this app.
     Installation Website: The URL of your app where users will be able to begin integrating their YellowAnt accounts with this app.
     Redirect URL: The endpoint at which YellowAnt will send the OAuth codes for user authentication.
     Icon URL: A URI which points to an icon image for this app.
     Creator Email: Your Email.
     Privacy Policy URL: Any policy or TOC URL for your app.
     Documentation URL: A documentation website URL for your app.
     Is Application Active: set to "Active".
     Is Application Production or Testing: set to "Production".
     Application Visibility: set to "Public".

5. You need to create the 5 functions that are understood by this Django app.
    1. createitem(title, description): create a new todo item
         Title [varchar, required]: title of a todo item
         Description [varchar]: extra details of a todo item
    2. getlist(): get a list of todo items
    3. getitem(title): get a single todo item
         Title [varchar, required]: title of the todo item
    4. updateitem(oldtitle, newtitle, description): update a todo item
         Oldtitle [varchar, required]: id of the todo item
         Title [varchar]: new title of the todo item
         Description [varchar]: new description for the todo item
    5. deleteitem(title: varchar): delete a todo item
         Title [int, required]: id of the todo item

![YellowAnt Create New Function](https://github.com/yellowanthq/yellowantsampledjangoapp/blob/master/docs/yellowantcreatenewfunction.jpg "YellowAnt Create New Function")
![YellowAnt Create New Input Arg](https://github.com/yellowanthq/yellowantsampledjangoapp/blob/master/docs/yellowantcreatenewarg.jpg "YellowAnt Create New Input Arg")
```
Example of how to create the function, createitem, which has two input arguments, title and description:

1. Click on "Add New Function".
2. Complete the form and click on "Create New Function":
     Display Name: Human readable name for this function. e.g. "Create a Todo Item"
     Invoke Name: A simple descriptive word for invoking this command. e.g. "createitem"
     Description: Description. e.g. "Add a new item to your todo list"
     Function Type: Set to "Command"
     Is Function Active: Set to "Yes"
3. After creating a new function, you're at the function overview page, scroll down to the section for input arguments, and click on "Add New Input Arg".
4. Add a new input argument, title, and click on "Save":
     Display Name: A simple description word for this argument. e.g. title
     Description: Describe the use for this argument. e.g. A title which summarizes this todo
     Type: The data type of this argument. e.g. varchar
     Required: Toggle it on.
     Input Example: A human readable example. e.g. Get Milk
4. Add a new input argument, description, and click on "Save":
     Display Name: A simple description word for this argument. e.g. description
     Description: Describe the use for this argument. e.g. Details about the todo item
     Type: The data type of this argument. e.g. varchar
     Required: Toggle it off.
     Input Example: A human readable example. e.g. Get nonskimmed milk from Krogers at 4th Cross St.
```

## Getting started with application
This application helps you start with writing application code. When going to production, make sure you load all sensitive 
tokens and values through environment variables or encoded secrets for better security.

1. Open solution in any text editor like Sublime Text. Make sure you have installed the gem 'yellowant'. Use gem install yellowant to install the required package. Also you might be required to execute a bundleinstall should the need arise and a warning displayed when the application is run. Open your terminal and run 'rails s' inside the directory that this repository is cloned into. The browser should open up stating errors present including the database name and credentials. Fix that to the ones present on your PC. The changes need to be made in the database.yml file.
2. Copy ClientID, ClientSecret, Verifcation token from your Yellowant dashboard to relevant sections in 
app/controllers/home_controller.rb marked in <>. The database names stated in the databse.yml file will have to be manually created from your mysql terminal. Use your mysql password to autheticate.
3. Start the development server running `rails s `on your teminal
4. Open your browser with ```localhost:3000```
5. You will now be on the create integration page where in you can add accounts. Click on add account and provide authorization for yellowant. 

### Using Ngrok
Ngrok provides public URLs for your apps on local machine. You can use this to test out your application before launching 
it in production. Head over to [Ngrok](https://ngrok.com/) and create an account. Follow the instructions to set up ngrok 
on your machine. ngrok server by using 

```ngrok http 3000```

After you start ngrok, note the link. 
1. You need to update your app Redirect URL and API URL in Yellowant dashboard. The correct URL extentions are present in the routes.rb file present in the config folder.
2. Make sure the ClientID and Client Secret are correct and so is the Verification Token. Update them in the home_controller file.
 
Now you should be ready to communicate with Yellowant.

### Using RTM Socket 
In case your development server is behind a firewall, you can use Yellowant RTM Client to communicate.
1. Enable RTM for your application on YellowAnt developer dashboard. Don't forget to click 'Update Application'
2. Visit the YellowAnt RTM repo(https://github.com/yellowanthq/yellowantrtmclient) and follow instructions to run socket client on your machine.  
3. Go to Controllers/UserIntegrationController.cs, in "API" method, comment the lines under 'NOT using RTM' and uncomment
the lines under "using RTM"
4. Start your development server

## Understanding Application Layout
This is an example application, to let you know basics of building an integration for YellowAnt. Don`t use this code for production.
There are two main components to notice
1. Controller (UserIntegrationController)
2. CommandCenter
  
### Controller
There are 3 controller functions red_yellowant, redirected and api_calls. 

#### red_yellowant
When you start a server go to ```localhost:3000```. This redirects you to the yellowant page using the client ID passed.

#### redirected 
Once on ```localhost:3000```, click on 'Add Account'. This will redirect you to the redirected function where in your client ID is used to provide authentication with yellowant. In this controller, a user `state` is created and redirect link to yellowant is constructed using state and clientID. Access tokens are generated in this process that allow access to yellowant API.
If user approves request, YellowAnt will redirect you to 'redirect url' you have mentioned in application dashboard. This controller handles this redirected request. Request comes with `state` you created and a 'token'. You use these and complete OAuth cycle to get secret token form YellowAnt.

#### api_calls
When user enters command in Slack/YellowAnt, that request is sent to 'API url' you mentioned in YellowAnt application dashboard.
Those requests are handled by this controller. The API url is the name of the API function, here 'api_calls'.

### Commands
All commands are executed directly under the api_calls function. If the commands get large its always better to use a seperate class to prevent confusion. Each command executed for this application is directly dependedent on the local database. The data JSON file has all data sent and recieved by across the API. We can recieve arguments with it and also the name of the function that has made the call. 
