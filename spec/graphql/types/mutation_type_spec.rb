RSpec.describe Types::MutationType do
  subject { Types::MutationType }
  puts subject.fields
=begin
  # 'mutationName'        => 'Output_type', {
  #   'argumentName'      => 'Argument_type' }
  {
    'testfield'           => ['String!', {
      'testarg'           => 'String!'
    }]
  }.each do |field_name, expected_results|
    (expected_field_type, expected_arguments) = expected_results
    it 'matches field descriptions' do
      field_info = subject.fields[field_name]
      expect(field_info.type.to_type_signature).to eq(expected_field_type)
      expect(field_info.description).not_to be_nil

      expected_arguments.each do |arg_name, expected_arg_type|
        arg_info = field_info.arguments[arg_name]
        expect(arg_info.type.to_type_signature).to eq(expected_arg_type)
      end
    end
  end
=end
end