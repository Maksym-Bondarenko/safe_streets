# Data driven styling of a Google Map

Our initial idea was to introduce integrated crime-rate-based choropleth maps for some major German cities using data-driven styling, a fairly recent Google maps styling feature. Unfortunately, data-driven styling is only introduced in Maps JavaScript API, which proved to be incompatible with other technologies we chose for the presentation layer of our product. Hence, we must set this idea aside for future development, but we hope to implement it as soon as the possibility arises. However, you’re welcome to check out the previews of such choropleth maps for Munich and Hamburg as screenshots in the app and corresponding sample code provided in this subdirectory.

## How we did it

We style the maps using police data collected from the official crime reports for the year 2021 for various German cities. For each administrative area mentioned in the statistics, we found the corresponding postal codes, along with their Google Place IDs. The styling occurs on the postal code feature layer, where each place feature is color-filled according to the corresponding crime rate.

### Crime statistics sources

| City    | Source                       |
| ------- | ---------------------------- |
| Munich  | https://stadt.muenchen.de/   |
| Hamburg | https://www.polizei.hamburg/ |
