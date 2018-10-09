RSpec.describe Types::EventType do
  subject { Types::EventType }

  shared_examples_for 'an expected field' do |(field_name), field_type|
    subject { Types::EventType.fields[field_name] }
    it { expect(subject.type.to_type_signature).to eq(field_type) }
  end

  { 
    # event specific fields
    ['eventId']            => 'ID!',
    ['eventType']          => 'String',
    ['eventTime']          => 'ISO8601DateTime!',
    ['eventCreatedAt']     => 'ISO8601DateTime',
    ['eventSource']        => 'String!',
  
    # user fields
    ['userId']             => 'ID',
    ['userZooniverseId']   => 'ID',
    ['zooniverseId']       => 'ID',
    ['lang']               => 'String',
    ['userAgent']          => 'String',
    ['userName']           => 'String',
  
    # project fields
    ['projectId']          => 'ID',
    ['projectName']        => 'String',
    ['workflowId']         => 'ID',
    ['subjectIds']         => 'String',
    ['subjectUrls']        => 'String',
  
    # discussion board fields
    ['boardId']            => 'ID',
    ['board']              => 'String',
    ['discussionId']       => 'ID',
    ['focus']              => 'String',
    ['focusId']            => 'ID',
    ['focusType']          => 'String',
    ['section']            => 'String',
    ['body']               => 'String',
    ['url']                => 'String',
    ['tags']               => 'String',
  }.each do |input, output|
    it_behaves_like 'an expected field', input, output
  end
end