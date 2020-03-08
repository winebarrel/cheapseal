# frozen_string_literal: true

RSpec.describe Cheapseal::Staging do
  let(:staging) do
    Cheapseal::Staging.new(
      logger: Logger.new('/dev/null'),
      src_namespace: 'staging',
      dst_namespace: 'develop-my-branch-1-1-123'
    )
  end

  let(:kube_driver) do
    staging.instance_variable_get(:@kube_driver)
  end

  describe '#create' do
    specify do
      expect(kube_driver).to receive(:namespace_exist?).and_return(true)
      expect(kube_driver).to receive(:create_namespace)
      expect(kube_driver).to receive(:copy).with(resource: 'deploy', name: 'mysql')
      expect(kube_driver).to receive(:copy).with(resource: 'deploy', name: 'redis')
      staging.create(image: 'nginx:master', service: %w[app front], copy: %w[deploy/mysql deploy/redis])
    end
  end
end
