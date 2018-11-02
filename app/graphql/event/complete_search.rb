module Searchers
  class CompleteSearch
    def self.search(kwargs)
      Event.where(**kwargs)
    end
  end
end