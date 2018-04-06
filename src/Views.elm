module Views exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Models exposing (..)

productView : Product -> Html Msg
productView product =
  tr [] [
    td [] [
      text product.name
    ], 
    td [] [
      input [type_ "button", value "Add to bag", onClick (AddToBag product)] []
    ]
  ]
  
productListView : List Product -> Html Msg
productListView products =
  div [] 
      [ h2 [] [text "Products"]
      , ul [] (products |> List.map productView)]
  
bagItemView : { id : BagItemId, name : String, price : Float, productId : ProductId } -> Html Msg
bagItemView bagItem = 
  tr [] [ td [] [text bagItem.name]
        , td [] [input [type_ "button", value "Remove", onClick (RemoveFromBag bagItem)] []]]
  
bagView : List BagItem -> Html Msg
bagView bag =
  div [] 
      [ h2 [] [text "Bag"]
      , table [] (bag |> List.map bagItemView)]

inputView: Product -> Html Msg
inputView newProduct =
  div [] [
    h2 [] [text "Enter a new product"],
    input [type_ "text", 
           placeholder "Id", 
           value (toString newProduct.id)] [],
    input [type_ "text", 
           placeholder "Name",
           onInput UpdateNewProductName,
           value newProduct.name] [],
    input [type_ "text", placeholder "Price", value (toString newProduct.price)] [],
    button [onClick (CommitNewProduct newProduct)] [text "Ok"]
  ]
  
view : Model -> Html Msg
view model = div [] [
    productListView model.products,
    bagView model.bag,
    inputView model.newProduct
  ]