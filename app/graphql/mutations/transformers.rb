require_relative 'transformers/panoptes_classification'

module Transformers
  REGISTRY = {
    "panoptes" => {
      "classification" => Transformers::PanoptesClassification
    }
  }

  def self.for(event)
    source = event.fetch("source")
    type = event.fetch("type")

    klass = REGISTRY.fetch(source, {}).fetch(type, nil)
    klass.new(event) if klass
  end
end