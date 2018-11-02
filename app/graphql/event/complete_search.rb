module Searchers
  class Complete
    def search(kwargs)
      Event.where(**kwargs)
    end
  end
end