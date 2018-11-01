class Event::CompleteSearch
  def self.search(kwargs)
    Event.where(**kwargs)
  end
end