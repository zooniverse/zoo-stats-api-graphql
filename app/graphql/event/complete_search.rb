module Searchers
  class Complete
    def self.search(kwargs)
      Event.where(**kwargs)
    end
  end
end