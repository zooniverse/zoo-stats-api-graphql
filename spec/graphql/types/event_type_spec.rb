RSpec.describe Types::EventType do
  subject { Types::EventType }

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
  }.each do |field_name, expected_field_type|
    it '' do
      field_type = subject.fields[field_name].type.to_type_signature
      expect(field_type).to eq(expected_field_type)
    end
  end
end