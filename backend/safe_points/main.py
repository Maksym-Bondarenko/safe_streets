import googlemaps
import csv
import time

# Replace 'YOUR_API_KEY' with your actual API key
api_key = ''
gmaps = googlemaps.Client(key=api_key)


def get_google_places(location, query):
    places_result = gmaps.places(query, location=location)
    return places_result['results']


# # Define the location (Munich, Germany)
# location = 'Munich, Germany'
#
# # Define the search query for police stations
# query = 'police station'
#
# # Perform the places API search
# places_result = gmaps.places(query, location=location)
#
# # Retrieve the list of police stations
# police_stations = places_result['results']
#
# Print the name and address of each police station
# location = 'Munich, Germany'
# police = get_google_places(location, "police")
# hospital = get_google_places(location, "restaurant")
# print(type(hospital))
# print(hospital[0].keys())
# print(len(hospital))
# for station in police:
#     name = station['name']
#     address = station['formatted_address']
#     print(f'Name: {name}\nAddress: {address}\n')
#
# print('the total number of stations:', len(police))

# Define the location (Munich, Germany)
location = 'Munich, Germany'

# Define the search queries
queries = {
    'hospital': 'hospital',
    'police': 'police station'
}

# Perform the places API search and paginate through results
data = []
for query_type, query in queries.items():
    results = []
    page_token = None

    while True:
        places_result = gmaps.places(query, location=location, page_token=page_token)

        # Check if the response is valid
        if 'results' in places_result:
            results.extend(places_result['results'])
        else:
            print(f'Error: Invalid response for {query_type} query')
            break

        # Check if there is a next page
        if 'next_page_token' in places_result:
            page_token = places_result['next_page_token']
            time.sleep(2)  # Delay for a few seconds before making the next API call
        else:
            break

    # Append the results to the data list with type information
    print('the len:', len(results))
    for result in results:
        # print(result)
        data.append(
            {'type': query_type, 'name': result.get('name', ''), 'address': result.get('formatted_address', ''),
             'business_status': result.get('business_status', ''), 'lat': result['geometry']['location']['lat'],
             'lng': result['geometry']['location']['lng']})

# Save the data to a CSV file
csv_filename = 'places_data.csv'
with open(csv_filename, 'w', newline='', encoding='utf-8') as csv_file:
    fieldnames = ['type', 'name', 'address', 'business_status', 'lng', 'lat']
    writer = csv.DictWriter(csv_file, fieldnames=fieldnames)
    writer.writeheader()
    writer.writerows(data)

print(f'Saved the data to {csv_filename}.')
