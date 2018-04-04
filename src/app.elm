import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

-- Models
         
type ProductId = ProductId Int
type BagItemId = BagItemId Int
type alias BagItem = {id : BagItemId, productId : ProductId, name : String, price : Float}
type alias Product = {id : ProductId, name : String, price : Float}
type alias Model = { products : List Product, bag : List BagItem }

allProducts =
  [ {id = ProductId 1, name = "Red shirt", price = 10.0}
  , {id = ProductId 989, name = "Green shorts", price = 11.0}
  , {id = ProductId 3248, name = "Black dress", price = 100}
  ]

init = ({products = allProducts, bag = []}, Cmd.none)
  
-- Views
productView product =
  tr [] [td [] [text product.name], td [] [input [type_ "button", value "Add to bag", onClick (AddToBag product)] []]]
  
productListView products =
  div [] 
      [ h2 [] [text "Products"]
      , ul [] (products |> List.map productView)]
  
bagItemView bagItem = 
  tr [] [ td [] [text bagItem.name]
        , td [] [input [type_ "button", value "Remove", onClick (RemoveFromBag bagItem)] []]]
  
bagView bag =
  div [] 
      [ h2 [] [text "Bag"]
      , table [] (bag |> List.map bagItemView)]
  
view : Model -> Html Msg
view model = div [] [productListView model.products, bagView model.bag]

-- App

type Msg = AddToBag Product
         | RemoveFromBag BagItem

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

main = Html.program { update = update,
                      view = view,
                      init = init,
                      subscriptions = (\_ -> Sub.none) }