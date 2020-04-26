# iosWeatherApp

## Introduction
This is an iOS Mobile application for weacher search. This application allows users to 
search for weather details using the dark sky APIs and add locations in favorite list, 
and post on Twitter. The backend service is using node.js script

## Function and Display
The launch screen and the main scene of this app are shown as follow. The initial view always displays the weather details of the current location automatically.
The initial view of the App consists of three subviews:
1. The first sub view consists of weather Icon, temperature, weather summary and the City Name. The entire view is **clickable**. On clicking anywhere on the sub view, user will be navigated to the details page (which will be shown later).

<p align="center">
  <img src="images/1.1.png" width="200"/>
  &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp
  <img src="images/1.png" width="200"/>
</p>

The interface consists a **Search Bar**, which is a *UISearchBar* component allowing the user to enter the city name. While typing in the search bar, the results will be provided using the autocomplete API. Here to show the autocomplete result, I used a *UITabView* component which is hidden/shown according to the response of the auto complete API.
<p align="center">
  <img src="images/2.png" width="200"/>
</p>
