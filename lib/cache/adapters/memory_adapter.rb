require 'concurrent'

module SplitIoClient
  module Cache
    module Adapters
      class MemoryAdapter
        def initialize
          @map = Concurrent::Map.new
        end

        # Map
        def initialize_map(key)
          @map[key] = Concurrent::Map.new
        end

        def add_to_map(key, field, value)
          @map[key].put(field, value)
        end

        def find_in_map(key, field)
          return nil if @map[key].nil?

          @map[key].get(field)
        end

        def delete_from_map(key, field)
          @map[key].delete(field)
        end

        def in_map?(key, field)
          return false if @map[key].nil?

          @map[key].key?(field)
        end

        def map_keys(key)
          @map[key].keys
        end

        def get_map(key)
          @map[key]
        end

        # String
        def string(key)
          @map[key]
        end

        def set_string(key, str)
          @map[key] = str
        end

        def find_strings_by_prefix(prefix)
          @map.keys.select { |str| str.start_with? prefix }
        end

        # Bool
        def set_bool(key, val)
          @map[key] = val
        end

        def bool(key)
          @map[key]
        end

        # Set
        alias_method :initialize_set, :initialize_map
        alias_method :get_set, :map_keys
        alias_method :delete_from_set, :delete_from_map
        alias_method :in_set?, :in_map?

        def add_to_set(key, val)
          add_to_map(key, val, 1)
        end

        # General
        def exists?(key)
          !@map[key].nil?
        end

        def delete(key)
          @map[key] = nil
        end
      end
    end
  end
end
