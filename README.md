# Rubidity O.G (Dumb Contracts) Public Code Review / (More) Tests


The idea is to look at the code as-is (that is, not suggestion new or alternate syntax) in the review / commentary 
and try to add (more) tests.

**Yes, you can.  You are welcome to join in and comments / discuss / debate.**




## "Off-Rails"  - Rubidity Core NOT "Isolated"

Let's say it out loud - Rails is great. It's magic. It's amazing.

However, to make the rubidity core execution engine (interpreter)
more secure (and smaller and simpler) less dependencies is more!

Thus, allow me to preach again and again
to break out ("isolate") the rubidity core code 
to make it run "off-rails", that only requires "plain ruby"
with "zero-dependencies" on any activesupport (rails-y) "magic".

This makes testing easier because the "isolated" core
can get tested with "zero-dependency" and as the saying goes
a strong solid foundation will help you for sure in the future to 
build out big big things.





## Rubidity Types

the (core typed) code is:
- [type.rb](typed/lib/type.rb)
- [typed_variable.rb](typed/lib/typed_variable.rb)
- [array_type.rb](typed/lib/array_type.rb)
- [mapping_type.rb](typed/lib/mapping_type.rb)
- [contract_type.rb](typed/lib/contract_type.rb)



the great news - this code for the type machinery is basically "isolated"
and i recommend to move it to its own module as the foundation types (library) incl. the rspec tests.

<details>
<summary markdown="1">Show respc test results</summary>

```
rubidity.review\typed> rspec
..............

Finished in 0.14714 seconds (files took 13.25 seconds to load)
14 examples, 0 failures
```

or

```
rubidity.review\typed> rspec --format documentation

Type
  #can_be_assigned_from?
    returns true if types are the same
    returns true if both types are integer types and the number of bits of the first type is greater than or equal to the number of bits of the second type
    returns false otherwise
    returns true if a literal can be assigned to the type
    raises a VariableTypeError if a literal cannot be assigned to the type
  #values_can_be_compared?
    returns true if types are compatible
    returns true if both types are integer types
    returns false otherwise
    returns true if a literal can be compared with the type
    returns false if a literal cannot be compared with the type

TypedVariable
  .create_or_validate
    returns the same TypedVariable if the value is a TypedVariable and its type can be assigned from the specified type
    is fine to go up in bits
    creates a new TypedVariable if the value is not a TypedVariable
    raises a VariableTypeError if the value is a TypedVariable and its type cannot be assigned from the specified type

Finished in 0.08964 seconds (files took 4.97 seconds to load)
14 examples, 0 failures
```

</details>



### Serialize / Deserialize

The current code uses a "typed var holder" class with "replace" semantics.
"Replace" semantics is flawed because you CANNOT replace, for example,
a bool true or false or (if added enums that are integer constants).

The better approach is to ALWAYS create a new typed var (and never "replace" inline). Once created you CANNOT change the value inplace.
Of course, if the typed var is a reference type such as array or mapping
you CAN change / replace the mapping or array items.

The deserialize SHOULD not be method of typed variable 
because it assumes "replace" semantics. 


Aside:  "replace" semantics?!

```ruby
  def value=(new_value)
     # ...
  end

  def deserialize(serialized_value)
    self.value = serialized_value
  end  
```

the value gets replaced inline using `value=`. the value should only
get set only once on init!  and than is unreplaceable (immutable). create a new typed variable instead of replace inline.




### Method Missing Magic & "Explicit" One-to-One Type Mappings Instead Of "Quick & Dirty" Generic Type "Wrappers" 

For now only mapping and array get an explicit typed class.
All other "value" types are (re)using a kind of genric typed class
that than delegates via method_missing to wherever.
Yes, a security and performance nightmare.
While this approach may look like ingenious for being "quick & dirty"
it is a clasic anti-pattern / major design flaw, that is,
do NOT use method_missing UNLESS it is the last option.
And options are many with the preference of doing the hard work
coding and writing out all the types one by one!


Aside - method_missing?!

``` ruby
  def method_missing(name, *args, &block)
    if value.respond_to?(name)
      result = value.send(name, *args, &block)
      
      if result.class == value.class
        begin
          result = type.check_and_normalize_literal(result)
        rescue ContractErrors::VariableTypeError => e
          if type.is_uint?
            result = TypedVariable.create(:uint256, result)
          else
            raise
          end
        end
      end
      
      result
      
      if name.to_s.end_with?("=") && !%w[>= <=].include?(name.to_s[-2..])
        self.value = result if type.is_value_type?
        self
      else
        result
      end
    else
      super
    end
  end
```



### Layers, Layers, Layers (Proxies, Proxies, Proxies) - No Lasagna

The array and mapping typed variable use "proxy classes" inside
the typed variable. That proxy / layer inside the typed classes 
is redundant.  The typed variable / class is already the "proxy" or "front" to define the API for the type, thus, less is more.  better security by keeping it simple.



Twin Typed Classes:
- `ArrayType` & `ArrayType::Proxy`
- `MappingType` & `MappingType::Proxy`
- `ContractType` & `ContractType::Proxy`
- ...





## Biggie - Multiple-Inheritance ("Diamond-Shaped") Support In Rubidity

Only code what you use. Remove unnecessary fluff.
All contracts in /app/models/contracts do NOT use any multiple-inheritance,
thus, do NOT add the baggage that no one uses.
Use a simple linear parents contract inhertiance chain!
Makes you code more secure by simplifying the rule for what function (contract method) gets called.  No "diamond-shaped" surprise possible.

Let's say it out lout - multiple-inheritance is a security nightmare and
design flaw in solidity - possibly inspired by python? (origin roots) definitely NOT ruby ;-).

Triva: Vyper - a "pythonic" more secure and simpler ("modern") solidity alternative is the other extreme:

> Q: What is not included in Vyper?
>
> The following constructs are not included because their use can lead to misleading or difficult to understand code:
>
> - Modifiers
> - **Class inheritance**
> - Inline assembly
> - ...





To be continued ...


