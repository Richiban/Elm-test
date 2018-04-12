module Main exposing (main)

import Html exposing (..)
import Models exposing (..)
import Views exposing (..)


emptyProduct : NewProductModel
emptyProduct =
    { name = "", price = "" }


init : ( Model, Cmd msg )
init =
    ( { products = allProducts, bag = [], newProduct = emptyProduct, validationErrors = [] }, Cmd.none )


validate : NewProductModel -> Result (List String) Product
validate { name, price } =
    let
        name1 =
            if name == "" then
                Err "Please give your new product a name"
            else
                Ok name

        price1 =
            String.toFloat price
    in
        case (name1, price1) of
            (Ok name2, Ok price2) ->
                Ok { id = ProductId 0, name = name2, price = price2 }

            (x, y) ->
                let getError result =
                    case result of 
                        Err msg -> Just msg
                        Ok _ -> Nothing
                in
                    [getError x, getError y]
                        |> List.filterMap (\a -> a)
                        |> Err


updateBag : BagMsg -> Model -> (Model, Cmd a)
updateBag msg model =
    case msg of
        AddToBag p ->
            let
                newId =
                    BagItemId ((List.length model.bag) + 1)

                newBagItem =
                    { id = newId, productId = p.id, name = p.name, price = p.price }
            in
                if model.bag |> List.any (\bi -> bi.productId == p.id) then
                    ( model, Cmd.none )
                else
                    ( { model | bag = newBagItem :: model.bag }, Cmd.none )

        RemoveFromBag p ->
            let
                newBag =
                    model.bag |> List.filter (\bi -> bi.id /= p.id)
            in
                ( { model | bag = newBag }, Cmd.none )
        


update : Msg -> Model -> ( Model, Cmd a )
update msg model =
    case msg of
        Bag msg ->
            updateBag msg model
        CommitNewProduct newProductModel ->
            case validate newProductModel of
                Err messages ->
                    ( { model | validationErrors = messages }, Cmd.none )

                Ok newProduct ->
                    ( { model
                        | products = newProduct :: model.products
                        , newProduct = emptyProduct
                        , validationErrors = []
                      }
                    , Cmd.none
                    )

        EditNewProduct msg ->
            case msg of
                UpdateNewProductName newName ->
                    let
                        newProduct =
                            model.newProduct
                    in
                        ( { model | newProduct = { newProduct | name = newName } }, Cmd.none )

                UpdateNewProductPrice newPriceS ->
                    let
                        newProduct =
                            model.newProduct
                    in
                        ( { model | newProduct = { newProduct | price = newPriceS } }, Cmd.none )


main : Program Never Model Msg
main =
    Html.program
        { update = update
        , view = view
        , init = init
        , subscriptions = (\_ -> Sub.none)
        }
