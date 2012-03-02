# EMC Confidential Information, protected under EMC Bilateral Non-Disclosure Agreement.
# Copyright © 2012 EMC Corporation, All Rights Reserved


module ProjectRazor
  module Tagging
    class TagMatcher < ProjectRazor::Object
      include(ProjectRazor::Logging)

      attr_accessor :key          # the attribute key we want to match
      attr_accessor :compare      # either :equal or :like
      attr_accessor :value        # value as String - if @compare == :like then will be converted to Regex
      attr_accessor :inverse      # true = flip operation result

      # Equal to
      # Not Equal to
      # Like
      # Not Like

      # Key Equal to String | Not
      # Key Like String(Regex) | not

      def initialize(hash)
        from_hash(hash) unless hash == nil
      end

      # @param property_value [String]
      def check_for_match(property_value)
        ret = true
        ret = false unless @inverse == false

        case compare
          when :equal
            logger.debug "Checking if key:#{@key}=#{property_value} is equal to matcher value:#{@value}"
            if property_value == @value
              logger.debug "Match found"
              return ret
            else
              logger.debug "Match not found"
              return !ret
            end
          when :like
            logger.debug "Checking if key:#{@key}=#{property_value} is like matcher pattern:#{@value}"
            reg_ex = Regexp.new(@value)
            if (reg_ex =~ property_value) != nil
              logger.debug "Match found #{ret}"
              return ret
            else
              logger.debug "Match not found #{!ret}"
              return !ret
            end
          else
            logger.error "Bad compare symbol"
            return :error
        end
      end


    end
  end
end
