/* Based on https://developers.google.com/maps/documentation/javascript/dds-boundaries/style-polygon#maps_boundaries_simple-html */

import hamburg from "./assets/place_id_crime_hamburg.js";
import munich from "./assets/place_id_crime_munich.js";
let map;
const avg = (arr) => arr.reduce((p, c) => p + c, 0) / arr.length;

function initMap() {
  map = new google.maps.Map(document.getElementById("map"), {
    /*center map in Munich
    center: { lat: 48.1351, lng: 11.582 },
    zoom: 12,
    */

    /*center map in Hamburg
    center: { lat: 53.5488, lng: 9.9872 },
    zoom: 12,
    */

    /*center map in Germany */
    center: { lat: 51.1657, lng: 10.4515 },
    zoom: 7,
    /* add Map ID here*/
    mapId: "${GOOGLE_MAP_ID}",
  });

  const featureLayer = map.getFeatureLayer("POSTAL_CODE");
  let average_rate_hamburg = {};
  let average_rate_munich = {};

  Object.entries(hamburg).forEach(([key, value]) => {
    let avg_rate = Array.isArray(value) ? avg(value) : value;
    average_rate_hamburg[key] = avg_rate;
  });

  Object.entries(munich).forEach(([key, value]) => {
    let avg_rate = Array.isArray(value) ? avg(value) : value;
    average_rate_munich[key] = avg_rate;
  });

  const place_ids_hamburg = Object.keys(average_rate_hamburg);
  const place_ids_munich = Object.keys(average_rate_munich);

  featureLayer.style = function (placeFeature) {
    let red = "#FF0000";
    let orange = "#FF9900";
    let yellow = "#FFFF00";
    let green = "green";
    let fillOpacity = 0.3;
    let strokeOpacity = 0.5;
    let strokeWeight = 1.0;

    function style(color) {
      return {
        strokeColor: color,
        strokeOpacity: strokeOpacity,
        strokeWeight: strokeWeight,
        fillColor: color,
        fillOpacity: fillOpacity,
      };
    }

    //Munich
    if (place_ids_munich.includes(placeFeature.feature.placeId)) {
      if (0.07 < average_rate_munich[placeFeature.feature.placeId]) {
        return style(red);
      } else if (
        0.04 < average_rate_munich[placeFeature.feature.placeId] &&
        average_rate_munich[placeFeature.feature.placeId] < 0.07
      ) {
        return style(orange);
      } else if (
        0.03 < average_rate_munich[placeFeature.feature.placeId] &&
        average_rate_munich[placeFeature.feature.placeId] < 0.04
      ) {
        return style(yellow);
      } else if (average_rate_munich[placeFeature.feature.placeId] < 0.03) {
        {
          return style(green);
        }
      }
    }

    //Hamburg
    if (place_ids_hamburg.includes(placeFeature.feature.placeId)) {
      if (0.1 < average_rate_hamburg[placeFeature.feature.placeId]) {
        return style(red);
      } else if (
        0.08 < average_rate_hamburg[placeFeature.feature.placeId] &&
        average_rate_hamburg[placeFeature.feature.placeId] < 0.1
      ) {
        return style(orange);
      } else if (
        0.06 < average_rate_hamburg[placeFeature.feature.placeId] &&
        average_rate_hamburg[placeFeature.feature.placeId] < 0.08
      ) {
        return style(yellow);
      } else if (average_rate_hamburg[placeFeature.feature.placeId] < 0.06) {
        return style(green);
      }
    }
  };
}
window.initMap = initMap;
