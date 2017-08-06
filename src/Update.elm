module Update exposing (..)


import String


import Models exposing (..)
import Messages exposing (..)
import Commands exposing (..)



getFromMayBe : Maybe WeatherDate -> WeatherDate
getFromMayBe mx =
  case mx of
    Nothing ->
      Debug.crash "empty value"

    Just x ->
      x


findHour : CurrentHour -> Hours -> ( String, String )
findHour currentHour hours =
  case hours of
    [] ->
      ( "", "" )

    (x::xs) ->
      if (stringToInt x.time) > currentHour then
        ( x.time, x.temp )
      else
        findHour currentHour xs


stringToInt : String -> Int
stringToInt str =
  case String.toInt str of
    Err err ->
      Debug.crash "error" err

    Ok int ->
      int


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    FetchSuccess decodedObj ->
      ( { model | air_temp = decodedObj.air_temp
        , air_humidity = decodedObj.air_humidity
        , air_pressure = decodedObj.air_pressure
        }
        , Cmd.none )

    FetchExtraSuccess decodedObj ->
      let
        firstWeather = List.head decodedObj.weather
        x = getFromMayBe firstWeather
        hourly = x.hourly
        (hourFound, tempFound) = findHour 200 hourly
      in
        ( { model | sea_temp = stringToInt tempFound }, Cmd.none )

    FetchError error ->
      ( { model | error = toString error }, hideError )

    FetchExtraError error ->
      ( { model | error = toString error }, hideError )

    UpdateData _ ->
      if model.apiKeys.openweathermap == "" || model.apiKeys.worldweatheronline == "" then
        ( { model | error = "No API keys defined" }, Cmd.none )
      else if model.apiPos.lat == "" || model.apiPos.lon == "" then
        ( { model | error = "No Lat or Lon defined" }, Cmd.none )
      else
        ( model, Cmd.batch [
          fetch (model.apiPos.lat, model.apiPos.lon, model.apiKeys.openweathermap)
          , fetchExtra (model.apiPos.lat, model.apiPos.lon, model.apiKeys.worldweatheronline)
        ] )

    HideError ->
      ( { model | error = "" }, Cmd.none )

    NoOp ->
      ( model, Cmd.none )

    GetConfigFail error ->
      ( { model | error = toString error }, hideError )

    GetConfigSuccess {pos, keys} ->
      if keys.openweathermap == "" || keys.worldweatheronline == "" then
        ( { model | error = "No API keys defined" }, Cmd.none )
      else if pos.lat == "" || pos.lon == "" then
        ( { model | error = "No Lat or Lon defined" }, Cmd.none )
      else
        ( { model | apiKeys = keys, apiPos = pos }, Cmd.batch [
          fetch (pos.lat, pos.lon, keys.openweathermap)
          , fetchExtra (pos.lat, pos.lon, keys.worldweatheronline)
          ] )
