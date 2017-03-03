use Mix.Config

config :kv, :routing_table,
      [{?a..?m, :"foo@ferocity"},
       {?n..?z, :"bar@ferocity"}]
