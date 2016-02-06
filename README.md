# Restaurant Challenge
Allows the user to submit a menu and a target price. The user will then be presented with a combination of items that add up to the target price exactly, should one exist.

# Summary
This project seeks to address the problem of ordering in a restaurant. Given a desired amount of money you wish to spend, the site allows users to find a combination of items that add up to the order exactly. This is a NP-hard problem. As such, the expected runtime of the solution is exponential with the number of menu items and target price. A trade-off was made to prevent large menus or a very high target price from being loaded rather than forcing the user to wait. Performance testing was performed to prevent menus that would result in greater than a 5 second wait.

# Design Decisions
### Command-line vs Web Application
I decided to implement this assignment as a web application rather than a command-line application. The main benefit of a command line app would be its simplicity. Unfortunately, the user experience benefits are lacking for a command line app as well as extensibility for future designs. A web application provides a much more user-friendly experience by allowing users to upload .txt files directly. In addition, the web UI makes it easy to upload several files and keep track of the respective outputs. As a web application, it is easy to add additional features without forcing the user through a text-based prompt or forcing the user to know many different command-line options.

The website allows the user to read more about the project in a straightforward way. The program was designed to be extensible so that other things that need to make use of the item or menu classes are able to. The other main consideration was what web framework to used. I decided on Rails over Sinatra due to the many built-in libraries as well as security fixes associated with Rails. This allows for things such as ease of validations when uploading a new menu file.

### Standalone classes vs active record objects
One of the main decision points was whether or not the item and menu classes should be persisted to the database as active record objects. I made the decision not to do so. The main reason being that many items in the database may (validly) have the same name and different prices as they belong to different menus. Given the nature of the application it seemed very rare for a user to go back and want to do CRUD actions on the menus or items. Thus, there was a lot of overhead to have to store the items in the database for every single menu loaded (especially if the menus start getting large).

I left the possibility open to save orders to the database. My idea would be there would be a different item model that inherits from active record and also has a quantity. You can loop through the results and save these to the database and persist given orders. Others can then make use of these orders and the items that belong to the orders. Alternatively, it is relatively easy to make the item and menu class inherit from active record and to save all these items to the database.

### Algorithm
The algorithm used is a dynamic programming method that calculates the solution with the minimum number of items at each prior state. This makes it trivial to calculate the solution at the next state (state+1). This algorithm allowed me to find the combination with the lowest number of items required. I chose to do this because in many cases this solution is much more interesting. For example, say I have a menu with an item that costs $.01 and $5 with a target of $10. I much rather have an order of quantity 2 than of quantity 1000 if possible.

I allowed the user to select whether to search for an order with the minimum number of items or the most diverse combination of items. I chose this as some of the time it is more interesting to see a diverse mix of items rather than a single item with a very high quantity. The algorithm for the most diverse combination was also more complex to write. As this algorithm involves additional sort and comparison operations, the runtime for this calculation is slightly slower. Performance could be optimized by inserting items in sorted order.

Another possible alternative was to iterate through each item and add each possible state combination for that item. With this algorithm, it's possible to end early should a combination be found quickly. If optimal performance is desired (and there are no constraints on the type of solution), this could be a good alternative.

### File Upload landing page
I decided to have a landing page for file uploads. Note that on Heroku this means that multiple users are all sharing the same filespace. My intention for this is that I was thinking of adding user login so that each user would have access to their own landing page. For the context of this challenge, I didn't want the user to have to register/login in order to use the app. This main page could also be adapted to only handle a single input at a time of the user is not logged in. I preferred to show the full user experience so I decided not to implement user login/registration capability. The program could be expanded to meet this behavior by adding a user model and tying input files to the user that uploaded them.

# Testing & Edge Cases
Testing was a very important part of this application. I have included descriptions of a number of test menus that I used to test this application. I have also decided to keep a base set of these to allow the user to see the behavior of the application easily. A summary of the different types of input validation performed is also listed below.

Another important piece of testing was performance testing. As the problem is a NP-hard problem, it is likely to have poor performance with a large number of items or a high target price. I decided that the intended behavior I wanted was to cap the number of allowed items for performance. As a result, I performed scalability testing to determine the number of items which causes poor performance (rated as taking 5 seconds to compute on my local machine). Any menus that exceeded this amount are returned as errors.

#### Input Validation
* Handles one line input
* Handles multiple line input
* Handles files with and without $
* Returns error if not a float or string in given position
* Returns error with large target price (>$20000)
* Returns error with large number of items (>1000)

### Test Menus

| Filename | Description |
| ------------ | :----------------- |
| menu.txt | Valid menu which is the provided menu with the problem |
| menu2.txt | Valid menu with an extra item that is very small in cost |
| menu3.txt | Valid menu with an extra item that allows total number of items to be reduced |
| menu4.txt | Invalid menu with no menu items |
| menu5.txt | Valid menu with items containing no solution |
| menu6.txt | Invalid menu with string values for prices instead of floats. |
| menu7.txt | Valid menu with all items on one line |
| menu8.txt | Invalid menu with numbers instead of string |
| menu9.txt | Valid menu with no dollar signs |
| menu10.txt | Invalid menu with no commas |
| menu11.txt | Large target price |
| menu12.txt | Large number of items |

# Future Work
This section seeks to discuss future work that can be done to improve the site. The main feature that can be added is user registration and login. Signing up, a user will have the ability to view their own unique landing page. If this feature is implemented, a seperate page would be implemented for a non-registered user which would allow them to upload only one file at a time.

Depending on the needs of the application, the item and menu classes can be Active Record models. This would allow us to persist the items and menus to the database. This would allow us to perform basic CRUD functions on these models easily. Other functions could also make use of the these existing classes.

# Deployment Instructions
This application makes use of CarrierWave. As a result, ImageMagick must be installed on the machine. If using OSX, brew install imagemagick.

```
git clone https://github.com/kmark1625/rails-restaurants.git
cd rails-restaurants
bundle install
rake db:create
rake db:migrate
rake db:seed
rails s
```


