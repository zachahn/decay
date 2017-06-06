module Decay
  class Metaprogramming
    def initialize(class:, enumerated_type:, enumerated_type_name:)
      @klass = binding.local_variable_get(:class)
      @enumerated_type = enumerated_type
      @enumerated_type_name = enumerated_type_name
    end

    def define_enumerated_type
      @klass.const_set(@enumerated_type_name.to_s.upcase, @enumerated_type)
    end

    def define_getter
      enumerated_type_name = @enumerated_type_name

      assert_instance_conflict_free(enumerated_type_name)
      @klass.send(:define_method, enumerated_type_name) do
        instance_variable_get("@#{enumerated_type_name}")
      end
    end

    def define_setter
      enumerated_type = @enumerated_type
      enumerated_type_name = @enumerated_type_name

      assert_instance_conflict_free("#{enumerated_type_name}=")
      @klass.send(:define_method, "#{enumerated_type_name}=") do |new_value|
        value =
          if new_value.respond_to?(:to_sym)
            new_value.to_sym
          else
            new_value
          end

        enum = enumerated_type[value]

        instance_variable_set("@#{enumerated_type_name}", enum)
      end
    end

    def define_bang_setters
      enumerated_type_name = @enumerated_type_name

      @enumerated_type.each do |key, value|
        if key.nil?
          next
        end

        assert_instance_conflict_free("#{key}!")
        @klass.send(:define_method, "#{key}!") do
          instance_variable_set("@#{enumerated_type_name}", value)
        end
      end
    end

    def define_question_getters
      enumerated_type_name = @enumerated_type_name

      @enumerated_type.each do |key, value|
        if key.nil?
          next
        end

        assert_instance_conflict_free("#{key}?")
        @klass.send(:define_method, "#{key}?") do
          instance_variable_get("@#{enumerated_type_name}") == value
        end
      end
    end

    def define_active_record_attribute
      @klass.attribute @enumerated_type_name, \
        Decay::ActiveEnumAttribute.new(enum: @enumerated_type)
    end

    def define_active_record_bang_setters
      enumerated_type_name = @enumerated_type_name

      @enumerated_type.each do |key, _value|
        if key.nil?
          next
        end

        assert_instance_conflict_free("#{key}!")
        @klass.send(:define_method, "#{key}!") do
          send("#{enumerated_type_name}=", key)
        end
      end
    end

    def define_active_record_question_getters
      enumerated_type_name = @enumerated_type_name

      @enumerated_type.each do |key, value|
        if key.nil?
          next
        end

        assert_instance_conflict_free("#{key}?")
        @klass.send(:define_method, "#{key}?") do
          send(enumerated_type_name) == value
        end
      end
    end

    def define_active_record_scopes
      enumerated_type_name = @enumerated_type_name

      @enumerated_type.each do |key, value|
        if key
          assert_scope_conflict_free(key)
          @klass.scope key, -> { where(enumerated_type_name => value.value) }
        end
      end
    end

    private

    def assert_instance_conflict_free(method_name)
      if @klass.instance_methods.include?(method_name.to_sym)
        previously_defined_method = @klass.instance_method(method_name)
        filename, lineno = previously_defined_method.source_location

        raise Error::EnumConflict, \
          "Instance method `#{method_name}` was previously defined " \
          "in #{filename}:#{lineno}"
      end
    end

    def assert_scope_conflict_free(method_name)
      if @klass.methods.include?(method_name.to_sym)
        previously_defined_method = @klass.method(method_name)
        filename, lineno = previously_defined_method.source_location

        raise Error::EnumConflict, \
          "Scope `#{method_name}` was previously defined " \
          "in #{filename}:#{lineno}"
      end
    end
  end
end
