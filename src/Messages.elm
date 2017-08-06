module Messages exposing (..)


import Models exposing (..)
import Http
import Time



type Msg
  = FetchSuccess DecObj
  | FetchError Http.Error
  | FetchExtraSuccess WeatherData
  | FetchExtraError Http.Error
  | GetConfigSuccess ConfigObj
  | GetConfigFail Http.Error
  | UpdateData Time.Time
  | NoOp
  | HideError
