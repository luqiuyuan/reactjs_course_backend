ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def json_response
    ActiveSupport::JSON.decode @response.body
  end

  # Check if expected is included in actual
  # If they contains array, the array is handled in unordered way
  #
  # @param [Hash] expected
  # @param [Model] actual
  # @return [Boolean]
  #
  # Comment
  # The argument expected must be assigned to a variable first, otherwise it might be recognized as a block (Maybe)
  # Right way:
  #   expected = {id:1, name:"abc"}
  #   hash_equal expected, actual_model
  #   or
  #   hash_equal({id:1, name:"abc"}, actual_model)
  # Wrong way:
  #   hash_equal {id:1, name:"abc"}, actual_model
  def hash_included_unordered(expected, actual)
    expected.each do |key, value|
      if expected[key].class == Hash and actual[key.to_s].class == Hash
        if !hash_included_unordered expected[key], actual[key.to_s]
          return false
        end
      elsif expected[key].class == Array and actual[key.to_s].class == Array
        if !hash_included_array_unordered expected[key], actual[key.to_s]
          return false
        end
      else
        if expected[key] != actual[key.to_s]
          return false
        end
      end
    end
    return true
  end

  # Check if all elements in expected are included in actual
  #
  # @param [Array] expected
  # @param [Array] actual
  # @return [Boolean]
  def hash_included_array_unordered(expected, actual)
    # the two array must be consistent in size
    if expected.size != actual.size
      return false
    end

    expected.each do |item|
      found = false # indicates if the item is found
      if item.class == Hash
        for i in 0...actual.size
          if hash_included_unordered item, actual[i] # equal remaining to true indicates that the item has been found, break and test next item
            found = true
            break
          end
        end
      else
        if actual.include? item
          found = true
        end
      end
      if !found # if any item is not found, return false
        return false
      end
    end
    return true # every thing is fine...
  end


  # Check if expected is included in actual
  # If they contains array, the array is handled in ordered way
  #
  # @param [Hash] expected
  # @param [Model] actual
  # @return [Boolean]
  #
  # Comment
  # The argument expected must be assigned to a variable first, otherwise it might be recognized as a block (Maybe)
  # Right way:
  #   expected = {id:1, name:"abc"}
  #   hash_equal expected, actual_model
  #   or
  #   hash_equal({id:1, name:"abc"}, actual_model)
  # Wrong way:
  #   hash_equal {id:1, name:"abc"}, actual_model
  def hash_included_ordered(expected, actual)
    expected.each do |key, value|
      if expected[key].class == Hash and actual[key.to_s].class == Hash
        if !hash_included_ordered expected[key], actual[key.to_s]
          return false
        end
      elsif expected[key].class == Array and actual[key.to_s].class == Array
        if !hash_included_array_ordered expected[key], actual[key.to_s]
          return false
        end
      else
        if expected[key] != actual[key.to_s]
          return false
        end
      end
    end
    return true
  end

  # Check if all elements in expected are included in actual in ordered way
  #
  # @param [Array] expected
  # @param [Array] actual
  # @return [Boolean]
  def hash_included_array_ordered(expected, actual)
    # the two array must be consistent in size
    if expected.size != actual.size
      return false
    end

    for i in 0...expected.size
      if expected[i].class == Hash # Use hash_included_ordered if item is Hash, != otherwise
        if !hash_included_ordered expected[i], actual[i]
          return false
        end
      else
        if expected[i] != actual[i]
          return false
        end
      end
    end
    return true # every thing is fine...
  end

end
