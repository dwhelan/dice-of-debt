require_relative 'api/api'
require_relative 'api/presenters'
require_relative 'api/root'
require_relative 'api/errors'
require_relative 'api/iterations'
require_relative 'api/rolls'
require_relative 'api/games'
require_relative 'api/swagger_doc'

# This should be the last route as it will match any path
require_relative 'api/not_found'

# This should follow all resource routes to enable CORS
require_relative 'api/cors'
