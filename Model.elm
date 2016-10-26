port module Model exposing (..)

import Keyboard
import Material


-- Ports


port saveUser : User -> Cmd msg


port startStorySizing : Story -> Cmd msg


port addVote : Vote -> Cmd msg


port voteAdded : (Vote -> msg) -> Sub msg


port revealVotes : Bool -> Cmd msg


port votesRevealed : (Bool -> msg) -> Sub msg


port archiveStory : Story -> Cmd msg


port storyArchived : (Story -> msg) -> Sub msg


port storySizingStarted : (Story -> msg) -> Sub msg


port storySizingEnded : (String -> msg) -> Sub msg



-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Keyboard.presses KeyMsg
        , voteAdded VoteAdded
        , storyArchived StoryArchived
        , storySizingStarted StorySizingStarted
        , storySizingEnded StorySizingEnded
        , votesRevealed VotesRevealed
        ]



-- Model


type alias Mdl =
    Material.Model


type alias Flags =
    { uuid : String
    , userName : String
    , userId : String
    }


type alias Model =
    { user : Maybe User
    , uuid : String
    , story : Maybe Story
    , storyInput : String
    , userInput : String
    , error : Maybe String
    , votes : List Vote
    , revealVotes : Bool
    , sizedStories : List Story
    , isDataLoaded : Bool
    , mdl :
        Material.Model
        -- Boilerplate: model store for any and all Mdl components you use.
    , selectedTab : Int
    }


type alias User =
    { name : String
    , id : String
    }


type alias Vote =
    { points : Float
    , user : User
    }


type alias Story =
    { name : String
    , points : Float
    , owner : User
    }


initModel : Model
initModel =
    --{ user = Just (User "Andrey Marushkevych" "123")
    { user = Nothing
    , uuid = ""
    , story = Nothing
    , storyInput = ""
    , userInput = ""
    , error = Nothing
    , votes = []
    , revealVotes = True
    , sizedStories = []
    , isDataLoaded = False
    , mdl =
        Material.model
        -- Boilerplate: Always use this initial Mdl model store.
    , selectedTab = 0
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    if not (flags.userName == "" || flags.userId == "") then
        ( { initModel
            | user = Just (User flags.userName flags.userId)
            , uuid = flags.uuid
            , userInput = flags.userName
          }
        , Cmd.none
        )
    else
        ( { initModel | uuid = flags.uuid }, Cmd.none )


hasVoted : Model -> Bool
hasVoted model =
    case model.user of
        Nothing ->
            Debug.crash "User should be initialized"

        Just user ->
            let
                existingVotes =
                    List.filter (.user >> .id >> ((==) (user |> .id))) model.votes
            in
                not (List.isEmpty existingVotes)



-- Update


type Msg
    = StartStorySizing
    | CreateUser
    | UserInput String
    | StoryInput String
    | Size Float
    | VoteAdded Vote
      -- | RevealVotes
    | VotesRevealed Bool
    | SelectVote Vote
    | StoryArchived Story
    | KeyMsg Keyboard.KeyCode
    | StorySizingStarted Story
    | StorySizingEnded String
    | Mdl (Material.Msg Msg)
    | SelectTab Int
