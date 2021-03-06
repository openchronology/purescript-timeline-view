module Timeline.UI.Timeline where

import Timeline.UI.EventOrTimeSpan (EventOrTimeSpanPoly)
import Timeline.ID.TimeSpace (TimeSpaceID)
import Timeline.ID.Timeline (TimelineID)
import Timeline.ID.Event (EventID)
import Timeline.ID.TimeSpan (TimeSpanID)
import Prelude
import Data.Maybe (Maybe)
import Data.Generic.Rep (class Generic)
import Data.Argonaut (class EncodeJson, class DecodeJson, (:=), (~>), jsonEmptyObject, (.:), decodeJson)
import Data.Array.Unique (UniqueArray)
import Test.QuickCheck (class Arbitrary, arbitrary)
import Test.QuickCheck.UTF8String (genString)

newtype Timeline
  = Timeline
  { name :: String
  , description :: String
  -- TODO color
  , children :: UniqueArray (EventOrTimeSpanPoly EventID TimeSpanID)
  , id :: TimelineID
  , parent :: Maybe TimeSpaceID
  }

derive instance genericTimeline :: Generic Timeline _

derive newtype instance eqTimeline :: Eq Timeline

derive newtype instance showTimeline :: Show Timeline

instance encodeJsonTimeline :: EncodeJson Timeline where
  encodeJson (Timeline { name, description, children, id, parent }) =
    "name" := name
      ~> "description"
      := description
      ~> "children"
      := children
      ~> "id"
      := id
      ~> "parent"
      := parent
      ~> jsonEmptyObject

instance decodeJsonTimeline :: DecodeJson Timeline where
  decodeJson json = do
    o <- decodeJson json
    name <- o .: "name"
    description <- o .: "description"
    children <- o .: "children"
    id <- o .: "id"
    parent <- o .: "parent"
    pure (Timeline { name, description, children, id, parent })

instance arbitraryTimeline :: Arbitrary Timeline where
  arbitrary = do
    name <- genString
    description <- genString
    children <- arbitrary
    id <- arbitrary
    parent <- arbitrary
    pure (Timeline { name, description, children, id, parent })
