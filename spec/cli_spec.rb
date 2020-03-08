# frozen_string_literal: true

RSpec.describe Cheapseal::CLI do
  let(:cli) do
    Cheapseal::CLI.new
  end

  describe '#create' do
    specify do
      allow(cli).to receive(:options).and_return(
        src: 'staging',
        branch: 'develop/my_branch-1.1',
        number: 123,
        image: 'nginx:master',
        service: %w[app front],
        copy: %w[deploy/mysql deploy/redis]
      )
      expect_any_instance_of(Cheapseal::Staging).to receive(:create).with(
        image: 'nginx:master',
        service: %w[app front],
        copy: %w[deploy/mysql deploy/redis]
      )
      cli.create
    end
  end

  describe '#delete' do
    specify do
      allow(cli).to receive(:options).and_return(
        src: 'staging',
        branch: 'develop/my_branch-1.1',
        number: 123
      )
      expect_any_instance_of(Cheapseal::Staging).to receive(:delete)
      cli.delete
    end
  end

  describe '#namespace' do
    specify do
      allow(cli).to receive(:options).and_return(
        branch: 'develop/my_branch-1.1',
        number: 123
      )
      expect(Cheapseal::Sanitizer).to receive(:branch_to_kube_ns)
        .with(branch: 'develop/my_branch-1.1', number: 123).and_return('develop-my-branch-1-1-123')
      expect($stdout).to receive(:puts).with('develop-my-branch-1-1-123')
      cli.namespace
    end
  end
end
