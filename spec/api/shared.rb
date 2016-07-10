require_relative 'api_spec_helper'

module DiceOfDebt
  shared_examples 'GET using a non-existent resource id' do |type, parameter = 'id'|
    it { expect_error 404 }

    subject { error }

    its([:status]) { should eq '404' }
    its([:title])  { should eq "Could not find #{type}" }
    its([:detail]) { should eq "Could not find a #{type} with id 9999" }
    its([:source]) { should eq parameter: parameter }
  end

  shared_examples 'GET using an invalid resource id' do |type, parameter = 'id'|
    it { expect_error 422 }

    subject { error }

    its([:status]) { should eq '422' }
    its([:title])  { should eq "Invalid #{type} id" }
    its([:detail]) { should eq "The provided #{type} id 'foo' should be numeric" }
    its([:source]) { should eq parameter: parameter }
  end
end
