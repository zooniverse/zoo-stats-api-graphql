RSpec.describe Types::EventType do
  subject { Types::EventType }

  # 'fieldName'          => 'Field_type'
  { 
    # event specific fields
    'eventId'            => 'ID!',
    'eventType'          => 'String',
    'eventTime'          => 'ISO8601DateTime!',
    'eventCreatedAt'     => 'ISO8601DateTime',
    'eventSource'        => 'String!',
  
    # user fields
    'userId'             => 'ID',
    'userZooniverseId'   => 'ID',
    'zooniverseId'       => 'ID',
    'lang'               => 'String',
    'userAgent'          => 'String',
    'userName'           => 'String',
  
    # project fields
    'projectId'          => 'ID',
    'projectName'        => 'String',
    'workflowId'         => 'ID',
    'subjectIds'         => 'String',
    'subjectUrls'        => 'String',
  
    # discussion board fields
    'boardId'            => 'ID',
    'board'              => 'String',
    'discussionId'       => 'ID',
    'focus'              => 'String',
    'focusId'            => 'ID',
    'focusType'          => 'String',
    'section'            => 'String',
    'body'               => 'String',
    'url'                => 'String',
    'tags'               => 'String',

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