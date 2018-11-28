Rspec.describe Transformers::PanoptesClassification do
  subject(:panoptes_classification_transformer) { Transformers::PanoptesClassification.new(payload) }

  let(:event_id) { "18521902" }
  let(:event_type) { "classification" }
  let(:event_source) { "panoptes" }
  let(:finished_at) { "2016-10-10T12:59:46.795Z" }
  let(:project_id) { "764" }
  let(:workflow_id) { "2303" }
  let(:user_id) { "1" }

  let(:subject_ids) { ["3069945"] }
  let(:created_at) { "2016-10-10T12:59:48.233Z" }
  let(:updated_at) { "2016-10-10T12:59:48.293Z" }
  let(:user_ip) { "127.0.0.1" }
  let(:workflow_version) { "2.5" }
  let(:gold_standard) { nil }
  let(:expert_classifier) { nil }

  let(:started_at) { "2016-10-10T12:59:44.812Z" }
  let(:session) { "8c09ed53c6ee1b397d9ae6b6d1eef096a2c966debdc13678d2b151c8c82c3c8c" }
  let(:utc_offset) { "0" }
  let(:user_language) { "en" }

  let(:payload) do
    {
      "source" => event_source,
      "type" => event_type,
      "version" => "1.0.0",
      "timestamp" => "2016-10-10T12:59:48Z",
      "data" => {
        "id" => event_id,
        "created_at" => created_at,
        "updated_at" => updated_at,
        "user_ip" => user_ip,
        "workflow_version" => workflow_version,
        "gold_standard" =>  gold_standard,
        "expert_classifier" =>  expert_classifier,
        "annotations" => [
            {
              "task" => "init",
              "value" => 1
            }
        ],
        "metadata" => {
            "session" => session,
            "viewport" => {
              "width" => 1440,
              "height" => 661
            },
            "started_at" => started_at,
            "user_agent" => "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:49.0) Gecko/20100101 Firefox/49.0",
            "utc_offset" => utc_offset,
            "finished_at" => finished_at,
            "live_project" => true,
            "user_language" => user_language,
            "user_group_ids" => [

            ],
            "subject_dimensions" => [
              {
                  "clientWidth" => 480,
                  "clientHeight" => 480,
                  "naturalWidth" => 480,
                  "naturalHeight" => 480
              }
            ],
            "workflow_version" => "2.5"
        },
        "href" => "/classifications/18521902",
        "links" => {
            "project" => project_id,
            "user" => user_id,
            "workflow" => workflow_id,
            "workflow_content" => "2302",
            "subjects" => subject_ids
        }
      },
      "linked" => {
        "projects" => [
            {
              "id" => "764",
              "display_name" => "Pulsar Hunters",
              "created_at" => "2015-08-31T09:51:30.913Z",
              "href" => "/projects/764"
            }
        ],
        "users" => [
            {
              "id" => "1",
              "login" => "Zookeeper",
              "href" => "/users/1"
            }
        ],
        "workflows" => [
            {
              "id" => "2303",
              "display_name" => "Bluedot LOTAAS",
              "created_at" => "2016-07-22T16:47:46.489Z",
              "href" => "/workflows/2303"
            }
        ],
        "workflow_contents" => [
            {
              "id" => "2302",
              "created_at" => "2016-07-22T16:47:46.493Z",
              "updated_at" => "2016-07-22T18:03:04.964Z",
              "href" => "/workflow_contents/2302"
            }
        ],
        "subjects" => [
            {
              "id" => "3069945",
              "locations" => [
                {
                  "image/jpeg" => "https://panoptes-uploads.zooniverse.org/production/subject_location/5efcf7a2-2a6d-410b-afdf-0913552e5d18.jpeg"
                }
              ],
              "metadata" => {
                  "DM" => "35.48",
                  "S/N" => "4.4",
                  "Period" => "15.98"
              },
              "created_at" => "2016-07-22T16:51:33.679Z",
              "updated_at" => "2016-07-22T16:51:33.679Z",
              "href" => "/subjects/3069945"
            }
        ]
      }
    }
  end

  let(:expected_data) do
    {
      subject_id:              subject_ids.first,
      created_at:              DateTime.parse(created_at),
      updated_at:              DateTime.parse(updated_at),
      workflow_version:        workflow_version,
      gold_standard:           gold_standard,
      expert_classifier:       expert_classifier,
      metadata_started_at:     DateTime.parse(started_at),
      metadata_finished_at:    DateTime.parse(finished_at),
      metadata_session:        session,
      metadata_utc_offset:     utc_offset,
      metadata_user_language:  user_language
    }
  end
  let(:expected_session_time) { 2.0 }
  let(:geo_data) do
    {
      country_name: "United Kingdom",
      country_code: "UK",
      city_name:    "Oxford",
      latitude:     100,
      longitude:    -100
    }
  end

  let(:expected_result) do 
    {
      event_id:        event_id,
      event_type:      event_type,
      event_source:    event_source,
      event_time:      DateTime.parse(finished_at),
      project_id:      project_id,
      workflow_id:     workflow_id,
      user_id:         user_id,
      data:            expected_data,
      session_time:    expected_session_time,
      country_name:    geo_data[:country_name],
      country_code:    geo_data[:country_code],
      city_name:       geo_data[:city_name],
      latitude:        geo_data[:latitude],
      longitude:       geo_data[:longitude]
    }
  end

  before do
    allow(Geo).to receive(:locate).with(user_ip).and_return(geo_data)
  end

  it 'returns a hash with expected data' do
    transformed_payload = panoptes_classification_transformer.transform
    expect(transformed_payload).to eq(expected_result)
  end
end
