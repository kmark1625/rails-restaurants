# Restaurant Challenge
Allows user to submit a menu and a target price. The user will then be presented with a combination of items that add up to the target price exactly, should one exist.

## Summary
This project seeks to address the problem of ordering in a restaurant. Given a desired amount of money you wish to spend, the site should allow the user to find a combination of items that add up to the order exactly. This is a NP-hard problem. As such, the expected runtime of the solution is exponential with the number of menu items. A trade-off was made to prevent large menu items from being loaded (the user will receive an error letting them know the menu is too large) rather than forcing the user to wait. Scalability testing was performed to determine the large number of items. Profiling was used to determine a 5 second wait. Any number of items greater than this results in an error message.

## Design Decisions & Issues
### Command-line vs Web Application
I decided that a web application would be better for this assignment for several reasons. The main benefit of a command line app would be simplicity. Unfortunately, the user experience benefits are lacking as well as extensibility for future designs. A web application provides a much more user-friendly experience by allowing users to upload .txt files (and even csv files) directly. In addition, the web UI makes it easy to upload several files and keep track of the respective outputs. You are even able to add additional features without forcing the user through a text-based prompt or forcing the user to know many different command-line options.

The website allows the user to read more about the project in a straightforward way as well as manually input target price and items. The program was designed to be extensible so that other things that need to make use of the item or menu classes are able to. The other main consideration was what web framework to used. I decided on Rails over Sinatra due to the many built-in libraries as well as security fixes associated with Rails.

### Saving items to database or stand-alone classes
One of the main considerations I had was whether or not the item/menu classes should be persisted to the database as active record objects. I made the decision not to do so. The main reason being that many items in the database may (validly) have the same name and different prices as they belong to different menus. Given the nature of the application it seemed very rare for a user to go back and make an update to the menu. It seemed like a lot of overhead to have to store the items in the database for every single menu loaded (especially if the menus start getting large). I left the possibility open to save orders to the database. My idea would be there would be a different item model that inherits from active record and also has a quantity. You can loop through the results and save these to the database and persist given orders. Others can then make use of these orders and the items that belong to the orders.

### Algorithm
The algorithm used is a dynamic programming method that takes calculates the solution with the minimum number of items at each prior state. This makes it trivial to calculate the solution at the next state. This algorithm allowed me to find the combination with the lowest number of items required. I chose to do this because in many cases this solution is much more interesting. For example, say I have a menu with an item that costs $.01 and $5 with a target of $10. I much rather have an order of quantity 2 than of quantity 1000 if possible.

Another possible decision was to create a genetic algorithm which would be able to handle larger quantities slightly better. I decided against adding this additional complexity. The expected input is for standard-sized menus. Should the expected use-case change it might make sense to build a genetic algorithm to handle these requests.

### File Upload landing page
I decided to have a landing page for file uploads. Note that on Heroku this means that multiple users are all sharing the same filespace. My intention for this is that I was thinking of adding user login so that each user would have access to their own landing page. For the context of this challenge, I didn't want the user to have to login in order to use the app. This main page could also be adapted to only handle a single input at a time of the user is not logged in. I preferred to show the full user experience so I decided not to implement user login/registration capability. The program could be expanded to meet this behavior.

## User Stories
* The user can go to the website and upload a txt menu

## Testing & Edge Cases
Testing was very important to this application. I have uploaded a number of test menus I used to test this application. I also have documented the contents of each file. Below I list some of the input validation that is performed on the input .txt file.

Another important piece of testing was scalability testing. As the problem is an NP-hard problem, it is likely to have poor performance with a large number of items. I decided that the intended behavior I wanted was to cap the number of allowed items for performance. As a result, I performed scalability testing to determine the number of items which causes poor performance (rated as taking 5 seconds to compute on my local machine). Any menus that exceeded this amount were sent back as errors.

#### Input Validation
* Handles one line input
* Handles multiple line input
* Handles files with and without $
* Returns error if not a float or string in given position

* menu.txt
** This menu is the standard menu with the problem
* menu2.txt
** Has an extra item that is very small in cost.
* menu3.txt
** Has an extra item that allows total number of items to be reduced

## Deployment Instructions
This application makes use of CarrierWave. As a result, ImageMagick must be installed on the machine. If using OSX, brew install imagemagick.

git clone repo
cd directory
bundle install
rake db:create
rake db:migrate
rails s



