module Main exposing (main)

import Html exposing (..)

import Models exposing (..)
import Views exposing (..)

init : ( Model, Cmd msg )
init = 
  let
    emptyProduct = {id = ProductId 0, name = "", price = 0.0}
  in ({products = allProducts, bag = [], newProduct = emptyProduct}, Cmd.none)
  

update: Msg -> Model -> (Model, Cmd a)
update msg model =
  case msg of
    AddToBag p -> 
      let 
        newId = BagItemId ((List.length model.bag) + 1)
        newBagItem = {id = newId, productId = p.id, name = p.name, price = p.price}
      in 
        if model.bag |> List.any (\bi -> bi.productId == p.id)
        then (model, Cmd.none)
        else ({ model | bag = newBagItem :: model.bag }, Cmd.none)
    RemoveFromBag p ->
      let newBag = model.bag |> List.filter (\bi -> bi.id /= p.id)
      in ({model | bag = newBag}, Cmd.none)
    CommitNewProduct newProduct ->
      ({ model | products = newProduct :: model.products }, Cmd.none)
    UpdateNewProductName newName -> 
      let newProduct = model.newProduct
      in ({model | newProduct = {newProduct | name = newName}}, Cmd.none)

main : Program Never Model Msg
main = Html.program { update = update,
                      view = view,
                      init = init,
                      subscriptions = (\_ -> Sub.none) }