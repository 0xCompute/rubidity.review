# Rubidity O.G (Dumb Contracts) Public Code Review / (More) Tests


The idea is to look at the code as-is (that is, not suggestion new or alternate syntax) in the review / commentary 
and try to add (more) tests.

**Yes, you can.  You are welcome to join in and comments / discuss / debate.**




## "Off-Rails"  - Rubidity Core NOT "Isolated"

Let's say Rails is great. It's magic. It's amazing.

However, to make the rubidity core executiong engine
more secure (and smaller) less dependencies is more!

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
- [type.rb](type.rb)
- [typed_variable.rb](typed_variable.rb)
- [array_type.rb](array_type.rb)
- [mapping_type.rb](mapping_type.rb)


the great news - this code for the type machinery is basically "isolated"
and i recommend to move it to its own module as the foundation types (library) incl. the rspec tests.



### Serialize / Deserialize

The current code use a "typed var holder" class with "replace" semantics.
"Replace" semantics is flawed because you CANNOT replace, for example,
a bool true or false or (if added enums that are integer constants).

The better approach is to ALWAYS create a new typed var (and never "replace" inline). Once created you CANNOT change the value inplace.
Of course, if the typed var is a reference type such as array or mapping
you CAN change / replace the mapping items or array items.

The deserialize SHOULD not be method of typed variable 
because it assumes "replace" semantics. 




### Method Missing Magic & "Explicit" One-to-One Type Mappings Instead Of "Quick & Dirty" Generic Type "Wrappers" 

For now only mapping and array get an explicit typed class.
All other "value" types are (re)using a kind of genric typed class
that than delegates via method_missing to wherever.
Yes, a security and performance nightmare.
While this apprach may look like ingenius for being "quick & dirty"
it is a clasic anti-pattern / major design flaw, that is,
do NOT use method_missing UNLESS it is the last option.
And options are many with the preference of doing the hard work
coding and writing out all the types one by one!


### Layers, Layers, Layers (Proxies, Proxies, Proxies) - No Lasagna

The array and mapping typed variable use "proxy classes" inside
the typed variable. That proxy / layer inside the typed classes 
is redundant.  The typed variable / class is already the "proxy" or "front" to define the API for the type, thus, less is more.  better security
by keeping it simple.








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
> Modifiers
> **Class inheritance**
> Inline assembly
> ...





To be continued ...


