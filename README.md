# WeatherApp (version 2)

WeatherApp is a weather app for iOS powered by [Dark Sky](https://darksky.net)


## Objective

Create an iOS weather app that uses only Apple frameworks. I wanted to create a visually stunning weather app that  allowed users access to detailed weather data while maintaining a simply user interface and beign intuitive to use.


## Solution

I chose the Dark Sky weather API due to the accuracy of the weather report as well as the sheer volume of weather data which can be requested. Users can interact with the main view in multiple ways to allow access to various forms of weather data. This allows the app to remain visually simple and provide one touch access to very detailed weather conditions which is not attainable with most apps on the market. The data which is displayed is also largely customiseable resulting in a better user experience.

### Features

    - Main forecast view shows an overview of weather data for a specific city. View controller is user interactive:
        - swiping left or right changes cities
        - choose between "Hourly" or "Daily" forecast data
        - can select specific day or time to show a more detailed overview in the "overview cell"
        - clicking on the "summary cell" toggles between the selected index summary and the minutely precipitation intensity graph when available
        - background gradient colours change based on weather conditions currently being shown
    - Users can save multiple cities to core data
    - Users can set preferred language and units
    - Customisable forecast display for currently, hourly and daily sections


## Requirements

Sign up to [Dark Sky](https://darksky.net/dev/register) to obtain an API Key. Add the API Key to the Dark Sky API Manager. 


## Further Improvements

### Currently being worked on:
    - Ad implementation using Google AdMobs
    - Today Extension Widget
    - Localisation and Internationalisation

### Future work: 
    - Customise refresh controller
    - watchOS
    - Weather radar view
    - More complex background colour algorithm for displaying weather conditions
    - Create app icons
    - Add unit testing


## Resources
Using [Climacons](http://adamwhitcroft.com/climacons/) by Adam Whitcroft


## Author

Daniel Henshaw, danieljhenshaw@gmail.com


## License

WeatherApp is available under the [MIT license](https://opensource.org/licenses/MIT)
