module View exposing (..)


import Html exposing (Html, table, tr, th, td, text, span, node, div, a)
import Html.Attributes exposing (class, property, colspan, rel, href, id)
import Messages exposing (..)
import Json.Encode
import String
import Models exposing (..)



view : Model -> Html Msg
view model =
  div []
      [ table [ class "weather_data" ]
          [ tr []
            [ th []
              [ text "Температура на морската вода:" ]
            , td [ class "digital" ] [ text (toString model.sea_temp) ]
            ]

          , tr []
            [ th []
              [ text "Температура на водата в басейна:" ]
            , td [ class "digital" ] [ text (toString model.pool_temp) ]
            ]

          , tr []
            [ th []
              [ text "Температура на въздуха:" ]
            , td [ class "digital" ]
                [ text (toString model.air_temp)
                , span [ property "innerHTML" (Json.Encode.string "&deg; C") ] []
                ]
            ]

          , tr []
            [ th []
              [ text "Влажност на въздуха:" ]
            , td [ class "digital" ]
              [ text ((toString model.air_humidity) ++ "%") ]
            ]

          , tr []
            [ th []
              [ text "Атмосферно налягане:" ]
            , td [ class "digital" ] [ text ((toString model.air_pressure) ++ " hPa") ]
            ]
          , (if String.isEmpty model.error == False then
              tr []
                [ td [ colspan 2, class "error_message" ]
                    [ text ("Error: " ++ model.error) ]
                ]
            else
              text ""
            )
          ]
      , div [ class "weather bottom-links" ]
          [ span [] [ text "Версия: " ]
          , span [] [ text "Elm" ]
          , span [] [ text " | " ]
          , a [ href "/vanillajs/" ] [ text "VanillaJS" ]
          ]
      ]
