{:user {:plugins [[lein-cljsbuild "1.1.3"]
                  [lein-clojars "0.9.1"]
                  [lein-codox  "0.9.5"]
                  [chestnut/lein-template  "0.12.0"]
                  [lein-auto  "0.1.2"]]
        :dependencies [[spyscope "0.1.5"]
                       [org.clojure/tools.namespace "0.2.11"]
                       [io.aviso/pretty "0.1.26"]
                       [leiningen-core  "2.3.4"] 
                       [cider/cider-nrepl "0.12.0"]
                       [weasel  "0.7.0"]
                       [jonase/eastwood  "0.2.3"]
                       [redl "0.2.4"]
                       [com.cemerick/piggieback  "0.2.1"]
                       [im.chit/hara.reflect  "2.3.7"]
                       [im.chit/wu.kong  "0.1.2"]
                       [im.chit/vinyasa "0.4.7"]]
        :injections [(require 'spyscope.core)
                     (require '[vinyasa.inject :as inject])
                     (require 'io.aviso.repl)
                     (inject/in ;; the default injected namespace is `.`

                                ;; note that `:refer, :all and :exclude can be used
                                [vinyasa.inject :refer [inject [in inject-in]]]

                                ;; imports all functions in vinyasa.pull
                                [vinyasa.maven pull]

                                ;; inject into clojure.core
                                clojure.core
                                [vinyasa.reflection .> .? .* .% .%> .& .>ns .>var]

                                ;; inject into clojure.core with prefix
                                clojure.core >
                                [clojure.pprint pprint]
                                [clojure.java.shell sh])]}}

