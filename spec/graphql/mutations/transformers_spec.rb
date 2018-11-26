RSpec.describe Transformers do
  let(:transformer) { Transformers.for(event) }

  context 'with unknown source' do
    let(:event) do
      {
        "source"  => "unknown",
        "type"    => "classification"
      }
    end
    it 'returns nil' do
      expect(transformer).to be_nil
    end
  end

  context 'with unknown type' do
    let(:event) do
      {
        "source"  => "panoptes",
        "type"    => "unknown"
      }
    end
    it 'returns nil' do
      expect(transformer).to be_nil
    end
  end

  context 'with panoptes source and classification type' do
    let(:event) do
      {
        "source"  => "panoptes",
        "type"    => "classification"
      }
    end
    it 'returns PanoptesClassification' do
      expect(transformer).to be_an_instance_of(Transformers::PanoptesClassification)
    end
  end
end
