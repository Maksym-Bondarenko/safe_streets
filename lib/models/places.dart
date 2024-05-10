import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'places.freezed.dart';
part 'places.g.dart';

const placePredictionKey = 'placePrediction';
const queryPredictionKey = 'queryPrediction';

@freezed
class PlacesResponse with _$PlacesResponse {
  const factory PlacesResponse(List<Place> places) = PlacesResponseData;

  factory PlacesResponse.fromJson(Map<String, dynamic> json) => _$PlacesResponseFromJson(json);
}

@freezed
class Place with _$Place {
  const factory Place({
    required Location location,
    required TextData displayName,
  }) = _Place;

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);
}

@freezed
class Location with _$Location {
  const factory Location({
    required double latitude,
    required double longitude,
  }) = _Location;

  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);
}

@freezed
class AutocompleteResponse with _$AutocompleteResponse {
  const factory AutocompleteResponse(@SuggestionConverter() List<Suggestion> suggestions) = AutocompleteResponseData;

  factory AutocompleteResponse.fromJson(Map<String, dynamic> json) => _$AutocompleteResponseFromJson(json);
}

@freezed
sealed class Suggestion with _$Suggestion {
  const factory Suggestion.place({
    required String place,
    required String placeId,
    required TextMatchData text,
    required StructuredFormatData structuredFormat,
    required List<PlaceType> types,
  }) = PlaceSuggestion;

  @SuggestionConverter()
  const factory Suggestion.query({
    required StructuredFormatData structuredFormat,
    required TextMatchData text,
  }) = QuerySuggestion;

  factory Suggestion.fromJson(Map<String, dynamic> json) => _$SuggestionFromJson(json);
}

class SuggestionConverter implements JsonConverter<Suggestion, Map<String, dynamic>> {
  const SuggestionConverter();

  @override
  Suggestion fromJson(Map<String, dynamic> json) {
    if (json.containsKey(placePredictionKey)) {
      return PlaceSuggestion.fromJson(json[placePredictionKey]);
    } else if (json.containsKey(queryPredictionKey)) {
      return QuerySuggestion.fromJson(json[queryPredictionKey]);
    } else {
      throw Exception('Could not determine the constructor for mapping prediction from JSON');
    }
  }

  @override
  Map<String, dynamic> toJson(Suggestion data) =>
      data.map(place: (p) => {placePredictionKey: p.toJson()}, query: (q) => {queryPredictionKey: q.toJson()});
}

@freezed
class StructuredFormatData with _$StructuredFormatData {
  const factory StructuredFormatData({
    required TextMatchData mainText,
    TextData? secondaryText,
  }) = _StructuredFormatData;

  factory StructuredFormatData.fromJson(Map<String, dynamic> json) => _$StructuredFormatDataFromJson(json);
}

@freezed
class TextMatchData with _$TextMatchData {
  const factory TextMatchData({
    required String text,
    required List<MatchData> matches,
  }) = _TextMatchData;

  factory TextMatchData.fromJson(Map<String, dynamic> json) => _$TextMatchDataFromJson(json);
}

@freezed
class TextData with _$TextData {
  const factory TextData({
    required String text,
  }) = _TextData;

  factory TextData.fromJson(Map<String, dynamic> json) => _$TextDataFromJson(json);
}

@freezed
class MatchData with _$MatchData {
  const factory MatchData({
    required int endOffset,
  }) = _MatchData;

  factory MatchData.fromJson(Map<String, dynamic> json) => _$MatchDataFromJson(json);
}

@JsonEnum(
  fieldRename: FieldRename.snake,
  alwaysCreate: true,
)
enum PlaceType {
  // Automotive
  carDealer,
  carRental,
  carRepair,
  carWash,
  electricVehicleChargingStation,
  gasStation,
  parking,
  restStop,

  // Business
  farm,

  // Culture
  artGallery,
  museum,
  performingArtsTheater,

  // Education
  library,
  preschool,
  primarySchool,
  school,
  secondarySchool,
  university,

  // Entertainment and Recreation
  amusementCenter,
  amusementPark,
  aquarium,
  banquetHall,
  bowlingAlley,
  casino,
  communityCenter,
  conventionCenter,
  culturalCenter,
  dogPark,
  eventVenue,
  hikingArea,
  historicalLandmark,
  marina,
  movieRental,
  movieTheater,
  nationalPark,
  nightClub,
  park,
  touristAttraction,
  visitorCenter,
  weddingVenue,
  zoo,

  // Finance
  accounting,
  atm,
  bank,

  // Food and Drink
  americanRestaurant,
  bakery,
  bar,
  barbecueRestaurant,
  brazilianRestaurant,
  breakfastRestaurant,
  brunchRestaurant,
  cafe,
  chineseRestaurant,
  coffeeShop,
  fastFoodRestaurant,
  frenchRestaurant,
  greekRestaurant,
  hamburgerRestaurant,
  iceCreamShop,
  indianRestaurant,
  indonesianRestaurant,
  italianRestaurant,
  japaneseRestaurant,
  koreanRestaurant,
  lebaneseRestaurant,
  mealDelivery,
  mealTakeaway,
  mediterraneanRestaurant,
  mexicanRestaurant,
  middleEasternRestaurant,
  pizzaRestaurant,
  ramenRestaurant,
  restaurant,
  sandwichShop,
  seafoodRestaurant,
  spanishRestaurant,
  steakHouse,
  sushiRestaurant,
  thaiRestaurant,
  turkishRestaurant,
  veganRestaurant,
  vegetarianRestaurant,
  vietnameseRestaurant,

  // Geographical Areas
  administrativeAreaLevel1,
  administrativeAreaLevel2,
  country,
  locality,
  postalCode,
  schoolDistrict,

  // Government
  cityHall,
  courthouse,
  embassy,
  fireStation,
  localGovernmentOffice,
  police,
  postOffice,

  // Health and Wellness
  dentalClinic,
  dentist,
  doctor,
  drugstore,
  hospital,
  medicalLab,
  pharmacy,
  physiotherapist,
  spa,

  // Lodging
  bedAndBreakfast,
  campground,
  campingCabin,
  cottage,
  extendedStayHotel,
  farmstay,
  guestHouse,
  hostel,
  hotel,
  lodging,
  motel,
  privateGuestRoom,
  resortHotel,
  rvPark,

  // Places of Worship
  church,
  hinduTemple,
  mosque,
  synagogue,

  // Services
  barberShop,
  beautySalon,
  cemetery,
  childCareAgency,
  consultant,
  courierService,
  electrician,
  florist,
  funeralHome,
  hairCare,
  hairSalon,
  insuranceAgency,
  laundry,
  lawyer,
  locksmith,
  movingCompany,
  painter,
  plumber,
  realEstateAgency,
  roofingContractor,
  storage,
  tailor,
  telecommunicationsServiceProvider,
  travelAgency,
  veterinaryCare,

  // Shopping
  autoPartsStore,
  bicycleStore,
  bookStore,
  cellPhoneStore,
  clothingStore,
  convenienceStore,
  departmentStore,
  discountStore,
  electronicsStore,
  furnitureStore,
  giftShop,
  groceryStore,
  hardwareStore,
  homeGoodsStore,
  homeImprovementStore,
  jewelryStore,
  liquorStore,
  market,
  petStore,
  shoeStore,
  shoppingMall,
  sportingGoodsStore,
  store,
  supermarket,
  wholesaler,

  // Sports
  athleticField,
  fitnessCenter,
  golfCourse,
  gym,
  playground,
  skiResort,
  sportsClub,
  sportsComplex,
  stadium,
  swimmingPool,

  // Transportation
  airport,
  busStation,
  busStop,
  ferryTerminal,
  heliport,
  lightRailStation,
  parkAndRide,
  subwayStation,
  taxiStand,
  trainStation,
  transitDepot,
  transitStation,
  truckStop,

  // Additional Place Type Values
  administrativeAreaLevel3,
  administrativeAreaLevel4,
  administrativeAreaLevel5,
  administrativeAreaLevel6,
  administrativeAreaLevel7,
  archipelago,
  colloquialArea,
  continent,
  establishment,
  floor,
  food,
  generalContractor,
  geocode,
  health,
  intersection,
  landmark,
  naturalFeature,
  neighborhood,
  placeOfWorship,
  plusCode,
  pointOfInterest,
  political,
  postBox,
  postalCodePrefix,
  postalCodeSuffix,
  postalTown,
  premise,
  room,
  route,
  streetAddress,
  streetNumber,
  sublocality,
  sublocalityLevel1,
  sublocalityLevel2,
  sublocalityLevel3,
  sublocalityLevel4,
  sublocalityLevel5,
  subpremise,
  townSquare;

  factory PlaceType.fromJson(String json) => _$PlaceTypeEnumMap.map((key, value) => MapEntry(value, key))[json]!;

  String toJson() => _$PlaceTypeEnumMap[this]!.replaceFirstMapped(RegExp(r'\d'), (m) => '_${m[0]}');
}
