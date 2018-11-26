RSpec.describe Types::EventType do
  subject { Types::EventType }

  # 'fieldName'          => 'Field_type'
  { 
    'eventId'            => 'ID!',
    'eventType'          => 'String!',
    'eventTime'          => 'ISO8601DateTime!',
    'eventCreatedAt'     => 'ISO8601DateTime',
    'eventSource'        => 'String!',
    'sessionTime'        => 'Float',
    'userId'             => 'ID',
    'projectId'          => 'ID',
    'workflowId'         => 'ID',
    'data'               => 'String',
    'geo'                => 'String',

    # output fields
    'period'             => 'ISO8601DateTime',
    'count'              => 'Int',
  }.each do |field_name, expected_field_type|
    it "has matching field: #{field_name}" do
      field_info = subject.fields[field_name]
      expect(field_info.type.to_type_signature).to eq(expected_field_type)
      expect(field_info.description).not_to be_nil
    end
  end
end