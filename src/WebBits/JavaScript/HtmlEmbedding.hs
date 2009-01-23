module WebBits.JavaScript.HtmlEmbedding
  ( JsHtml
  , ParsedJavaScript
  , ParsedJsHtml
  ) where


import Text.Parsec ( SourcePos )

import WebBits.Html.Syntax(Html,Script,parseScriptBlock,parseInlineScript,
                   parseAttributeScript)
import WebBits.JavaScript.Parser(parseScript)
import WebBits.JavaScript.Syntax(JavaScript)
--import JavaScript.PrettyPrint -- for the instance declaration

type JsHtml a = Html SourcePos (JavaScript a)

type ParsedJavaScript = JavaScript SourcePos

type ParsedJsHtml = JsHtml SourcePos

instance Script ParsedJavaScript where
  parseScriptBlock attrs = do
    parseScript
  parseInlineScript = Nothing
  parseAttributeScript = Nothing
    
  
