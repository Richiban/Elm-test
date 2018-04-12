module Models exposing (..)


type ProductId
    = ProductId Int


type BagItemId
    = BagItemId Int


type alias BagItem =
    { id : BagItemId, productId : ProductId, name : String, price : Float }


type alias Product =
    { id : ProductId, name : String, price : Float }


type alias Model =
    { products : List Product
    , bag : List BagItem
    , newProduct : NewProductModel
    , validationErrors : List String
    }


type alias NewProductModel =
    { name : String, price : String }


allProducts : List Product
allProducts =
    [ { id = ProductId 1, name = "Red shirt", price = 10.0 }
    , { id = ProductId 989, name = "Green shorts", price = 11.0 }
    , { id = ProductId 3248, name = "Black dress", price = 100 }
    , { id = ProductId 3241, name = "Blue pants", price = 100 }
    ]


type Msg
    = Bag BagMsg
    | CommitNewProduct NewProductModel
    | EditNewProduct NewProductMsg

type BagMsg
    = AddToBag Product
    | RemoveFromBag BagItem


type NewProductMsg
    = UpdateNewProductName String
    | UpdateNewProductPrice String
