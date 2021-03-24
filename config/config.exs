import Config

config :phoenix, :json_library, Jason

# Usage example
config :do_auth, DoAuth.Web, hello: :world, answer: 42

# http://www.petecorey.com/blog/2019/05/20/minimum-viable-phoenix/ thank you, Pete!
import_config "#{Mix.env()}.exs"
