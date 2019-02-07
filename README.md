# WeatherApp (version 2)

WeatherApp is a weather app for iOS powered by [Dark Sky](https://darksky.net)


## Objective

Create an iOS weather app that uses only Apple frameworks. I wanted to create a visually stunning weather app that was intuitive to use, allowed users access to detailed weather data while maintaining a simply user interface.


## Solution

I chose the Dark Sky weather API due to the accuracy of the weather report as well as the sheer volume of weather data which can be requested. Users can interact with the main view in multiple ways to allow access to various forms of weather data. This always the app to remain visually simple and provide one touch access to very detailed weather conditions not attainable with most apps on the market. 

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

  - Customise refresh controller
  - Correctly implement internationalisation and localisation. Currently using a dictionary called Translator()
  - Create widget and watchOS
  - Weather radar view
  - More complex background colour algorithm for displaying weather conditions
  - User choosable color palette
  - Dark mode option
  - Create app icons
  - Add unit testing


## Resources
Using [Climacons](http://adamwhitcroft.com/climacons/) by Adam Whitcroft


## Author

Daniel Henshaw, danieljhenshaw@gmail.com


## License

WeatherApp is available under the [MIT license](https://opensource.org/licenses/MIT)
