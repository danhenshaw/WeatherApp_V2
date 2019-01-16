# WeatherApp (version 2)

WeatherApp is a weather based app for iOS powered by [Dark Sky] (https://darksky.net)

## Features

WeatherApp allows users to download the weather forecast for multiple cities. Users can select prefered language and units from the settings page.

- Users can interact with the main view as follows:
  - swiping left or right changes cities
  - clicking "Hourly" or "Daily" button will update the collection view data accordinglt
  - selecting a collection view cell will update the overview cell at the top
  - clicking on the "summary cell" toggles between the selected index summary and the minutely precip intensity graph when available

## Requirements

Sign up to DARK SKY to obtain an API Key.

https://darksky.net/dev/register

## Learnings

My goal with this app was to implement a weather app using only Apple frameworks and to further explore UIKit. I first attempted to create a Weather App some months ago but with my continued learning any developing, i wanted to revisit the project to add previously missing features.

Developing this app i have furtehred my understanding of the following tools:
  - Table views
  - Collection Views
  - Page views
  - Networking APIS
  - Parsing JSON data
  - Pull-to-refresh Controller
  - Implement delegation pattern using MVVM and flow coordinators 
  - Animations
  - Gradients


## Further Improvements

Current improvements being worked on:
  - implement multiple languages
  - forecast overview section to show customiseable weatehr data
  - error alerts
  - code documentation
  - customise refresher
  - add sunrise/sunset/newday in collectionview
  - more complex background colour algorithm
  - general debugging

Future improvemts to be implemented:
  - create widget
  - weather radar view
  - user choosable color pallete
  - dark mode option
  - create app icons


## Author

Daniel Henshaw, danieljhenshaw@gmail.com


## License

WeatherApp is available under the [MIT license](https://opensource.org/licenses/MIT)

