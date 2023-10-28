################
#  to run use:
#    $ ruby  sandbox/test_typed.rb


##
## note: depends on (some) activesupport (rails-y) extensions
# Array.exclude?
#  ...
require 'active_support/all'



require_relative '../lib/contract_errors'

require_relative '../lib/attr_public_read_private_write'
require_relative '../lib/type'
require_relative '../lib/typed_variable'
require_relative '../lib/array_type'
require_relative '../lib/mapping_type'
require_relative '../lib/contract_type'



pp Type::INTEGER_TYPES
pp Type::TYPES
#=> [:string,
#    :mapping,
#    :address,
#    :bytes32,
#    :contract,
#    :bool,
#    :address,
#    :uint256, :int256,
#    :array,
#    :datetime,
#    :bytes,
  


### try create typed vars

## value types
uint = TypedVariable.create( :uint256, 111 )
pp uint

string = TypedVariable.create( :string, 'Hello, World!' )
pp string
 
addr = TypedVariable.create( :address )
pp addr

bytes = TypedVariable.create( :bytes32 ) 
pp bytes


## reference types




puts "bye"