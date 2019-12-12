# frozen_string_literal: true

class ItemsFetcher
  class << self
    attr_reader :provided_code

    def call(items:, code:)
      @provided_code = code
      items.group_by(&:code).keep_if { |k, _| match_provided_code?(k) }.values.flatten
    end

    private

    def match_provided_code?(code)
      code == provided_code
    end
  end
end
