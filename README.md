# CerealEyes

[![Build Status](https://secure.travis-ci.org/seejohnrun/cereal_eyes.png)](http://travis-ci.org/seejohnrun/cereal_eyes)

CerealEyes is a proof-of-concept serialization DSL based on [google-gson](http://code.google.com/p/google-gson/).

Basically, you define models that look like:

``` ruby
class SampleDocument
  attributes :name, :default => 'no name'
  attributes :age, :deserialize => false
end
```

And that allows you to do:

``` ruby
doc = SampleDocument.new
doc.age = 24
doc.serialize # { :name => 'no name', :age => 24 }
```

and

``` ruby
doc = SampleDocument.deserialize :name => 'hello', :age => 24
doc.name # "hello"
doc.age # nil
```

Nesting is handled seamlessly (see :type below), and it's perdy cool:

``` ruby
class SomeDocument
  attributes :some_document, :type => self
  attributes :name, :default => 'hi'
end

doc = SomeDocument.new
doc.some_document = SomeDocument.new
doc.serialize # { :name => 'hi', :some_document => { :name => 'hi' } }
```

---

## Basic Options

* `:deserialize [Boolean]` - Whether or not a particular attribute should come back in deserializations (default true)
* `:serialize [Boolean]` - Whether or not a particular attribute should go out in serializations (default true)
* `:default [Object]` - The default for this field if not supplied (applied to serialization and deserialization)
* `:squash_nil [Boolean]` - Whether or not to keep nils around for values that are empty (default true)
* `:type [Class]` - What type of class should be used to deserialize a certain attribute.  Must be a kind_of CerealEyes::Document
* `:name [String]` - An alias to give the attribute in serialization (and consequently deserialization)

---

## License

(The MIT License)

Copyright © 2011 John Crepezzi

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ‘Software’), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED ‘AS IS’, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. !
