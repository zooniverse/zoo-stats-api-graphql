RSpec.describe Geo do
  let(:search)       { Geo.locate(ip_address) }
  let(:country)      { "United Kingdom" }
  let(:country_code) { "UK" }
  let(:city)         { "Oxford" }
  let(:longitude)    { 100 }
  let(:latitude)     { -100 }

  context 'with parsable result' do
    before do
      result = double('result',
        :country => country,
        :country_code => country_code,
        :city => city,
        :longitude => longitude,
        :latitude => latitude
        )
      allow(Geocoder).to receive(:search).with("1.1.1.1").and_return([result])
    end

    context 'with no :ip_address' do
      let(:ip_address) {}
      
      it 'returns empty array' do
        expect(search).to match_array({})
      end
    end

    context 'with :ip_address' do
      let(:ip_address) { "1.1.1.1" }
      let(:expected_result) do
        {
          country_name: country,
          country_code: country_code,
          city_name:    city,
          latitude:     latitude,
          longitude:    longitude
        }
      end

      it 'returns array of values' do
        expect(search).to match_array(expected_result)
      end
    end
  end

  context 'with nil result' do
    before do
      allow(Geocoder).to receive(:search).with("1.1.1.1").and_return([])
    end

    let(:ip_address) { "1.1.1.1" }
    it 'returns empty array' do
      expect(search).to match_array({})
    end
  end

  context 'with StandardError' do
    before do
      allow(Geocoder).to receive(:search).with("1.1.1.1").and_raise(StandardError)
    end

    let(:ip_address) { "1.1.1.1" }
    it 'returns empty array' do
      expect(search).to match_array({})
    end
  end
end
