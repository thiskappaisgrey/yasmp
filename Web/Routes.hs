module Web.Routes where
import IHP.RouterPrelude
import Generated.Types
import Web.Types

-- Generator Marker
instance AutoRoute PostsController
type instance ModelControllerMap WebApplication Post = PostsController
