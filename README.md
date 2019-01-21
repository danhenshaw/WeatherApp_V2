# WeatherApp (version 2)

WeatherApp is a weather app for iOS powered by [Dark Sky] (https://darksky.net)


## Objective

Create an iOS weather app that uses only Apple frameworks. I wanted to create a visually stunning weather app that was intuative to use, allowed users access to detailed weather data while maintaining a simply user interface.


## Solution

I chose the Dark Sky weather API due to the accuracy of the weather report as well as the sheer volume of weather data which can be requested. Users can interact with the main view in multiple ways to allow access to various forms of weather data. 

### Features

- Main forecast view shows an overview of weather data for a specific city. View controller is user interactive:
    - swiping left or right changes cities
    - choose between "Hourly" or "Daily" forecast data
    - can select specific day or time to show a more detailed overview in the "overview cell"
    - clicking on the "summary cell" toggles between the selected index summary and the minutely precipitation intensity graph when available
    - background gradient colours change based on weather conditions currently being shown
- Users can save multiple cities to core data
- Users can set preferred language and units


## Requirements

Sign up to Dark Sky at https://darksky.net/dev/register to obtain an API Key.


## Further Improvements

Current improvements being worked on:
  - internationalise and localise App 
  - forecast overview section to show customiseable weather data
  - error alerts
  - code documentation
  - customise refresher
  - add sunrise/sunset/new day in collectionview cell (currently only displaying index weather conditions)
  - more complex background colour algorithm for displaying weather conditions
  - general debugging

Future improvemts to be implemented:
  - create widget and watchOS
  - weather radar view
  - user choosable color pallete
  - dark mode option
  - create app icons
  - add unit testing


## Author

Daniel Henshaw, danieljhenshaw@gmail.com


## License

WeatherApp is available under the [MIT license](https://opensource.org/licenses/MIT)
