# frozen_string_literal: true

RSpec.describe Cheapseal::CLI do
  let(:cli) do
    Cheapseal::CLI.new
  end

  describe '#create' do
    specify do
      expect_any_instance_of(Cheapseal::Staging).to receive(:create).with(
        branch: 'develop/my_branch-1.1',
        number: '123',
        image: 'nginx:master'
      )

      cli.create('develop/my_branch-1.1', '123', 'nginx:master')
    end
  end

  describe '#delete' do
    specify do
      expect_any_instance_of(Cheapseal::Staging).to receive(:delete).with(
        branch: 'develop/my_branch-1.1',
        number: '123'
      )

      cli.delete('develop/my_branch-1.1', '123')
    end
  end
end
