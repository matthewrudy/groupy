Groupy [![Build Status](https://travis-ci.org/matthewrudy/groupy.svg?branch=master)](https://travis-ci.org/matthewrudy/groupy)
=======

Categorise records into nested groups of values.

Example
=======

Define our groups

``` ruby
class Food
  property :dish, String

  include Groupy
  groupy :dish do
    group :healthy do
      group :fruit do
        value :apple
        value :orange
      end
      value :rice
    end

    group :unhealthy do
      value :fried_egg
      value :bacon
    end
  end
end
```

We can then ask a particular food:

``` ruby
apple.healthy?
apple.fruit?
apple.apple?
```

And we can scope the class by any of these groups

``` ruby
Food.apples.count
Food.fruits.all
```
  
We also get a magic "all_" method

``` ruby
Food.all_dishes
```

You can also tell groupy to add the column name as a suffix

``` ruby
class Something
  groupy :size, :suffix => true do
    value :small
    value :medium
    value :large
  end
end

something.small_size?
```
  
Or you may want to store all the values as a conveniently named constant.

``` ruby
class Something
  groupy :size, :constants => true do
    value :small
    value :medium
    value :large
  end
end

Something::SMALL
Something::MEDIUM
Something::LARGE
```
  
Or of course you can do both together

``` ruby
Something::SMALL_SIZE
Something::MEDIUM_SIZE
Something::LARGE_SIZE
```

Any values will be lowercased and underscored

``` ruby
class Something
  groupy :type do
    value :SomeClass
    value :"Namespace::KlassName"
  end
end

something.some_class?
something.namespace_klass_name? 
``` 
  
B00m!

Copyright (c) 2010 [Matthew Rudy Jacobs], released under the MIT license
