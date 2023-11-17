################
#  to run use:
#    $ ruby  sandbox/test_typed.rb


$LOAD_PATH.unshift( './lib' )
require '0xfacet/typed'



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

## arrays
type = Type.create(:array, value_type: :uint256 )
ary = TypedVariable.create( type )
pp ary
ary.push( 1 )
ary.push( 2 )
ary.push( 3 )
pp ary.length
pp ary[0]
pp ary[1]
pp ary[2]
pp ary

type = Type.create(:array, value_type: :string )
ary = TypedVariable.create( type )
pp ary
ary.push( 'one' )
ary.push( 'two' )
pp ary.length
pp ary[0]
pp ary[1]
pp ary


## mappings
type = Type.create(:mapping, key_type: :string, value_type: :uint256 )
map = TypedVariable.create( type )
pp map
map['one'] = 1
map['two'] = 2
map['one']
map['two']
pp map


puts "bye"