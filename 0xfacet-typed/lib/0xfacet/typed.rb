
##
## note: depends on (some) activesupport (rails-y) extensions
# Array.exclude?
#  ...
require 'active_support/all'


## our own code
require_relative 'typed/version'     ## let version always go first

require_relative 'typed/contract_errors'   ## move upstream to 0xfacet !!!

require_relative 'typed/attr_public_read_private_write'
require_relative 'typed/type'
require_relative 'typed/typed_variable'
require_relative 'typed/array_type'
require_relative 'typed/mapping_type'
require_relative 'typed/contract_type'



puts Facet::Module::Typed.banner     ## say hello
