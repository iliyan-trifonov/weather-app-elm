module App exposing (..)


import Html.App
import Time


import Commands exposing (..)
import Models exposing (..)
import Messages exposing (..)
import View exposing (..)
import Update exposing (..)



initialModel : Model
initialModel =
  { apiKeys = { worldweatheronline = "", openweathermap = ""  }
  , apiPos = { lat = "", lon = "" }
  , error = ""
  , sea_temp = -1
  , pool_temp = -1
  , air_temp = -1
  , air_humidity = -1
  , air_pressure = -1
  }


init : (Model, Cmd Msg)
init =
  (initialModel, getConfig)


subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every Time.minute UpdateData


-- MAIN

main : Program Never
main =
  Html.App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
