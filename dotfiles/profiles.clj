{:user { :plugins [[lein-cljsbuild "1.1.3"]
                   [cider/cider-nrepl "0.12.0"]
                   [weasel  "0.7.0"]
                   [jonase/eastwood  "0.2.3"]
                   [spyscope "0.1.3"]
                   [redl "0.2.4"]
                   [com.cemerick/piggieback  "0.2.1"]] 
        :injections [(require 'spyscope.core)
                     (require '[redl complete core])]
        }}

