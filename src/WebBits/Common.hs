-- | Defines commonly used datatypes and functions.
module WebBits.Common
  ( PrettyPrintable(..)
  , L.isPrefixOf
  , SourcePos
  , sourceName
  ) where


import Control.Applicative
import Control.Monad.State.Strict
import Control.Monad.Identity

import Data.Map (Map)
import Data.Maybe (catMaybes)
import Data.Char (toLower)
import qualified Data.List as L
import Data.Generics hiding (GT)
import qualified Data.Foldable as Foldable
import Data.Foldable (Foldable)
import qualified Data.Traversable as Traversable
import Data.Traversable (Traversable, traverse)

import qualified System.IO as IO

import qualified Text.PrettyPrint.HughesPJ as Pp
import Text.Parsec.Pos ( SourcePos, initialPos, sourceName )

lowercase = map toLower

-- | 'PrettyPrintable' makes writing pretty-printing code for large, recursive
-- data structures shorter.
class PrettyPrintable a where
  pp:: a -> Pp.Doc
  
instance PrettyPrintable a => PrettyPrintable (Maybe a) where
  pp (Just a) = pp a
  pp Nothing  = Pp.empty

--------------------------------------------------------------------------------
-- Generics for SourcePos

-- | These definitions allow us to use data structures containing 'SourcePos'
-- values with generics.

-- |We make 'SourcePos' an instance of 'Typeable' so that we can use it with
-- generics.
instance Typeable SourcePos where
  typeOf _  = 
    mkTyConApp (mkTyCon "Text.Parsec.Pos.SourcePos") []
    
-- Complete guesswork.  It seems to work.
sourcePosDatatype = mkDataType "SourcePos" [sourcePosConstr1]
sourcePosConstr1 = mkConstr sourcePosDatatype "SourcePos" [] Prefix

-- |We make 'SourcePos' an instance of 'Typeable' so that we can use it with
-- generics.
--
-- This definition is incomplete.
instance Data SourcePos where
  -- We treat source locations as opaque.  After all, we don't have access to
  -- the constructor.
  gfoldl k z pos = z pos
  toConstr _ = sourcePosConstr1
  gunfold   = error "gunfold is not defined for SourcePos"
  dataTypeOf = error "dataTypeOf is not defined for SourcePos"

