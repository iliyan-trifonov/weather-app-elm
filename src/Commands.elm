module Commands exposing (..)


import Process
import Time
import Task
import Messages exposing (..)
import Json.Decode as Decode exposing ((:=))
import Models exposing (..)
import Http



hideError : Cmd Msg
hideError =
  Process.sleep (10 * Time.second)
    |> Task.perform (\_ -> NoOp) (\_ -> HideError)


weatherDecoder : Decode.Decoder DecObj
weatherDecoder =
  let
    decoder = Decode.object3 DecObj
      ( "temp" := Decode.int )
      ( "humidity" := Decode.int )
      ( "pressure" := Decode.int )
  in
    Decode.at ["main"] decoder


weatherDateDecoder : Decode.Decoder WeatherDate
weatherDateDecoder =
  Decode.object1 WeatherDate
    ( "hourly" := Decode.list hourDecoder )


hourDecoder : Decode.Decoder WeatherHour
hourDecoder =
  Decode.object2 WeatherHour
    ( "time" := Decode.string )
    (  "waterTemp_C" := Decode.string )


extraDecoder : Decode.Decoder WeatherData
extraDecoder =
  let
    decoder = Decode.object1 WeatherData
      ( "weather" := Decode.list weatherDateDecoder )
  in
    Decode.at ["data"] decoder


configKeysDecoder : Decode.Decoder ConfigObjKeys
configKeysDecoder =
  let
    decoder = Decode.object2 ConfigObjKeys
      ("worldweatheronline" := Decode.string)
      ("openweathermap" := Decode.string)
  in
    Decode.at ["keys"] decoder


configPosDecoder : Decode.Decoder ConfigObjPos
configPosDecoder =
  let
    decoder = Decode.object2 ConfigObjPos
      ("lat" := Decode.string)
      ("lon" := Decode.string)
  in
    Decode.at ["pos"] decoder

configDecoder : Decode.Decoder ConfigObj
configDecoder =
  let
    decoder = Decode.object2 ConfigObj
      configKeysDecoder
      configPosDecoder
  in
    Decode.at ["api"] decoder


fetch : (String, String, String) -> Cmd Msg
fetch (lat, lon, key) =
  Http.get weatherDecoder ("http://api.openweathermap.org/data/2.5/weather?lat=" ++ lat ++ "&lon=" ++ lon ++ "&units=metric&APPID=" ++ key)
    |> Task.perform FetchError FetchSuccess


fetchExtra : (String, String, String) -> Cmd Msg
fetchExtra (lat, lon, key) =
  Http.get extraDecoder ("http://api.worldweatheronline.com/premium/v1/marine.ashx?q=" ++ lat ++ "," ++ lon ++ "&format=json&key=" ++ key)
    |> Task.perform FetchExtraError FetchExtraSuccess

getConfig : Cmd Msg
getConfig =
  Http.get configDecoder "config.json"
    |> Task.perform GetConfigFail GetConfigSuccess
