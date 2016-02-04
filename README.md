# Restaurant Challenge
Allows user to submit a menu and a target price. The user will then be presented with a combination of items that add up to the target price exactly, should one exist.

## Summary
This project seeks to address the problem of ordering in a restaurant. Given a desired amount of money you wish to spend, the site allows users to find a combination of items that add up to the order exactly. This is a NP-hard problem. As such, the expected runtime of the solution is exponential with the number of menu items. A trade-off was made to prevent large menus from being loaded (the user will receive an error letting them know the menu is too large) rather than forcing the user to wait. Performance testing was performed to prevent menus that would result in greater than a 5 second wait.

## Design Decisions & Issues
### Command-line vs Web Application
I decided that a web application would be better for this assignment for several reasons. The main benefit of a command line app would be its simplicity. Unfortunately, the user experience benefits are lacking for a command line app as well as extensibility for future designs. A web application provides a much more user-friendly experience by allowing users to upload .txt files directly. In addition, the web UI makes it easy to upload several files and keep track of the respective outputs. As a web application, it is easy to add additional features without forcing the user through a text-based prompt or forcing the user to know many different command-line options.

The website allows the user to read more about the project in a straightforward wa. The program was designed to be extensible so that other things that need to make use of the item or menu classes are able to. The other main consideration was what web framework to used. I decided on Rails over Sinatra due to the many built-in libraries as well as security fixes associated with Rails. This allows for things such as ease of validations when uploading a new menu file.

### Standalone classes vs active record objects
One of the main decision points was whether or not the item and menu classes should be persisted to the database as active record objects. I made the decision not to do so. The main reason being that many items in the database may (validly) have the same name and different prices as they belong to different menus. Given the nature of the application it seemed very rare for a user to go back and want to do CRUD actions on the menus or items. Thus, there was a lot of overhead to have to store the items in the database for every single menu loaded (especially if the menus start getting large). I left the possibility open to save orders to the database. My idea would be there would be a different item model that inherits from active record and also has a quantity. You can loop through the results and save these to the database and persist given orders. Others can then make use of these orders and the items that belong to the orders.

### Algorithm
The algorithm used is a dynamic programming method that takes calculates the solution with the minimum number of items at each prior state. This makes it trivial to calculate the solution at the next state (state+1). This algorithm allowed me to find the combination with the lowest number of items required. I chose to do this because in many cases this solution is much more interesting. For example, say I have a menu with an item that costs $.01 and $5 with a target of $10. I much rather have an order of quantity 2 than of quantity 1000 if possible.

Another possible decision was to create a genetic algorithm which would be able to handle larger quantities slightly better. I decided against adding this additional complexity. It would also be difficult to decide on convergence and I would likely have to take an approach to timeout after a certain amount of time rather than scaling simply with the number of items or target price. The expected input is for standard-sized menus. Should the expected use-case change it might make sense to build a genetic algorithm to handle these requests.

### File Upload landing page
I decided to have a landing page for file uploads. Note that on Heroku this means that multiple users are all sharing the same filespace. My intention for this is that I was thinking of adding user login so that each user would have access to their own landing page. For the context of this challenge, I didn't want the user to have to register/login in order to use the app. This main page could also be adapted to only handle a single input at a time of the user is not logged in. I preferred to show the full user experience so I decided not to implement user login/registration capability. The program could be expanded to meet this behavior by adding a user model and tying inputfiles to the user that uploaded them.

## Testing & Edge Cases
Testing was a very important part of this application. I have included a number of test menus that I used to test this application. I have also decided to keep a base set of these to allow the user to see the behavior of the application easily. Documentation for each test file is listed below. A summary of the different types of input validation is also listed below.

Another important piece of testing was scalability testing. As the problem is an NP-hard problem, it is likely to have poor performance with a large number of items. I decided that the intended behavior I wanted was to cap the number of allowed items for performance. As a result, I performed scalability testing to determine the number of items which causes poor performance (rated as taking 5 seconds to compute on my local machine). Any menus that exceeded this amount were sent back as errors.

#### Input Validation
* Handles one line input
* Handles multiple line input
* Handles files with and without $
* Returns error if not a float or string in given position
* Returns error with large target price (>$20000)
* Returns error with large number of items (>1000)

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

## Future Work
This section seeks to discuss future work that can be done to improve the site. Below are a list of features that can be implemented:
* User registration/login/content
* Input/Output from/to CSV
* AJAX
* Input from text area

## Deployment Instructions
This application makes use of CarrierWave. As a result, ImageMagick must be installed on the machine. If using OSX, brew install imagemagick.

```
git clone https://github.com/kmark1625/rails-restaurants.git
cd rails-restaurants
bundle install
rake db:create
rake db:migrate
rails s
```


