module Models exposing (..)


type alias Model =
  { apiKeys: ConfigObjKeys
  , apiPos : ConfigObjPos
  , error : String
  , sea_temp : Int
  , pool_temp : Int
  , air_temp : Int
  , air_humidity : Int
  , air_pressure : Int
  }

type alias DecObj =
  { air_temp : Int
  , air_humidity: Int
  , air_pressure : Int
  }

type alias ConfigObjKeys =
  { worldweatheronline: String
  , openweathermap: String
  }

type alias ConfigObjPos =
  { lat: String
  , lon: String
  }

type alias ConfigObj =
  { keys: ConfigObjKeys
  , pos: ConfigObjPos
  }

type alias CurrentHour =
  Int

type alias Hours =
  List WeatherHour

type alias WeatherData =
  { weather : List WeatherDate }

type alias WeatherDate =
  { hourly : List WeatherHour }

type alias WeatherHour =
  { time : String
  , temp : String
  }
